// @license
// Copyright (c) ggdna
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

// Moves the documentation of a repo into the language-first structure:
//
//   doc/<lang>/...                 documentation that belongs to no quarter
//   pm/<lang>/<yyyy>-Q<n>/<kind>/  everything planned or written in a quarter
//
// English used to live directly in `doc`, every other language in
// `doc/<lang>`. Quarter folders `doc/<yyyy>-Q<n>` move to `pm/en/…`,
// `doc/de/<yyyy>-Q<n>` to `pm/de/…`. Planning folders that lay next to the
// quarters (goals, requirements, team, blog, …) move into a quarter: the blog
// by the date of each post, the rest into the newest quarter. Inside a
// quarter loose `decisions`, `topics` and `ux` move into `concepts/` and
// `schedule.md` moves to `charts/`. Everything else of `doc` moves to
// `doc/<lang>/`; `doc/guides` and `doc/templates` belong to the DNA and are
// left alone. Relative markdown links are rewritten, and the run fails when
// it turns a working link into a dead one. Paths to moved files and folders
// in code and config files, like `'doc/svg/x.svg'` in a test, and in the
// text of markdown files, like `doc/claude/history.md` in CLAUDE.md, are
// rewritten as well; files the DNA generated are left to the DNA.
//
// A code repo keeps only its blog in `pm/`: its loose architecture,
// decisions and other planning folders stay documentation in `doc/<lang>/`.
// Quarter folders `doc/<yyyy>-Q<n>` hold planning and move to `pm/` in every
// repo. A repo
// whose name ends in `_pm` or `-pm` is a PM repo; `--pm` or `--code` decide
// for any other name.
//
// Run it in the root of a repo:
//
//   dart run <path>/tool/migrate_doc_structure.dart [--dry-run] [--pm|--code]
//
// A second run changes nothing. Read the README afterwards: link texts
// that name an old path keep their text, tables may need formatting.

import 'dart:convert';
import 'dart:io';

final _quarterRe = RegExp(r'^\d{4}-Q[1-4]$');
final _langRe = RegExp(r'^[a-z]{2}$');

/// Two-letter codes that name a language folder. `ux`, `ui` or `db` are
/// folders of their own, not languages.
const _knownLanguages = {
  'ar',
  'cs',
  'da',
  'de',
  'el',
  'en',
  'es',
  'fa',
  'fi',
  'fr',
  'he',
  'hi',
  'hu',
  'it',
  'ja',
  'ko',
  'nl',
  'no',
  'pl',
  'pt',
  'ro',
  'ru',
  'sv',
  'tr',
  'uk',
  'zh',
};

/// Whether [name] is the folder of a language.
bool _isLang(String name) =>
    _langRe.hasMatch(name) &&
    !_quarterKinds.contains(name) &&
    _knownLanguages.contains(name);
final _datePrefixRe = RegExp(r'^(\d{4})-(\d{2})-(\d{2})-');

/// Folders that belong into a quarter of `pm/<lang>`.
const _quarterKinds = {
  'architecture',
  'blog',
  'bugs',
  'charts',
  'decisions',
  'exports',
  'goals',
  'meetings',
  'prompts',
  'reports',
  'requirements',
  'team',
  'tickets',
  'topics',
  'ux',
  'concepts',
};

/// Planning files that lie loose next to the quarter folders; they move to
/// the top of the newest quarter.
const _quarterFiles = {
  'plan.md',
  'next-steps.md',
  'milestones.md',
  'innovation-goals.md',
  'roadmap.md',
};

/// Folders the DNA places; never moved by this script.
const _dnaOwned = {'guides', 'templates'};

late final String _root;
late final bool _dryRun;

/// Whether the repo is a PM repo; a code repo keeps only its blog in `pm/`.
late final bool _isPmRepo;

/// Whether the loose folder [name] of `doc` moves into a quarter.
bool _movesToQuarter(String name) =>
    _quarterKinds.contains(name) && (_isPmRepo || name == 'blog');

/// old path (relative, posix) -> new path
final _moves = <String, String>{};
final _warnings = <String>[];

