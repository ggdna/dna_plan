<!--
@license
Copyright (c) dnaCopyrightHolder

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# Leitfaden Berichte

Wie die Menschen eines Projekts auf dem Laufenden bleiben: Ein Bericht pro
Person und Quartal sammelt, was passiert ist, und jeder Punkt wird
abgehakt, sobald er mitgeteilt wurde.

## @report Wissen, was ein Bericht ist <a id="know-what-a-report-is"></a>

- Eine Datei pro Person und Quartal: `pm/<lang>/<quarter>/reports/<name>.md`,
  `<name>` ist der Vorname in Kleinbuchstaben und Kebab-Case, wie in
  `pm/<lang>/<quarter>/team/people.md`; `<quarter>` ist der aktuelle
  Quartalsordner `<yyyy>-Q<n>`
- Eine Liste von Punkten, die der Person mitzuteilen sind, jeder mit einer
  Checkbox. Ein abgehakter Punkt wurde mitgeteilt; ein offener muss es noch
  werden
- Er braucht das Team: Fehlen `team/people.md` und `team/roles.md` im
  aktuellen Quartal, lege sie zuerst mit dem Nutzer an, siehe den
  [Leitfaden PM-Repo](pm-repo-guide.md#know-the-team)

## @collect Die Punkte sammeln <a id="collect-the-points"></a>

- Beginne beim Datum des neuesten Punkts im Bericht der Person; ohne
  Bericht beim Beginn des Quartals
- Lies, was sich seitdem im PM-Repo geändert hat, z. B. mit
  `git log --since=<date> --name-status -- doc`:
  - Ziele, die hinzugefügt, bestätigt, erreicht oder verworfen wurden
  - Anforderungen, die hinzugefügt, akzeptiert, geändert, erledigt oder
    verworfen wurden
  - Entscheidungen, die akzeptiert oder abgelöst wurden
  - Tickets, die geplant oder abgeschlossen wurden, und ihre Blog-Beiträge
  - Verschiebungen in `charts/schedule.md`: eine spätere Prognose, ein
    verpasster oder verschobener Zieltermin
- Berichte, was passiert ist, nicht was abgelegt wurde: Verschiebungen,
  Umbenennungen, Übersetzungen, Umformatierungen und die Kopien zum
  Quartalsbeginn sind keine Neuigkeiten. Datiere jeden Punkt nach der
  Datei — Statuszeile, Ticket-Datum, Verlauf — nicht nach dem Commit, der
  sie berührt hat, und lass weg, was vor dem Startdatum passiert ist
- Finde die Rollen der Person in `team/roles.md`: jede Rolle, deren
  `People` sie aufführt. Behalte nur, was die Person braucht: worüber diese
  Rollen informiert werden und was ihre Bereiche in `team/people.md`
  berührt
- Schreibe jeden Punkt als einen Satz, den die Person ohne das Repo
  versteht: was sich geändert hat und was es für sie bedeutet. Verlinke die
  Datei, aus der er stammt
- Zeige dem Nutzer die vorgeschlagenen Punkte; schreibe nur die, die er
  bestätigt

## @report-2 Den Bericht schreiben <a id="write-the-report"></a>

Verwende diese Vorlage:

```markdown
# Report for Anna — 2026-Q4

- Roles: see [roles](../team/roles.md)
- Tick a point once it is communicated

## Carried over from 2026-Q3

- [ ] 2026-09-28: The result list is planned for November
      ([schedule](../charts/schedule.md))

## 2026-10

- [x] 2026-10-14: The goal "results without desktop software" is confirmed
      ([goal](../goals/results-without-desktop-software.md))
- [ ] 2026-10-20: The result list must be ready two seconds after the
      last finisher ([req-results-001](../requirements/results.md))
```

- Ein Abschnitt pro Monat, der neueste unten; Punkte in Datumsreihenfolge
- Jeder Punkt: `- [ ] <yyyy>-<mm>-<dd>: <sentence> ([<source>](<link>))`
- Lösche nie einen Punkt; ein Punkt, der sich als falsch herausstellt,
  bekommt einen neuen Punkt, der ihn korrigiert

## @quarter Ein neues Quartal beginnen <a id="start-a-new-quarter"></a>

- Lege zuerst den Quartalsordner an, siehe den
  [Leitfaden PM-Repo](pm-repo-guide.md#start-a-quarter)
- Lege beim ersten Bericht eines Quartals
  `pm/<lang>/<quarter>/reports/<name>.md` für die Person an
- Kopiere die offenen Punkte des Vorquartals unter
  `## Carried over from <yyyy>-Q<n>`, unverändert und weiterhin offen
- Beende den vorherigen Bericht mit einer Zeile:
  `Open points carried over to [<yyyy>-Q<n>](../../<yyyy>-Q<n>/reports/<name>.md).`
  Lass den Rest der alten Datei, wie er ist
- Eine Person, die im Lauf des Quartals hinzugekommen ist, beginnt mit
  einem leeren Bericht

## @languages Alle Sprachen im Gleichschritt halten <a id="keep-all-languages-in-step"></a>

- Jeder Bericht existiert in jeder Sprache des Repos (siehe den
  [Leitfaden PM-Repo](pm-repo-guide.md#keep-the-languages)), als
  `pm/<lang>/<quarter>/reports/<name>.md`
- Schreibe jeden Punkt in alle
- Ein Haken in irgendeiner Datei zählt: Ist ein Punkt in einer Sprache
  abgehakt, hake ihn in den anderen ab. Prüfe alle vor jedem neuen Bericht
