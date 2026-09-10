<!--
@license
Copyright (c) dnaCopyrightHolder

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# Layers guide

## Know the layer system

- "Layers of Product Design" splits design work into seven layers in
  three zones; these guides follow
  [layers-skills](https://github.com/jamiemill/layers-skills) by Jamie
  Mill (MIT)
- Lower layers are foundations for upper ones; a weak lower layer creates
  debt in every layer above
- Enter at any layer, but check the layers below before building upward

Problem space — knowledge gathered from reality:

- 1 [Observed behaviour](layers/observed-behaviour-guide.md) — what users
  actually do
- 2 [Domain](layers/domain-guide.md) — what exists before our product
- 3 [User needs](layers/user-needs-guide.md) — what users try to achieve,
  and why

Solution space — deliberate decisions about what to build:

- 4 [Product strategy](layers/product-strategy-guide.md) — which needs we
  serve, for which outcome
- 5 [Conceptual model](layers/conceptual-model-guide.md) — which objects,
  relations and words
- 6 [Interaction flow](layers/interaction-flow-guide.md) — which places,
  actions and paths
- 7 [Surface](layers/surface-guide.md) — what users see, read and hear

## Treat design as decision making

- Every layer makes decisions; artefacts only record them
- Four kinds of progress: make a decision, uncover an unmade one, evaluate
  a risky one, prioritise
- Work one layer at a time; do not mix problem space and solution space
- Flag bad decisions, not only missing ones
- Capture decisions, not transcripts; keep the record short

## Use the skills

- Load `/layers-intro` at the start of every design session
- Run `/layers-orient` when unsure which layer needs attention, see the
  [orient guide](layers/orient-guide.md)
- Run the skill of the layer you work on: `/layers-observed-behaviour`,
  `/layers-domain`, `/layers-user-needs`, `/layers-product-strategy`,
  `/layers-conceptual-model`, `/layers-interaction-flow`, `/layers-surface`
- Each skill reads its guide; a guide is a library of techniques, not a
  script: pick one technique for the live decision, work it, capture the
  residue

## Record the results

- Write the residue of a session into the project management repo, see the
  [PM repo guide](pm-repo-guide.md#use-the-design-layers)
- One decision per file in `concepts/decisions`; everything else in the
  topic, ux or goal file it belongs to
