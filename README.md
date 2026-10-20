# dna_plan

DNA layer: how a project is planned — the structure of a project management
repo and the seven layers of product design.

## What it ships

- `doc/guides/pm-repo-guide.md` — how a project management (PM) repo is
  structured; how goals and requirements are kept across quarters; and how
  tickets and quarters are planned in it. `dna_gg`'s ticket workflow reads
  it when present
- `doc/guides/requirements-guide.md` — how the requirements are engineered
  together with the user, before any ticket
- `doc/guides/schedule-guide.md` — how the requirements are cut into
  tickets, estimated and drawn as a Gantt chart against a target date
- `CLAUDE.md` — tells the AI to engineer the requirements first and to
  offer a time plan; it lands in the managed block of the project's
  `CLAUDE.md` next to the ones of the other layers (helix 1.13 or newer)
- `doc/guides/report-guide.md` — how each person gets a quarterly report
  in `doc/reports`, with points to tick once they are communicated
- `doc/guides/jira-export-guide.md` — how the next tickets of one person,
  one sprint's worth, are exported as a CSV file for Jira
- Skills: `/plan-intro` lists the planning skills and names the next
  step, `/plan-requirements` runs the requirements engineering,
  `/plan-schedule` the time plan, `/plan-report` the reports and
  `/plan-jira-export` the Jira export

A PM repo is written in English; with the `dna_translate` layer it keeps a
German copy of every file under `doc/de`. The team — people, their areas
and roles — lives in `doc/team`.

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

## Variables

- `dnaCopyrightHolder` — the name in the license header of every file

## Development

The `dna/` folder is hand-authored source and is never generated. The repo
instantiates its own DNA — run `dart test` after changes; commit first, a file
the DNA would overwrite must not carry uncommitted work.
