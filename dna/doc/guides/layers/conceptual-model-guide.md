<!--
@license
Copyright (c) dnaCopyrightHolder

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# Conceptual model guide

Layer 5 of 7, solution space. Skill: `/layers-conceptual-model`.

## Know what this layer is

- The objects the product recognises, their relations, states and
  vocabulary — independent of any interface
- The most neglected load-bearing layer; give it more attention than feels
  comfortable
- Not the users' mental model, not a database schema

## Decide

- Which objects exist and where their boundaries are
- How objects relate: cardinality and named roles
- What a user can do with each object
- Which states and transitions matter
- One name per concept, one concept per name

## Keep it honest

- Real objects only: instanceable, structured, useful; "CAC" is an
  instance of Metric
- Model an attribute that names another object as a relationship
- No speculative additions; every element traces to a stated need
- Can-be-an-object is not should-be-first-class; justify persistence by a
  concrete flow, mark bets as provisional
- Split generic verbs that hide different consequences: correct an address
  vs register a move
- Redirect implementation talk to what the user can do

## Pick a technique

| Situation                      | Technique                             |
| ------------------------------ | ------------------------------------- |
| Material to mine               | Noun foraging, OOUX                   |
| One object unclear             | Object definition                     |
| Objecthood uncertain           | Sketch the flow first, then formalise |
| Relations to check             | Relational object map (`erDiagram`)   |
| Status changes what is allowed | State diagram (`stateDiagram-v2`)     |
| Verbs inconsistent             | Action inventory across all objects   |
| Naming contested               | Ubiquitous language list              |
| Redesign                       | Walk the existing product             |

Probe the temporal decisions: intermediate states, read lag, relationship
over time, deletion semantics, history.

## Capture

- Settled object definitions, provisional ones marked
- Diagrams that encode a real relation or lifecycle
- Vocabulary decisions with rejected alternatives
- Open questions for engineering

## Continue

When objects and actions are stable, design how users move through them:
[interaction flow](interaction-flow-guide.md).
