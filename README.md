# dna_plan

DNA layer: how a project is planned — the structure of a project management
repo and the seven layers of product design.

## What it ships

- `doc/guides/pm-repo-guide.md` — how a project management (PM) repo is
  structured and how tickets and quarters are planned in it; `dna_gg`'s
  ticket workflow reads it when present
- `doc/guides/layers-guide.md` — the layer system of product design and
  how to use it
- `doc/guides/layers/*-guide.md` — one short guide per layer plus the
  orient audit
- `.claude/skills/layers-*` — nine skills that load the matching guide

The layer guides follow
[layers-skills](https://github.com/jamiemill/layers-skills) by Jamie Mill
(MIT).

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