void main(List<String> args) {
  _dryRun = args.contains('--dry-run');
  _root = Directory.current.path;
  _isPmRepo =
      args.contains('--pm') ||
      (!args.contains('--code') && RegExp(r'[_-]pm$').hasMatch(_base(_root)));
  if (!Directory('$_root/doc').existsSync()) {
    print('No doc folder — nothing to do.');
    return;
  }

  _readDnaInstances();
  final deadBefore = _deadLinks(_allMarkdown());

  _planLanguage('en', 'doc');
  for (final dir in _subDirs('doc')) {
    final name = _base(dir);
    if (_isLang(name) && name != 'en') _planLanguage(name, dir);
  }
  _planFile('doc/ticket-counter.json', 'pm/ticket-counter.json');

  // Remove no-op moves and detect collisions.
  _moves.removeWhere((from, to) => from == to);
  final targets = <String, String>{};
  for (final e in _moves.entries) {
    final other = targets[e.value];
    if (other != null) {
      _fail('Both $other and ${e.key} would move to ${e.value}');
    }
    targets[e.value] = e.key;
    if (File('$_root/${e.value}').existsSync() &&
        !_moves.containsKey(e.value)) {
      _fail('${e.value} exists already; ${e.key} cannot move there');
    }
  }

  if (_moves.isEmpty) {
    if (!_dryRun) _rewriteDnaConfig();
    print('The documentation has the new structure already.');
    return;
  }

  // Read every markdown file before moving, with its old location.
  final markdown = {
    for (final p in _allMarkdown()) p: File('$_root/$p').readAsStringSync(),
  };

  if (_dryRun) {
    for (final e in _moves.entries) {
      print('${e.key} -> ${e.value}');
    }
    for (final f in _rewriteCodePaths()) {
      print('Would rewrite the paths in $f');
    }
    _printWarnings();
    print('Would move ${_moves.length} files.');
    return;
  }

  for (final e in _moves.entries) {
    final target = File('$_root/${e.value}');
    target.parent.createSync(recursive: true);
    File('$_root/${e.key}').renameSync(target.path);
  }
  _removeEmptyDirs('doc');

  // Rewrite the links of every markdown file at its new location.
  var rewritten = 0;
  for (final e in markdown.entries) {
    final oldPath = e.key;
    final newPath = _moves[oldPath] ?? oldPath;
    final text = _rewriteLinks(e.value, oldPath, newPath);
    if (text != e.value) {
      File('$_root/$newPath').writeAsStringSync(text);
      rewritten++;
    }
  }

  _rewriteDnaConfig();
  final code = _rewriteCodePaths();

  final deadAfter = _deadLinks(_allMarkdown());
  final newDead = deadAfter.difference(
    deadBefore.map((d) => _mapDead(d)).toSet(),
  );
  _printWarnings();
  print('Moved ${_moves.length} files, rewrote links in $rewritten files.');
  for (final f in code) {
    print('Rewrote the paths in $f');
  }
  if (newDead.isNotEmpty) {
    stderr.writeln('Dead links after the move:');
    for (final d in newDead.toList()..sort()) {
      stderr.writeln('  $d');
    }
    exitCode = 1;
  }
}

// .............................................................................
// Paths in code

/// Extensions of the code and config files whose paths are rewritten.
const _codeExtensions = {
  '.dart',
  '.ts',
  '.tsx',
  '.js',
  '.mjs',
  '.cjs',
  '.json',
  '.jsonc',
  '.yaml',
  '.yml',
  '.sh',
  '.ps1',
  '.py',
  '.html',
  '.css',
  '.toml',
  '.txt',
};

/// Files that never get their paths rewritten: history and lock files.
const _keepPaths = {
  'CHANGELOG.md',
  'pubspec.lock',
  'pnpm-lock.yaml',
  'package-lock.json',
  'yarn.lock',
};

/// The old paths of the moved files and folders and their new ones. A folder
/// counts when everything below it moved to one new folder; a folder that
/// keeps a file, e.g. of the DNA, is left out.
Map<String, String> _pathMap() {
  final dirs = <String, String?>{};
  for (final e in _moves.entries) {
    final from = e.key.split('/');
    final to = e.value.split('/');
    var same = 0;
    while (same < from.length &&
        same < to.length &&
        from[from.length - 1 - same] == to[to.length - 1 - same]) {
      same++;
    }
    for (var i = 1; i < from.length - 1; i++) {
      final oldDir = from.sublist(0, from.length - i).join('/');
      final newDir = i < same ? to.sublist(0, to.length - i).join('/') : null;
      if (dirs.containsKey(oldDir) && dirs[oldDir] != newDir) {
        dirs[oldDir] = null;
      } else {
        dirs.putIfAbsent(oldDir, () => newDir);
      }
    }
  }
  final stillThere = _dryRun
      ? (String d) => _files(d).any((f) => !_moves.containsKey(f))
      : (String d) => Directory('$_root/$d').existsSync();
  // A folder that moves into a quarter is left out: code that builds paths
  // below it would put new files into that one quarter forever.
  return {
    for (final e in dirs.entries)
      if (e.value != null && !e.value!.startsWith('pm/') && !stillThere(e.key))
        e.key: e.value!,
    ..._moves,
  };
}

