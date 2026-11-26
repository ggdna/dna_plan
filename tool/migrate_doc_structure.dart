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
// it turns a working link into a dead one.
//
// Run it in the root of a repo:
//
//   dart run <path>/tool/migrate_doc_structure.dart [--dry-run]
//
// A second run changes nothing.

import 'dart:convert';
import 'dart:io';

final _quarterRe = RegExp(r'^\d{4}-Q[1-4]$');
final _langRe = RegExp(r'^[a-z]{2}$');
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

/// Folders the DNA places; never moved by this script.
const _dnaOwned = {'guides', 'templates'};

late final String _root;
late final bool _dryRun;

/// old path (relative, posix) -> new path
final _moves = <String, String>{};
final _warnings = <String>[];

void main(List<String> args) {
  _dryRun = args.contains('--dry-run');
  _root = Directory.current.path;
  if (!Directory('$_root/doc').existsSync()) {
    print('No doc folder — nothing to do.');
    return;
  }

  _readDnaInstances();
  final deadBefore = _deadLinks(_allMarkdown());

  _planLanguage('en', 'doc');
  for (final dir in _subDirs('doc')) {
    final name = _base(dir);
    if (_langRe.hasMatch(name) && name != 'en') _planLanguage(name, dir);
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

  final deadAfter = _deadLinks(_allMarkdown());
  final newDead = deadAfter.difference(
    deadBefore.map((d) => _mapDead(d)).toSet(),
  );
  _printWarnings();
  print('Moved ${_moves.length} files, rewrote links in $rewritten files.');
  if (newDead.isNotEmpty) {
    stderr.writeln('Dead links after the move:');
    for (final d in newDead.toList()..sort()) {
      stderr.writeln('  $d');
    }
    exitCode = 1;
  }
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
    if (base == 'doc' && _langRe.hasMatch(name)) continue; // other languages
    if (base == 'doc' && name == 'ticket-counter.json') continue;
    final isDir = Directory('$_root/$entry').existsSync();
    if (isDir && _quarterKinds.contains(name)) {
      for (final f in _files(entry)) {
        final rest = f.substring('$entry/'.length);
        final q = _quarterFor(name, rest, newest);
        _planFile(
          f,
          'pm/$lang/$q/${_inQuarter('$name/${_stripQuarter(name, rest)}')}',
        );
      }
    } else if (name == 'schedule.md') {
      _planFile(entry, 'pm/$lang/$newest/charts/schedule.md');
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

/// The quarter a loose file goes to: blog posts and dated reports by their
/// date, the rest into the newest quarter.
String _quarterFor(String kind, String rest, String newest) {
  final parts = rest.split('/');
  if (parts.length > 1 && _quarterRe.hasMatch(parts.first)) return parts.first;
  final m = _datePrefixRe.firstMatch(parts.last);
  if (m != null &&
      (kind == 'blog' || kind == 'exports' || kind == 'meetings')) {
    final month = int.parse(m.group(2)!);
    return '${m.group(1)}-Q${(month - 1) ~/ 3 + 1}';
  }
  return newest;
}

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
  if (_langRe.hasMatch(first) || _quarterRe.hasMatch(first)) return false;
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
    if (_langRe.hasMatch(first)) return m.group(0)!;
    return '"doc/en/$rest"';
  });
  if (updated != text) file.writeAsStringSync(updated);
}

// .............................................................................
// Links

final _linkRe = RegExp(
  r'(\]\()([^)\s]+)(\))|(^[ ]{0,3}\[[^\]\n]+\]:[ \t]+)(\S+)|(\bsrc=")([^"]+)(")',
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
  // A folder: the common new folder of the files below it.
  final below = _moves.entries
      .where((e) => e.key.startsWith('$oldAbs/'))
      .map(
        (e) => e.value.substring(
          0,
          e.value.length - (e.key.length - oldAbs.length),
        ),
      )
      .toSet();
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
      if (out.isNotEmpty) out.removeLast();
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

String _base(String p) => p.split('/').last;

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
      .map((f) => f.path.substring(_root.length + 1))
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
