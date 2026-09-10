<!--
@license
Copyright (c) dnaCopyrightHolder

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# Domain guide

Layer 2 of 7, problem space. Skill: `/layers-domain`.

## Know what this layer is

- What exists in the real world before any product: concepts, terms,
  processes, mental models
- Observation, not design

## Decide

- Which key concepts exist and how they relate
- Which words people use, and where they conflict
- Where the seams are: groups using the same word differently
- Which events and processes structure the domain over time

## Keep it honest

- Record contradictions, do not resolve them; resolution belongs to the
  conceptual model
- Stay in the real world; push back on product or interface talk
- Mark nouns as object / attribute / instance / unclear, filter little
- Say when you map team beliefs instead of researched fact

## Pick a technique

| Situation                       | Technique                      |
| ------------------------------- | ------------------------------ |
| Relations unclear               | Concept map (`graph TD`)       |
| Language contested              | Terminology audit              |
| Groups diverge                  | Bounded-context mapping        |
| Process-heavy domain            | Domain event storming          |
| Knowledge lives in people       | Expert interviews, shadowing   |
| Domain produces forms, invoices | Document and artefact analysis |
| Established market              | Competitive analysis           |

## Capture

- Concept map, if it earned its place
- Terminology conflicts and bounded contexts
- Key events
- Noun harvest

## Continue

The noun harvest is the raw material of the
[conceptual model](conceptual-model-guide.md).