/// Rewrites the paths of moved files and folders in the code, config and
/// markdown files, and returns the files it changed — in a dry run the
/// files it would change.
List<String> _rewriteCodePaths() {
  final map = _pathMap();
  if (map.isEmpty) return [];
  final ls = Process.runSync('git', [
    'ls-files',
    '-z',
  ], workingDirectory: _root);
  if (ls.exitCode != 0) return [];
  final olds = map.keys.toList()..sort((a, b) => b.length - a.length);
  // A path starts the text or follows a quote, a bracket, whitespace or
  // `=`/`,`, optionally behind `./` or `../`; `x/doc/…` or a URL is
  // another path. It ends before anything that cannot continue a name.
  final pattern = RegExp(
    '(?<=(?:^|[\\s\'"`(\\[{=,])(?:\\.\\.?/)*)'
    '(${olds.map(RegExp.escape).join('|')})'
    '(?![A-Za-z0-9_\\-]|\\.[A-Za-z0-9_])',
    multiLine: true,
  );
  final changed = <String>[];
  // Code and config files outside doc, pm and dna, plus every markdown file
  // at its place after the move: CLAUDE.md, READMEs and the docs name paths
  // in backticks and text, not only in links.
  final paths = <String>{
    for (final f in (ls.stdout as String).split('\u0000'))
      if (f.trim().isNotEmpty &&
          !RegExp(r'^(doc|pm|dna|node_modules)/').hasMatch(f.trim()) &&
          (_codeExtensions.any(f.trim().toLowerCase().endsWith) ||
              f.trim().toLowerCase().endsWith('.md')))
        f.trim(),
    if (!_dryRun) ..._allMarkdown(),
  };
  for (final path in paths) {
    // What the DNA generated stays as it is: the next DNA build replaces it.
    if (_keepPaths.contains(_base(path)) || _dnaInstances.contains(path)) {
      continue;
    }
    final file = File('$_root/$path');
    if (!file.existsSync()) continue;
    final bytes = file.readAsBytesSync();
    final String text;
    try {
      text = utf8.decode(bytes);
    } on FormatException {
      continue; // not UTF-8
    }
    final rewritten = text.replaceAllMapped(pattern, (m) => map[m[1]]!);
    if (rewritten == text) continue;
    changed.add(path);
    if (_dryRun) continue;
    // Decoding drops a byte order mark; it is written back.
    final bom =
        bytes.length >= 3 &&
        bytes[0] == 0xEF &&
        bytes[1] == 0xBB &&
        bytes[2] == 0xBF;
    file.writeAsBytesSync([
      if (bom) ...[0xEF, 0xBB, 0xBF],
      ...utf8.encode(rewritten),
    ]);
  }
  return changed;
}

// .............................................................................
// Planning

void _planLanguage(String lang, String base) {
  final quarters = <String>[];
  for (final dir in _subDirs(base)) {
    final name = _base(dir);
    if (_quarterRe.hasMatch(name)) quarters.add(name);
  }
  quarters.sort();
  final newest = quarters.isNotEmpty ? quarters.last : _currentQuarter();

  for (final q in quarters) {
    for (final f in _files('$base/$q')) {
      final rest = f.substring('$base/$q/'.length);
      _planFile(f, 'pm/$lang/$q/${_inQuarter(rest)}');
    }
  }

  for (final entry in _entries(base)) {
    final name = _base(entry);
    if (_quarterRe.hasMatch(name)) continue;
    if (_dnaOwned.contains(name)) continue;
    if (base == 'doc' && _isLang(name)) continue; // other languages
    if (base == 'doc' && name == 'ticket-counter.json') continue;
    final isDir = Directory('$_root/$entry').existsSync();
    if (isDir && _movesToQuarter(name)) {
      for (final f in _files(entry)) {
        final rest = f.substring('$entry/'.length);
        final q = _quarterFor(name, rest, newest);
        _planFile(
          f,
          'pm/$lang/$q/${_inQuarter('$name/${_stripQuarter(name, rest)}')}',
        );
      }
    } else if (_isPmRepo && name == 'schedule.md') {
      _planFile(entry, 'pm/$lang/$newest/charts/schedule.md');
    } else if (_isPmRepo && !isDir && _quarterFiles.contains(name)) {
      _planFile(entry, 'pm/$lang/$newest/$name');
    } else {
      // Documentation that belongs to no quarter.
      final files = isDir ? _files(entry) : [entry];
      for (final f in files) {
        _planFile(f, 'doc/$lang/${f.substring('$base/'.length)}');
      }
    }
  }
}

