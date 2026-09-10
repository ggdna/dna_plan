# Example

`dna_plan` is a DNA layer: it ships the project management repo guide, the
guides of the seven layers of product design and the `/layers-*` skills, no
code. Declare it as a dev dependency and instantiate it once:

```bash
dart pub add dev:dna_plan     # Dart projects
pnpm add -D @ggdna/dna-plan   # TypeScript projects
gg dna init
gg dna build
```

The placed test instantiates the layer on every test run.
