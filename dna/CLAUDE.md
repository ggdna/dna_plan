# Planning

Projects are planned in a project management repo; its structure and the
planning rules are in `doc/en/guides/pm-repo-guide.md`. When you plan in one:

- Everything planned lives in the current quarter folder
  `pm/<lang>/<yyyy>-Q<n>`, the newest one; never write next to the quarter
  folders and never change an older quarter. Start the folder of a new
  quarter first, copying what still holds, as the guide says
- Engineer the requirements before the tickets. If the requirements of the
  current quarter are empty or no accepted requirement covers the work, run
  `/gg-plan-requirements` with the user first, and plan or create tickets
  only after that
- Engineer requirements interactively: one question at a time, with
  proposals the user confirms, changes or rejects. Never write a
  requirement the user has not confirmed
- When the user names a target date or asks how long the work takes,
  offer `/gg-plan-schedule`: it cuts the requirements into tickets, estimates
  them and draws the plan as a Gantt chart in `charts/schedule.md`
- Keep the PM repo in its languages `dnaLanguages`, the leading one
  first: every file exists under `pm/<lang>` and `doc/<lang>` of each
  language, the README as `README.md` and `README.<lang>.md`. Change all
  copies in the same commit
- The people and their roles are in `team` of the current quarter. When
  the user asks what to tell someone, offer `/gg-plan-report`; when they
  want tickets in Jira or plan the next sprint of a person, offer
  `/gg-plan-jira-export`

`/gg-plan-intro` lists the planning skills and says which one comes next.