/// Maps a path inside a quarter to its place in the new quarter layout:
/// decisions, topics and ux live in `concepts/`, the schedule in `charts/`.
String _inQuarter(String rest) {
  final first = rest.split('/').first;
  if ({'decisions', 'topics', 'ux'}.contains(first)) return 'concepts/$rest';
  if (rest == 'schedule.md') return 'charts/schedule.md';
  return rest;
}

/// The quarter a loose file goes to: a file below a quarter folder stays in
/// that quarter; blog posts, exports and meetings go by the date of their
/// file name, else by their `<yyyy>/<mm>` folders; the rest goes into the
/// newest quarter.
String _quarterFor(String kind, String rest, String newest) {
  final parts = rest.split('/');
  if (parts.length > 1 && _quarterRe.hasMatch(parts.first)) return parts.first;
  if (kind != 'blog' && kind != 'exports' && kind != 'meetings') {
    return newest;
  }
  final m = _datePrefixRe.firstMatch(parts.last);
  if (m != null) {
    return _quarterOf(int.parse(m.group(1)!), int.parse(m.group(2)!));
  }
  final year = parts.length > 1 && RegExp(r'^\d{4}$').hasMatch(parts[0])
      ? int.parse(parts[0])
      : null;
  if (year == null) return newest;
  final month = parts.length > 2 && RegExp(r'^\d{2}$').hasMatch(parts[1])
      ? int.parse(parts[1])
      : null;
  if (month != null) return _quarterOf(year, month);
  // A year folder alone: the newest quarter of that year that exists in the
  // repo, else its last quarter.
  return newest.startsWith('$year-') ? newest : '$year-Q4';
}

String _quarterOf(int year, int month) => '$year-Q${(month - 1) ~/ 3 + 1}';

/// Drops year and quarter folders: `blog/2026/x.md` -> `x.md`,
/// `reports/2026-Q4/x.md` -> `x.md`.
String _stripQuarter(String kind, String rest) {
  final parts = rest.split('/');
  while (parts.length > 1 &&
      (_quarterRe.hasMatch(parts.first) ||
          RegExp(r'^\d{4}$').hasMatch(parts.first) ||
          (kind == 'blog' && RegExp(r'^\d{2}$').hasMatch(parts.first)))) {
    parts.removeAt(0);
  }
  return parts.join('/');
}

void _planFile(String from, String to) {
  if (!File('$_root/$from').existsSync()) return;
  if (_dnaInstances.contains(from)) return; // the DNA places it anew
  if (_base(from) == '.gitkeep' &&
      _moves.values.any((v) => _dir(v) == _dir(to))) {
    return;
  }
  _moves[from] = to;
}

/// The files the DNA instantiated, from `dna/_generated.json`. They are
/// never moved or rewritten: the next DNA build places them at their new
/// path and removes the old ones.
final _dnaInstances = <String>{};

void _readDnaInstances() {
  final file = File('$_root/dna/_generated.json');
  if (!file.existsSync()) return;
  final json = jsonDecode(file.readAsStringSync());
  if (json is! Map<String, dynamic>) return;
  for (final i in (json['instances'] as List<dynamic>? ?? const [])) {
    final path = (i as Map<String, dynamic>)['path'];
    if (path is String) _dnaInstances.add(path);
  }
}

/// Whether [p] below `doc/` is a file or folder the DNA places.
bool _isDnaPath(String p) {
  if (!p.startsWith('doc/')) return false;
  final first = p.split('/')[1];
  if (_isLang(first) || _quarterRe.hasMatch(first)) return false;
  if (_dnaOwned.contains(first)) return true;
  return _dnaInstances.contains(p) ||
      _dnaInstances.any((i) => i.startsWith('$p/'));
}

bool _isDnaOwned(String p) {
  if (_dnaInstances.contains(p)) return true;
  for (final d in _dnaOwned) {
    if (p == 'doc/$d' || p.startsWith('doc/$d/')) return true;
    if (p == 'doc/en/$d' || p.startsWith('doc/en/$d/')) return true;
  }
  return false;
}

