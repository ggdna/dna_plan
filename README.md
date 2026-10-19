# dna_plan

English | [Deutsch](README.de.md)

Gives a repo the guide to plan a project in a project management repo: goals,
concepts, tickets, quarters and design results.

## Motivation

Goals, concepts, decisions and ticket plans are not code and have no place in
a code repo. This layer gives them one: a project management (PM) repo with a
fixed structure, one folder per quarter and fixed file names. Every ticket
belongs to exactly one PM repo, and the gg ticket workflow reads this guide
when it plans a ticket there, so the plan always lands in the same place.

## Usage

Add the layer to the project management repo itself. Declare it as a
dev-dependency and initialize once:

```bash
dart pub add dev:dna_plan     # Dart projects
pnpm add -D @ggdna/dna-plan   # TypeScript projects
gg dna init
gg dna build
```

`gg dna init` places a test that instantiates the layer on every test run;
`gg dna build` runs the same instantiation once without a test framework. It
copies the guide to `doc/guides/pm-repo-guide.md`.

When a gg ticket adds the PM repo, the `/gg-ticket` skill of
[dna_gg](https://github.com/ggsuite/dna_gg) reads that guide and writes the
plan to `doc/<yyyy>-Q<n>/tickets/` as it describes.

## Guides

- `dna/doc/guides/pm-repo-guide.md` — what a PM repo is, its folder structure
  per quarter, the concepts folder with topics, decisions and UX, blog posts,
  file names, where the results of the design layers land, and how a ticket
  and a quarter are planned

## Scope

The layer only ships the guide for the PM repo; it has no skills and no
templates. The seven layers of product design that the guide plans with —
the [layers guide](https://github.com/ggdna/dna_design_layers), one guide per
layer and the `/layers-*` skills — come from dna_design_layers. Blog posts are
written only if the repo also has the blog guide of dna_blog. The ticket
workflow itself belongs to dna_gg.

## Layers

The layer is orthogonal: `dna/_dna.json` lists no parent layers. It carries
only its own topic and stays parent-less on purpose — a parent would reach
every consumer of this topic, whether that repo asked for it or not.

No umbrella lists the layer today, dna_ggdna included: a PM repo lists
dna_plan itself.

## Variables

- `dnaCopyrightHolder` — the holder named in the copyright header of the
  placed guide. `dna/_dna.json` declares no `mustOverride`, so a consuming
  repo is not forced to set it; without its own value in `dna/_vars.json` the
  header names `ggdna`

## Development

The `dna/` folder is hand-authored source and is never generated. The repo
instantiates its own DNA — run `dart test` after changes; commit first, a file
the DNA would overwrite must not carry uncommitted work.

Edit the files below `dna/`, never their copies in `doc/`: the test overwrites
them.

## License

MIT — see [LICENSE](LICENSE).
