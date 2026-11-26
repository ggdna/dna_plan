<!--
@license
Copyright (c) dnaCopyrightHolder

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# Project management repo guide

## @pm Know what a PM repo is

- A project management (PM) repo holds the goals, requirements, concepts,
  plans, schedule, meetings, decisions and blog posts of a project — no code
- Every ticket belongs to exactly one PM repo. Add it to the ticket before
  any code repo (see the `gg` development guide)
- A ticket that is only planned ends with the PM repo alone
- Requirements come before tickets: engineer them with the user first, see
  [Engineer the requirements first](#engineer-the-requirements-first)
- Keep every file in each language of the repo, see
  [Keep the languages](#keep-the-languages)

## @structure Structure the repo like this

```text
root
|-doc
| |-en
| | |-guides
| | |-templates
| |-de
| | |-...
|-pm
| |-en
| | |-2026-Q3
| | | |-architecture
| | | | |-architecture.md
| | | | |-img
| | | |    |-diagram.mmd
| | | |-blog
| | | | |-2026-09-10-blogpost-1.md
| | | |-bugs
| | | |-charts
| | | | |-schedule.md
| | | |-concepts
| | | | |-decisions
| | | | | |-000-index.md
| | | | |-topics
| | | | |-ux
| | | |-exports
| | | | |-2026-09-10-anna-sprint.csv
| | | |-goals
| | | | |-results-without-desktop-software.md
| | | |-meetings
| | | | |-2026-09-08-kick-off.md
| | | |-prompts
| | | |-reports
| | | | |-anna.md
| | | |-requirements
| | | | |-results.md
| | | |-team
| | | | |-people.md
| | | | |-roles.md
| | | |-tickets
| | | | |-2026-09-10-cdm-1317-infrastructure-discovery-server.md
| | |-2026-Q4
| | | |-...
| |-de
| | |-2026-Q3
| | | |-...
|-README.md
|-README.de.md
```

- `pm` holds everything the project plans and writes, `doc` the
  documentation that belongs to no quarter. Both have one folder per
  language, see [Keep the languages](#keep-the-languages)
- In `pm/<lang>`, everything lives in a quarter folder `<yyyy>-Q<n>`,
  called `pm/<lang>/<quarter>` below. Nothing of it lives next to the
  quarter folders, so the repo does not grow fatter and harder to read
  over the years: the newest quarter folder holds all that is still
  valid, the older ones are history
- The newest quarter folder is the current quarter. Read and write only
  there; never change an older quarter
- What still holds at the end of a quarter is copied into the next one,
  see [Start a quarter](#start-a-quarter)
- `doc/<lang>/guides` and `doc/<lang>/templates` come from the DNA layers;
  never edit them
- `README.md` names the project and links to the current quarter, its
  active goals and its requirements
- `architecture` — the target picture of the system: `architecture.md`
  plus diagrams in `img` as mermaid `.mmd` files
- `blog` — one post per finished ticket; exists only if the repo has
  `doc/en/guides/blog-guide.md` from the `dna_blog` layer, see below
- `bugs` — one file per bug; a bug turns into a ticket once it is planned
- `charts` — the time plan `schedule.md` and every other chart of the
  quarter, see [Draw charts](#draw-charts)
- `concepts` — what the product is and why: `topics`, `decisions` and
  `ux`, see below
- `exports` — CSV files of tickets for Jira, see
  [Export tickets to Jira](#export-tickets-to-jira)
- `goals` — what the project wants to achieve and for whom; one file per
  goal, see below
- `meetings` — one file per meeting, see
  [Keep the meetings](#keep-the-meetings)
- `prompts` — prompts worth keeping, e.g. the prompt that started a
  ticket; one file per prompt, `<yyyy>-<mm>-<dd>-<title>.md`
- `reports` — one report per person with the points to tell them, see
  [Report to the people](#report-to-the-people)
- `requirements` — what the product must do or be; one file per area,
  see below
- `team` — who works on the project and in which roles, see
  [Know the team](#know-the-team)
- `tickets` — one plan file per ticket
- Planning files that span the quarter, such as `plan.md`,
  `next-steps.md` or `milestones.md`, lie at the top of the quarter folder
  and are copied into the next quarter while they hold

## @goals-requirements Tell goals and requirements apart

- A goal says **why** and **for whom**: an outcome the project wants, e.g.
  "clubs evaluate their races without desktop software". It leaves open how
  it is reached and is done when the outcome is there
- A requirement says **what** the product must do or be: a testable
  statement about the system, e.g. "the result list is ready two seconds
  after the last finisher". It says nothing about how it is built and holds
  until it is changed or dropped
- A ticket says **how** and **when**: one step that fulfils requirements in
  service of a goal
- Topics hold the problem space — evidence and user needs. Requirements are
  the commitments derived from them; do not write requirements into topics
- Goals and requirements outlive quarters: a goal may take several quarters,
  a requirement holds for as long as the product does. That is why the
  open ones are copied into each new quarter, see
  [Start a quarter](#start-a-quarter)

## @goals Write the goals

- Create `pm/<lang>/<quarter>/goals/<title>.md`, title in English kebab case
- Use these sections, in this order:

```markdown
# <Title>

## Status

## Outcome

## Measure

## Requirements
```

- `Status` — `proposed`, `active`, `reached` or `dropped`, plus the
  quarters the goal was worked on, e.g. `active since 2026-Q3`. A goal is
  `proposed` until the team confirms it
- `Outcome` — one paragraph: what changes, for whom, and why it matters
- `Measure` — how we know the goal is reached
- `Requirements` — links to the requirements derived from the goal
- Never delete a goal; set it to `reached` or `dropped` and say why

## @write-requirements Write the requirements

- Group requirements by area of the product, one file per area:
  `pm/<lang>/<quarter>/requirements/<area>.md`, area in English kebab case
- Give each requirement an ID `req-<area>-<nnn>`, e.g. `req-results-001`;
  the prefix keeps it apart from decision IDs. Never reuse or renumber an
  ID. A new ID follows the highest one of the area in all quarters, since
  finished requirements stay behind in older quarters
- Write each requirement as its own section:

```markdown
## req-results-001: Result list right after the race

- Status: accepted
- Priority: must
- Statement: The result list is ready two seconds after the last finisher
- Why: [results without desktop software](../goals/results-without-desktop-software.md),
  topic `timing`
- Acceptance: a race with 500 finishers shows the list within two seconds
```

- `Status` — `proposed`, `accepted`, `done` or `dropped`
- `Priority` — `must`, `should` or `could`; what is not wanted at all is
  `dropped`
- `Statement` — one sentence on what the product must do or be, never how
- `Why` — the goal it serves and the topic it comes from
- `Acceptance` — the checks that prove it; one bullet per check if needed
- Change a requirement in place and say what changed and when; a requirement
  that is replaced is set to `dropped` and links its successor
- A broken `done` requirement is a bug, not a new requirement

## @engineer Engineer the requirements first

- Find the goals and requirements together with the user, one question at
  a time and with proposals: the
  [requirements guide](requirements-guide.md) says how, `/gg-plan-requirements`
  runs it
- Do it before the first ticket, whenever `pm/<lang>/<quarter>/requirements` is
  empty, and
  whenever the work of a ticket is not covered by an accepted requirement
- Plan and create tickets only after that. Bug tickets are the exception:
  they name their bug file instead
- `/gg-plan-intro` lists the planning skills and says which one comes next

## @team Know the team

- Write down who works on the project in `pm/<lang>/<quarter>/team/people.md`,
  one section per person:

```markdown
# People

- Sprint length: 2 weeks
- Hours per day: 8

## Anna

- Areas: result list, import of race data, the `timing_app` repo
- Days per week: 4
- Jira: anna
```

- The section title is the first name; the file names of the person use
  it in lower case kebab case: `anna`
- `Areas` — what the person takes care of: features, topics, repos. The
  Jira export matches tickets to people by them
- `Days per week` — how much of the week the person works on the project
- `Jira` — the name Jira knows the person by: the user name on Jira Data
  Center or Server, e.g. `anna`, the Atlassian account ID on Jira Cloud;
  optional
- `Sprint length` — once, at the top; default two weeks
- `Hours per day` — once, at the top: the working hours of one day, used
  to turn estimates in days into hours; default 8
- Write down the roles in `pm/<lang>/<quarter>/team/roles.md`, one section per
  role. Start
  with Developer, Product Owner, Management, Sales and Customer, and add
  the ones the project needs:

```markdown
# Roles

## Product Owner

- Responsible for: goals, requirements and their priority
- People: Anna
- Hears about: goals, requirements, decisions, schedule shifts
```

- `People` — the first names of `people.md` who have the role.
  This is the only place that says who has which role; `people.md` does
  not repeat it
- `Hears about` decides what lands in the reports of the people in that
  role. Customers and sales hear about outcomes and dates, never about
  internals such as code, open decisions or estimates
- One person may have several roles, so may be listed under several of
  them; their report covers all of them
- Ask the user for the team before the first report or export; never
  guess people or roles
- Keep only first names, areas and roles in `team`, besides the Jira
  account and the git user names; no contact data
- Never ask for e-mail addresses and never write one into the PM repo,
  neither in `team` nor anywhere else. When the user offers one, ask
  for the git user name or the Jira account instead

## @concepts Fill the concepts folder

- `topics` — one file per product topic: evidence, use cases, user needs,
  what was tried and what holds; the place for problem-space knowledge
- `decisions` — one file per decision, `<area>-<nnn>.md`, e.g.
  `design-001.md`; `000-index.md` lists all decisions with ID, status,
  date, one line and open work
- `ux` — accepted statements about the product's surface and flows: which
  objects, places and words the user meets, and why
- Write a decision file with: title, status (proposed / accepted /
  superseded), date, canonical source, open work, the decision in one
  paragraph
- Never rewrite a decision; supersede it with a new one and link both ways

## @blog Write blog posts

- Write a post only if `doc/en/guides/blog-guide.md` exists; it comes from the
  `dna_blog` layer. Without it, write no post and skip the rest of this
  section
- Follow the blog guide for content and template
- Put the post into `pm/<lang>/<quarter>/blog` of the PM repo, the quarter of
  the day the ticket is finished
- Name it `<yyyy>-<mm>-<dd>-<title>.md`, title in English kebab case
- One post may cover all repos of the ticket that belong to the
  organization of the PM repo
- Write only knowledge of the organization of the PM repo
- Leave out repos of other organizations in the ocean, even when they took
  part in the ticket. Name them only as updated dependencies: public package
  name, version and what the update means for this organization's repos;
  never their tickets, plans or internals

## @files Name the files

- Prefix ticket and bug files with the date: `<yyyy>-<mm>-<dd>-`
- Add the ticket ID in lower case: `cdm-1317`
- Finish with the title in English kebab case:
  `2026-09-10-cdm-1317-infrastructure-discovery-server.md`
- Name goals, requirement areas, topics, ux files, architecture files and diagrams by their
  topic, in English kebab case
- Name reports `<name>.md` and exports `<yyyy>-<mm>-<dd>-<name>-sprint.csv`,
  `<name>` being the first name in lower case kebab case
- Keep the English file names in every language

## @meetings Keep the meetings

- Write one file per meeting into `pm/<lang>/<quarter>/meetings`, named
  `<yyyy>-<mm>-<dd>-<topic>.md`, topic in English kebab case
- Use these sections, in this order:

```markdown
# <Topic> — <yyyy>-<mm>-<dd>

## Participants

## Topics

## Decisions

## Tasks
```

- `Participants` — the first names of `team/people.md`, plus guests by
  role; never contact data
- `Decisions` — one line per decision; a decision that shapes the product
  also gets its own file in `concepts/decisions`
- `Tasks` — one checkbox per task with the first name of the person who
  does it
- Turn tasks that change the product into tickets; link the ticket from
  the task

## @charts Draw charts

- Put every chart of the quarter into `pm/<lang>/<quarter>/charts`, one
  markdown file per chart with the chart as mermaid, e.g. the time plan
  `schedule.md`, a burn-down or the distribution of the tickets
- Name a chart by its topic, in English kebab case
- Say in one paragraph above the chart what it shows and from which files
  it is drawn, so it can be redrawn
- Redraw a chart when its sources change; never edit a chart of an older
  quarter

## @languages Keep the languages

- This repo keeps its files in these languages, the leading one first:
  `dnaLanguages`. Change them in the `vars` of `dna/_dna.json`, under
  the key `dna` + `Languages` written as one word, e.g. `"en,de"`
- Every file of `pm` and `doc` exists once per language, under
  `pm/<lang>` and `doc/<lang>` with the same path and file name, `<lang>`
  being the two-letter code of the language
- `README.md` is English, every other language has `README.<lang>.md`
- Write the file of the leading language first, even when the user talks
  another one, then the other languages; change all of them in the same
  commit
- Translate headings and prose. Keep IDs, file names, links, the status
  and priority values and the field names of requirements as they are, so
  every copy stays readable for tools
- Keep all copies equal in content and structure; a ticked point in a
  report is ticked in all of them
- Translate the exports too: the summaries and descriptions, never the
  header row, the keys, the IDs or the names, so Jira imports each of them
- The guides and templates come from the DNA layers in every language;
  never translate or edit them

## @people Report to the people

- Keep one report per person and quarter in
  `pm/<lang>/<quarter>/reports/<name>.md`: the points the person needs to
  hear, each with a checkbox to tick once it is communicated
- The [report guide](report-guide.md) says how, `/gg-plan-report` runs it: it
  collects what changed for the roles and areas of the person, appends it
  and starts the file of a new quarter with the open points carried over

## @export Export tickets to Jira

- Export the next tickets of one person as a CSV file Jira imports:
  `pm/<lang>/<quarter>/exports/<yyyy>-<mm>-<dd>-<name>-sprint.csv`
- The [Jira export guide](jira-export-guide.md) says how,
  `/gg-plan-jira-export` runs it: it matches the open tickets without a Jira
  key to the person by their areas, fills one sprint by the estimates and
  writes the file
- The person is assigned at export time only, never in the ticket file

## @layers Use the design layers

- Plan with the seven layers of product design; the `dna_design_layers`
  layer ships the [layers guide](layers-guide.md), one guide per layer and
  the `/layers-*` skills
- Run `/layers-orient` before planning a ticket that changes the product;
  it names the layer that needs attention first
- Write the residue of each layer into the PM repo:

| Layer                                     | Lands in                      |
| ----------------------------------------- | ----------------------------- |
| Observed behaviour, domain, user needs    | `concepts/topics`             |
| Product strategy                          | `goals`                       |
| What the needs and the strategy commit to | `requirements`                |
| Conceptual model, interaction flow        | `concepts/ux`, `architecture` |
| Surface                                   | `concepts/ux`                 |
| Every decision made on the way            | `concepts/decisions`          |

- Do not plan a ticket on a layer whose foundations are weak; plan the
  foundation first, or say plainly that the ticket is a bet

## @ticket Plan a ticket

Set the goal: one paragraph on what is achieved and for whom, and which
goal of the project it serves.

List the requirements the ticket fulfils by ID. If no accepted requirement
covers the work, stop and engineer the requirements with the user first,
see [Engineer the requirements first](#engineer-the-requirements-first).

Name the affected repos and what changes in each one.

List the rough steps in order; one line per step.

Collect the open questions; decide them with the user before implementing.

Link the goals, requirements, decisions and topics the plan rests on.

Let the user review the plan and revise it until they confirm it.

## @ticket-file Write the ticket file

- Create `pm/<lang>/<quarter>/tickets/<date>-<id>-<title>.md`
- Use these sections, in this order:

```markdown
# <ID>: <Title>

## Goal

## Requirements

## Affected repos

## Steps

## Open questions
```

- Keep the plan short; write more only for complex tickets
- Wrap lines at 80 characters
- Embed mermaid diagrams when a picture says more than text

## @plan Keep the plan alive

- Update the plan when the implementation deviates from it
- Move answered questions from `Open questions` into the plan or into a
  decision file
- Set the requirements the ticket fulfilled to `done` when it is finished
- Mark the ticket `done` in `pm/<lang>/<quarter>/charts/schedule.md`, if the project
  has one
- Reference the plan from the blog post that closes the ticket
- Keep the file: the plan documents why things are the way they are

## @time Plan the time

- A time plan is optional; make one when the user wants it or names a
  target date for the project
- The [schedule guide](schedule-guide.md) says how, `/gg-plan-schedule` runs
  it: it asks for the target date and the capacity, cuts the accepted
  requirements into tickets, estimates each one and draws the plan as a
  Gantt chart in `pm/<lang>/<quarter>/charts/schedule.md`
- Plan the time only on accepted requirements

## @quarter Start a quarter

Start the folder of a new quarter before the first file of that quarter
is written, e.g. `pm/en/2027-Q1` on the first ticket in January. Tell the
user, show what is carried over and commit it on its own as
`Start <yyyy>-Q<n>`.

Copy what still holds from the previous quarter:

| What                 | Copied into the new quarter                     |
| -------------------- | ----------------------------------------------- |
| `goals`              | the `proposed` and `active` goals               |
| `requirements`       | per area, the requirements not `done`/`dropped` |
| `team`               | everything                                      |
| `architecture`       | everything                                      |
| `concepts/ux`        | everything                                      |
| `concepts/decisions` | `000-index.md` without the superseded decisions |
| `charts/schedule.md` | the tickets not `done`, a fresh `History`       |
| `reports`            | the open points, by `/gg-plan-report`           |

Move the open tickets and bugs with `git mv` into `tickets` and `bugs`
of the new quarter: a ticket is open while it is not `done` in the
schedule and not all its requirements are `done`; ask the user when in
doubt. This is the only change to an older quarter.

Leave the rest where it was written: topics, decision files, finished
tickets, blog posts, meetings, prompts, exports and the charts other than
the schedule. The new quarter starts without
them and links to them in the older quarter, e.g.
`../../2026-Q4/concepts/decisions/design-001.md`.

- Fix the links of the copied and moved files: links inside the quarter
  stay as they are, links to what stayed behind point into the older
  quarter
- Leave out an area of requirements whose requirements are all `done` or
  `dropped`; their IDs stay taken
- Add the new quarter to the `Status` of the goals carried over, e.g.
  `active since 2026-Q3`
- Point `README.md` to the new quarter
- Do the same in every language of the repo

## @quarter-2 Plan a quarter

Start the quarter folder first, see [Start a quarter](#start-a-quarter).

Choose the goals the quarter works on: add new ones to `goals`, set the
goals carried over to `reached` or `dropped` when they are.

Derive the requirements from the goals and the topics together with the
user; add new ones and change the ones the goals change.

Update `architecture/architecture.md` when a goal changes the target
picture.

Derive tickets from the requirements; each ticket names the goal it serves
and the requirements it fulfils.

Update `charts/schedule.md`, if the project has one, and check the forecast
against the target date.

Check `team` and start the reports of the quarter with `/gg-plan-report`;
it carries the open points of the last quarter over.
