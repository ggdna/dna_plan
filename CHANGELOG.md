# Changelog

## 1.0.0 - 2026-10-23

## 0.7.0 - 2026-10-21

## 0.6.2 - 2026-10-21

- Fit the Jira export to Jira Data Center and Server: the user name as
assignee (the e-mail address only on Jira Cloud), the priority names of the
project, an optional `Sprint` column with the sprint ID, wiki markup in the
description, UTF-8 without BOM and the right import steps, with the warning
not to map the description values
- Turn estimates into seconds with the team's hours per day, a new field at
the top of `doc/team/people.md`; one `Labels` column per label

## 0.6.1 - 2026-10-21

- Keep who has which role only in `doc/team/roles.md`; `people.md` lists
first names, areas, days per week and the Jira account, without roles
- Reports take the roles of a person from `roles.md` and treat moves,
renames, translations and reformatting as no news; points are dated by the
file, not by the commit

## 0.6.0 - 2026-10-20

- Write PM repos in English, plus a German copy under `doc/de` when the
repo has the translate guide of `dna_translate`
- Keep the team in `doc/team`: `people.md` with first names, areas, roles,
days per week and Jira account; `roles.md` with what each role hears about
- Keep one report per person and quarter in `doc/reports/<yyyy>-Q<n>`, as
points to tick once communicated; add the report guide and `/plan-report`,
which collects the points and carries open ones into the next quarter
- Export the next tickets of one person, one sprint's worth, as a CSV file
for Jira; add the Jira export guide and `/plan-jira-export`
- `/plan-intro` and `CLAUDE.md` name the new skills and the language rule

## 0.5.1 - 2026-10-19

- Goals can be `proposed` until the team confirms them

## 0.5.0 - 2026-10-19

- Keep goals in `doc/goals` and requirements in `doc/requirements`, across
quarters; the quarter folders keep concepts, architecture, tickets and bugs
- Tell goals (why, for whom), requirements (what) and tickets (how) apart
- Add templates for goal files and requirements with `req-<area>-<nnn>` IDs
- Tickets list the requirements they fulfil and set them to `done`
- Requirements carry a priority: `must`, `should` or `could`
- Engineer the requirements interactively before any ticket: add the
requirements guide and the `/plan-requirements` skill
- Plan the time on demand: add the schedule guide and the `/plan-schedule`
skill, which estimates the tickets and draws a Gantt chart in
`doc/schedule.md`, optionally against a target date
- Add a `CLAUDE.md` with the planning rules and the `/plan-intro` skill

## 0.4.0 - 2026-10-18

## 0.3.0 - 2026-09-14

- Move the layers guide, the layer guides and the `/layers-*` skills to
the new `dna_design_layers` layer; `pm-repo-guide.md` only refers to them
- Blog posts go into `doc/blog/<yyyy>`, one folder per year, matching the
blog guide

## 0.2.0 - 2026-09-10

- Add the project management repo guide: structure of a PM repo, concepts,
file names, planning a ticket and a quarter, blog posts with `dna_blog`
- Add the layers guide and one guide per layer of product design, plus the
orient audit
- Add the nine `/layers-*` skills; each one reads its guide