String _currentQuarter() {
  final now = DateTime.now();
  return '${now.year}-Q${(now.month - 1) ~/ 3 + 1}';
}

/// Points the `doc/…` paths of `dna/_dna.json`, e.g. the CLAUDE.md
/// includes, to the English folder: `"doc/conventions"` ->
/// `"doc/en/conventions"`.
void _rewriteDnaConfig() {
  final file = File('$_root/dna/_dna.json');
  if (!file.existsSync()) return;
  final text = file.readAsStringSync();
  final updated = text.replaceAllMapped(RegExp(r'"doc/([^"]+)"'), (m) {
    final rest = m.group(1)!;
    final first = rest.split('/').first;
    if (_isLang(first)) return m.group(0)!;
    return '"doc/en/$rest"';
  });
  if (updated != text) file.writeAsStringSync(updated);
}

// .............................................................................
// Links

final _linkRe = RegExp(
  r'(\]\()([^)\s]+)((?:\s+"[^"]*")?\))|(^[ ]{0,3}\[[^\]\n]+\]:[ \t]+)(\S+)|(\bsrc=")([^"]+)(")',
  multiLine: true,
);
final _fenceRe = RegExp(r'^```[\s\S]*?^```', multiLine: true);

String _rewriteLinks(String text, String oldPath, String newPath) {
  // Leave fenced code alone: its paths are examples, not links.
  final out = StringBuffer();
  var last = 0;
  for (final f in _fenceRe.allMatches(text)) {
    out.write(_rewriteProse(text.substring(last, f.start), oldPath, newPath));
    out.write(f.group(0));
    last = f.end;
  }
  out.write(_rewriteProse(text.substring(last), oldPath, newPath));
  return out.toString();
}

String _rewriteProse(String text, String oldPath, String newPath) {
  return text.replaceAllMapped(_linkRe, (m) {
    final pre = m.group(1) ?? m.group(4) ?? m.group(6)!;
    final target = m.group(2) ?? m.group(5) ?? m.group(7)!;
    final post = m.group(3) ?? m.group(8) ?? '';
    final mapped = _mapTarget(target, oldPath, newPath);
    return '$pre$mapped$post';
  });
}

String _mapTarget(String target, String oldPath, String newPath) {
  if (_isExternal(target)) return target;
  final hash = target.indexOf('#');
  final pathPart = hash >= 0 ? target.substring(0, hash) : target;
  final anchor = hash >= 0 ? target.substring(hash) : '';
  if (pathPart.isEmpty) return target;
  final encoded = pathPart.contains('%');
  final oldAbs = _normalize('${_dir(oldPath)}/${_decode(pathPart)}');
  final newAbs = _mapPath(oldAbs);
  final rel = _relative(newAbs, _dir(newPath));
  if (newAbs == oldAbs && _dir(oldPath) == _dir(newPath)) return target;
  return '${encoded ? rel.replaceAll(' ', '%20') : rel}$anchor';
}

/// Where a file or folder of the old layout lives now.
String _mapPath(String oldAbs) {
  final direct = _moves[oldAbs];
  if (direct != null) return direct;
  // A folder: the common new folder of the files below it. A file that kept
  // its path below the folder gives the folder's new place; one that moved
  // elsewhere, like a blog post into a quarter, gives the folder it landed
  // in.
  final below = _moves.entries.where((e) => e.key.startsWith('$oldAbs/')).map((
    e,
  ) {
    final rest = e.key.substring(oldAbs.length);
    return e.value.endsWith(rest)
        ? e.value.substring(0, e.value.length - rest.length)
        : _dir(e.value);
  }).toSet();
  if (below.length == 1) return below.single;
  if (below.length > 1) {
    final parts = below.map((b) => b.split('/')).toList();
    final common = <String>[];
    for (var i = 0; i < parts.first.length; i++) {
      final seg = parts.first[i];
      if (parts.every((p) => p.length > i && p[i] == seg)) {
        common.add(seg);
      } else {
        break;
      }
    }
    if (common.length >= 2) return common.join('/');
  }
  // What the DNA places moves with the DNA: doc/guides -> doc/en/guides.
  if (_isDnaPath(oldAbs)) return 'doc/en/${oldAbs.substring('doc/'.length)}';
  return oldAbs;
}

String _mapDead(String dead) {
  // "<file>: <target>" — map the file to its new place.
  final i = dead.indexOf(': ');
  final file = dead.substring(0, i);
  return '${_moves[file] ?? file}: ${_mapPath(dead.substring(i + 2))}';
}

