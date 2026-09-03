# dna_plan

DNA layer: planning guides and templates

## Status

Scaffolded, not yet filled. `dna/` carries no planning content so far, and no
version of this layer has been published to pub.dev or npm. Until it has
something to say, `dna_ggdna` does not list it.

## Layers

Orthogonal: this layer will carry only its own topic and is combined with the
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
