# dna_plan

DNA layer: how a project is planned — the structure of a project management
repo and the seven layers of product design.

## What it ships

- `dna/doc/en/guides/pm-repo-guide.md` — how a project management (PM)
  repo is structured — `doc/<lang>` for the documentation, everything
  planned in one folder per language and quarter, `pm/<lang>/<yyyy>-Q<n>`,
  and what still holds is copied into the next quarter; and how tickets and
  quarters are planned in it. `dna_gg`'s ticket workflow reads
  it when present
- `dna/doc/en/guides/requirements-guide.md` — how the requirements are engineered
  together with the user, before any ticket
- `dna/doc/en/guides/schedule-guide.md` — how the requirements are cut into
  tickets, estimated and drawn as a Gantt chart against a target date
- `CLAUDE.md` — tells the AI to engineer the requirements first and to
  offer a time plan; it lands in the managed block of the project's
  `CLAUDE.md` next to the ones of the other layers (helix 1.13 or newer)
- `dna/doc/en/guides/report-guide.md` — how each person gets a quarterly report
  in `pm/<lang>/<yyyy>-Q<n>/reports`, with points to tick once they are communicated
- `dna/doc/en/guides/jira-export-guide.md` — how the next tickets of one person,
  one sprint's worth, are exported as a CSV file for Jira
- Skills: `/gg-plan-intro` lists the planning skills and names the next
  step, `/gg-plan-requirements` runs the requirements engineering,
  `/gg-plan-schedule` the time plan, `/gg-plan-report` the reports and
  `/gg-plan-jira-export` the Jira export

A PM repo keeps every file in each of its languages, set by the variable
`dnaLanguages` of `dna_translate` (default `en`, e.g. `en,de,fa`). The
team — people, their areas and roles — lives in
`pm/<lang>/<yyyy>-Q<n>/team`.

Every file of `dna/doc/en/` also ships in German and Farsi, with the
same name:

- `dna/doc/de/guides/`
- `dna/doc/fa/guides/`

`tool/migrate_doc_structure.dart` moves the documentation of a repo into
this structure: run `dart run <path>/tool/migrate_doc_structure.dart` in
its root, `--dry-run` first.

The guide plans with the seven layers of product design. Their guides and
the `/layers-*` skills live in
[dna_design_layers](https://github.com/ggdna/dna_design_layers); install
both layers to get the whole picture.

## Layers

Orthogonal: this layer carries only its own topic and is combined with the
other layers by [dna_ggdna](https://github.com/ggdna/dna_ggdna). It declares no
parent, and it must not — the umbrella lists every topic layer, so taking the
umbrella back would close a cycle, and a parent here would reach every consumer
of this topic whether that repo asked for it or not.

## Overridable sections

A consuming repo replaces a tagged section with a sidecar
`<file>.overrides.md` at the same path in its own `dna/` folder, see
[helix](https://github.com/ggdna/helix):

| File                                 | Tag                   | Section                |
| ------------------------------------ | --------------------- | ---------------------- |
| `dna/doc/en/guides/pm-repo-guide.md` | `@write-requirements` | Write the requirements |

Keep the heading of a replaced section: other guides link to it. Example
`dna/doc/en/guides/pm-repo-guide.overrides.md`:

```markdown
## @write-requirements Write the requirements

- The repo's own rules for requirement files and IDs
```

## Variables

- `dnaCopyrightHolder` — the name in the license header of every file

## Development

The `dna/` folder is hand-authored source and is never generated. The repo
instantiates its own DNA — run `dart test` after changes; commit first, a file
the DNA would overwrite must not carry uncommitted work.