/// Dead relative links as `<file>: <resolved target>`.
Set<String> _deadLinks(List<String> files) {
  final dead = <String>{};
  for (final f in files) {
    final text = File('$_root/$f').readAsStringSync();
    for (final m in _linkRe.allMatches(_stripCode(text))) {
      final target = m.group(2) ?? m.group(5) ?? m.group(7)!;
      if (_isExternal(target)) continue;
      final pathPart = target.split('#').first;
      if (pathPart.isEmpty) continue;
      final abs = _normalize('${_dir(f)}/${_decode(pathPart)}');
      // Links into the DNA folders count as alive at either place.
      final p = '$_root/$abs';
      if (File(p).existsSync() || Directory(p).existsSync()) continue;
      // The DNA files move with the next DNA build; either place counts.
      if (abs.startsWith('doc/en/')) {
        final legacy = '$_root/doc/${abs.substring('doc/en/'.length)}';
        if (File(legacy).existsSync() || Directory(legacy).existsSync()) {
          continue;
        }
      }
      if (_isDnaPath(abs)) {
        final moved = '$_root/doc/en/${abs.substring(4)}';
        if (File(moved).existsSync() || Directory(moved).existsSync()) continue;
      }
      dead.add('$f: $abs');
    }
  }
  return dead;
}

String _stripCode(String text) =>
    text.replaceAll(_fenceRe, '').replaceAll(RegExp(r'`[^`\n]*`'), '');

/// [path] with its percent escapes, e.g. `%20`, decoded.
String _decode(String path) {
  try {
    return Uri.decodeComponent(path);
  } on ArgumentError {
    return path;
  }
}

bool _isExternal(String t) =>
    t.startsWith('http:') ||
    t.startsWith('https:') ||
    t.startsWith('mailto:') ||
    t.startsWith('#') ||
    t.startsWith('/') ||
    t.contains('<') ||
    t.startsWith('data:');

// .............................................................................
// Paths

String _normalize(String p) {
  final out = <String>[];
  for (final s in p.split('/')) {
    if (s.isEmpty || s == '.') continue;
    if (s == '..') {
      // A link may leave the repo: keep the `..` that leads out of it.
      if (out.isNotEmpty && out.last != '..') {
        out.removeLast();
      } else {
        out.add(s);
      }
    } else {
      out.add(s);
    }
  }
  return out.join('/');
}

String _relative(String to, String fromDir) {
  final a = fromDir.isEmpty ? <String>[] : fromDir.split('/');
  final b = to.split('/');
  var i = 0;
  while (i < a.length && i < b.length && a[i] == b[i]) {
    i++;
  }
  final up = List.filled(a.length - i, '..');
  final rel = [...up, ...b.sublist(i)].join('/');
  return rel.isEmpty ? '.' : rel;
}

String _dir(String p) {
  final i = p.lastIndexOf('/');
  return i < 0 ? '' : p.substring(0, i);
}

String _base(String p) => p.split(RegExp(r'[/\\]')).last;

List<String> _entries(String rel) {
  final d = Directory('$_root/$rel');
  if (!d.existsSync()) return [];
  return d.listSync().map((e) => '$rel/${_base(e.path)}').toList()..sort();
}

List<String> _subDirs(String rel) =>
    _entries(rel).where((e) => Directory('$_root/$e').existsSync()).toList();

List<String> _files(String rel) {
  final d = Directory('$_root/$rel');
  if (!d.existsSync()) return [];
  return d
      .listSync(recursive: true)
      .whereType<File>()
      .map((f) => f.path.substring(_root.length + 1).replaceAll(r'\', '/'))
      .toList()
    ..sort();
}

List<String> _allMarkdown() {
  final out = <String>[];
  for (final top in ['doc', 'pm']) {
    out.addAll(_files(top).where((f) => f.endsWith('.md') && !_isDnaOwned(f)));
  }
  for (final e in Directory(_root).listSync().whereType<File>()) {
    if (e.path.endsWith('.md')) out.add(_base(e.path));
  }
  return out;
}

void _removeEmptyDirs(String rel) {
  final d = Directory('$_root/$rel');
  if (!d.existsSync()) return;
  for (final sub in d.listSync().whereType<Directory>()) {
    _removeEmptyDirs(sub.path.substring(_root.length + 1));
  }
  if (d.listSync().isEmpty) d.deleteSync();
}

void _printWarnings() {
  for (final w in _warnings.toSet()) {
    print('! $w');
  }
}

Never _fail(String message) {
  stderr.writeln(message);
  exit(2);
}
