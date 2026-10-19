<!-- helix:claude_md:start -->

# Planning

Projects are planned in a project management repo; its structure and the
planning rules are in `doc/guides/pm-repo-guide.md`. When you plan in one:

- Engineer the requirements before the tickets. If `doc/requirements` is
  empty or no accepted requirement covers the work, run
  `/plan-requirements` with the user first, and plan or create tickets
  only after that
- Engineer requirements interactively: one question at a time, with
  proposals the user confirms, changes or rejects. Never write a
  requirement the user has not confirmed
- When the user names a target date or asks how long the work takes,
  offer `/plan-schedule`: it cuts the requirements into tickets, estimates
  them and draws the plan as a Gantt chart in `doc/schedule.md`

`/plan-intro` lists the planning skills and says which one comes next.

<!-- helix:claude_md:end -->
