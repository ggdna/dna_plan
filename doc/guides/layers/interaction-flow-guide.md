<!--
@license
Copyright (c) ggdna

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# Interaction flow guide

Layer 6 of 7, solution space. Skill: `/layers-interaction-flow`.

## Know what this layer is

- The places a user moves through, the affordances in each, the content
  shown, the flow between states
- Above the model (what exists), below the surface (how it looks)
- Always for one user in one situation doing one job

## Decide

- Which places the flow moves through
- What the user can do in each place, and where it leads
- What content each place shows
- What happens on failure, empty and edge cases
- Whether the flow is as simple as it can be

## Keep it honest

- Every affordance has a named destination
- Edges are required steps: validation, server error, disconnect, timeout,
  concurrent edit, empty, loading, post-action, cancel
- No broken objects: attributes and actions of an object stay together
- No isolated objects: every relation is navigable or deliberately not
- Vocabulary matches the ubiquitous language
- Name places for users; more than 5–6 places per job is a signal

## Pick a technique

| Situation                | Technique                 |
| ------------------------ | ------------------------- |
| Default                  | Breadboarding             |
| Finding unmade decisions | Walk the flow as the user |
| Much to plan, many users | User story mapping        |
| Redesign                 | Task analysis             |
| Channels and backstage   | Service blueprinting      |
| Orientation only         | Flow diagram (`graph LR`) |

Breadboard notation:

```text
Place name
- affordance → destination place
[ content shown in this place ]
```

## Capture

- The breadboard: places, affordances, destinations, content, conditions
- A flow diagram, if it aids orientation
- Open decisions and unresolved edge cases
- Risks that depend on unsettled lower layers

## Continue

Check that the [conceptual model](conceptual-model-guide.md) is stable,
then move to the [surface](surface-guide.md).
