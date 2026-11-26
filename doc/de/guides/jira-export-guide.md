<!--
@license
Copyright (c) ggdna

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# Leitfaden Jira-Export

Wie die nächsten Tickets einer Person aus dem PM-Repo als CSV-Datei
exportiert werden, die Jira importiert: Stoff für einen Sprint, in der
Reihenfolge des Plans.

## Wissen, was der Export ist <a id="know-what-the-export-is"></a>

- Eine CSV-Datei pro Export:
  `pm/<lang>/<quarter>/exports/<yyyy>-<mm>-<dd>-<name>-sprint.csv`, `<name>`
  ist der Vorname in Kleinbuchstaben und Kebab-Case, `<quarter>` der
  aktuelle Quartalsordner `<yyyy>-Q<n>`
- Er enthält nur Tickets, die noch nicht in Jira sind, siehe unten
- Er weist Tickets nur zum Zeitpunkt des Exports zu: Wer an einem Ticket
  arbeitet, wird nie in die Ticket-Datei geschrieben
- Er braucht das Team: Fehlt `team/people.md` im aktuellen Quartal, lege
  es zuerst mit dem Nutzer an, siehe den
  [Leitfaden PM-Repo](pm-repo-guide.md#know-the-team)
- Die CSV gibt es in jeder Sprache des Repos: Übersetze die
  Zusammenfassungen und Beschreibungen, nie die Kopfzeile, die Schlüssel,
  die IDs oder die Namen

## Den Rahmen mit dem Nutzer festlegen <a id="set-the-frame-with-the-user"></a>

Stelle eine Frage nach der anderen und schlage jedes Mal einen Standard
vor:

- Person — Pflicht; eine aus `team/people.md`
- Sprintlänge — Standard: die aus `team/people.md`, sonst zwei Wochen
- Kapazität — Standard: Sprintlänge mal Tage pro Woche der Person; abzüglich
  Feiertagen, Urlaub und anderer Arbeit, die der Nutzer nennt
- Jira-Name der Person — Standard: das Feld `Jira` in `team/people.md`;
  frage nach, wenn es fehlt. Auf Jira Data Center oder Server ist es der
  Benutzername, auf Jira Cloud die Atlassian-Konto-ID: die lange ID am Ende
  der Profil-URL. Frage nie nach einer E-Mail-Adresse
- Jira — Data Center oder Server, oder Cloud; Standard: Data Center
- Jira-Projekt — der Schlüssel, in den die Vorgänge gehen; Standard: das
  Präfix der Ticket-Schlüssel, die das Repo schon verwendet
- Prioritäten — die Namen, die das Projekt anbietet; Standard: `High`,
  `Normal` und `Low`. Übernimm die Namen genau so, wie Jira sie schreibt,
  samt Leerzeichen
- Sprint — ein Sprint, in den die Vorgänge gehen, über seine numerische
  ID; Standard: keiner
- Stunden pro Tag — Standard: die aus `team/people.md`, sonst 8

Steht eine Jira-Verbindung zur Verfügung, z. B. der Atlassian-MCP-Server,
lies Benutzernamen, Vorgangstypen, Prioritäten und Sprints des Projekts
dort aus, statt danach zu fragen.

## Die offenen Tickets finden <a id="find-the-open-tickets"></a>

- Nimm die Ticket-Dateien in `pm/<lang>/<quarter>/tickets` des aktuellen
  Quartals — offene Tickets ziehen in jedes neue Quartal mit — und die
  geplanten Tickets aus dessen `charts/schedule.md`, die noch keine Datei
  haben
- Lass fertige Tickets weg: in `charts/schedule.md` als `done` markiert,
  oder alle ihre Anforderungen sind `done`
- Lass Tickets weg, die schon in Jira sind: Ihre ID ist ein Jira-Schlüssel,
  Buchstaben, ein Bindestrich und eine Zahl, z. B. `cdm-1317` in
  `2026-09-10-cdm-1317-infrastructure-discovery-server.md`. Reine Zahlen,
  z. B. `14`, sind lokale IDs, keine Jira-Schlüssel
- Ordne sie so wie `charts/schedule.md`; ohne Zeitplan danach, worauf sie
  warten, dann nach der Priorität ihrer Anforderungen: `must` vor `should`
  vor `could`

## Die Tickets der Person zuordnen <a id="match-the-tickets-to-the-person"></a>

- Vergleiche jedes offene Ticket mit den Bereichen jeder Person in
  `team/people.md`: den Repos, die es ändert, den Anforderungen und Zielen,
  denen es dient, den Worten seines Ziels und seiner Schritte
- Behalte die Tickets, deren beste Übereinstimmung die Person ist; ein
  Ticket, das zu mehreren Personen gleich gut passt, geht an die Person,
  die der Nutzer nennt
- Zeige eine Tabelle — Ticket, zugeordnete Person, der ausschlaggebende
  Bereich — und lass den Nutzer Tickets zwischen Personen verschieben.
  Schreibe nichts zurück

## Den Sprint füllen <a id="fill-the-sprint"></a>

- Nimm die erwartete Dauer jedes Tickets aus der Tabelle `Tickets` in
  `charts/schedule.md`. Fehlt sie, schätze sie, wie der
  [Leitfaden Zeitplan](schedule-guide.md#estimate-each-ticket) es
  beschreibt, und zeige die Zahlen zuerst
- Füge die Tickets der Person der Reihe nach hinzu, bis das nächste nicht
  mehr in die Kapazität passt; höre dort auf, springe nicht zu kleineren
  vor
- Ein Ticket, das größer ist als die ganze Kapazität: Biete zuerst an, es
  zu teilen
- Zeige den Sprint — Tickets, Tage, verbleibende Kapazität — und lass den
  Nutzer ihn bestätigen oder ändern

## Die CSV schreiben <a id="write-the-csv"></a>

Verwende diese Spalten in dieser Reihenfolge:

```csv
Summary,Issue Type,Priority,Assignee,Labels,Original Estimate,Sprint,Description
"Import race data",Story,High,anna,results-without-desktop-software,158400,1840,"Goal: ...
Requirements: req-results-002
Steps:
* ...
Plan: {{pm/en/2026-Q4/tickets/2026-11-02-import-race-data.md}}"
```

- `Summary` — der Ticket-Titel in Worten, nicht in Kebab-Case
- `Issue Type` — `Story`; `Bug` für ein Bug-Ticket. Beide müssen im
  Projekt existieren
- `Priority` — aus der höchsten Priorität seiner Anforderungen: `must` →
  der hohe, `should` → der mittlere, `could` → der niedrige der oben
  vereinbarten Namen
- `Assignee` — der Jira-Name der Person
- `Labels` — das Ziel, dem das Ticket dient, in Kebab-Case ohne
  Leerzeichen. Für ein zweites Label füge eine weitere Spalte hinzu,
  ebenfalls mit `Labels` überschrieben
- `Original Estimate` — die erwartete Dauer in ganzen Sekunden: Tage ×
  Stunden pro Tag × 3600. Bei 8 Stunden ergeben 5,5 Tage `158400`; bei 7,5
  Stunden `148500`. Jira zeigt sie in seiner eigenen Länge eines
  Arbeitstags an
- `Sprint` — die numerische Sprint-ID, nie der Name; ohne Sprint lass die
  Spalte weg
- `Description` — das Ziel, die Anforderungen per ID, die Schritte und der
  Pfad der Plan-Datei; ohne Plan-Datei die Zeile aus
  `charts/schedule.md`. Jira Data Center und Server rendern Wiki-Markup:
  Schreibe Listeneinträge als `* ` und setze Pfade, Dateinamen und IDs mit
  `_` oder geschweiften Klammern in `{{…}}`
- Lass `Issue Key` weg: Damit würde Jira bestehende Vorgänge aktualisieren
- Kodiere in UTF-8 ohne BOM, trenne mit Kommas, beende Zeilen mit `\n`;
  setze jedes Feld in Anführungszeichen, das ein Komma, ein
  Anführungszeichen oder einen Zeilenumbruch enthält, und verdopple die
  Anführungszeichen darin; gib jeder Zeile gleich viele Felder

## Dem Nutzer den Import erklären <a id="tell-the-user-how-to-import-it"></a>

- Jira Data Center oder Server: Issues → Import Issues from CSV; das
  braucht die Berechtigungen zum Anlegen von Vorgängen und zur
  Massenänderung
- Jira Cloud: Filters → Search work items → ••• → Import work items from
  CSV; höchstens 250 Arbeitselemente pro Datei
- Wähle das Projekt, die Kodierung UTF-8 und das Komma als Trennzeichen
- Ordne jede Spalte dem gleichnamigen Feld zu
- Setze den Haken bei „Map field value“ für `Priority`, `Issue Type` und
  `Assignee` nur, wenn ihre Werte von den Namen in Jira abweichen; nie für
  `Description`, sonst verwirft Jira die Zeilenumbrüche
- Erst validieren, dann importieren

## Die Schlüssel zurückholen <a id="take-the-keys-back"></a>

Hat der Nutzer die Datei importiert und bittet darum, schreibe die
Jira-Schlüssel zurück:

- Benenne jede exportierte Ticket-Datei von `<date>-<title>.md` in
  `<date>-<key>-<title>.md` um, Schlüssel in Kleinbuchstaben, und setze den
  Schlüssel in ihre Titelzeile: `# CDM-1800: Import race data`
- Ein Ticket ohne Datei bekommt jetzt eine, siehe den
  [Leitfaden PM-Repo](pm-repo-guide.md#write-the-ticket-file)
- Verwende den Schlüssel als Ticket-Namen in `charts/schedule.md`
- Mache dasselbe in jeder Sprache des Repos
