<!--
@license
Copyright (c) dnaCopyrightHolder

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# Orient guide

The front door of the layer system. Skill: `/layers-orient`.

## Know what orient is

- A rapid audit across all seven layers, not a deep dive into one
- Answers one question: which layer needs attention most urgently?
- Output: a short audit table and one recommendation

## Ask three questions

- Which product or feature is this about?
- Which design challenge prompted this?
- How far along is the work: early exploration, active design, fixing an
  existing product?

## Audit every layer

Ask one or two targeted questions per layer and rate it:
strong / partial / assumed / weak / not started / n/a.

| Layer              | Ask                                                  |
| ------------------ | ---------------------------------------------------- |
| Observed behaviour | Research, analytics, or team belief?                 |
| Domain             | How well is the space understood before the product? |
| User needs         | Can you state the job and why it matters?            |
| Product strategy   | Which need, which business outcome, explicit?        |
| Conceptual model   | Clear, shared objects and vocabulary?                |
| Interaction flow   | Key journeys with places, steps, decision points?    |
| Surface            | Existing design system or visual language?           |

## Find the bottleneck

- The bottleneck is the lowest layer rated weak, assumed or not started
- Name it, the missing decisions, and the risk for the layers above
- Flag assumed layers separately: they look solid and hide the risk
- Acknowledge deadlines that change the calculus; name the trade-off

## Recommend one next step

- Name the layer guide to work next and why
- Ask whether to run it now or to push back on the picture first

## Capture

- The audit table
- The bottleneck and the recommendation, one line each
