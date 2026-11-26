<!--
@license
Copyright (c) dnaCopyrightHolder

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# Leitfaden Projektmanagement-Repo

## @pm Wissen, was ein PM-Repo ist <a id="know-what-a-pm-repo-is"></a>

- Ein Projektmanagement-Repo (PM-Repo) enthält Ziele, Anforderungen,
  Konzepte, Pläne, Zeitplan, Besprechungen, Entscheidungen und
  Blog-Beiträge eines Projekts — keinen Code
- Jedes Ticket gehört zu genau einem PM-Repo. Füge es dem Ticket vor jedem
  Code-Repo hinzu (siehe den `gg`-Entwicklungsleitfaden)
- Ein Ticket, das nur geplant wird, endet mit dem PM-Repo allein
- Anforderungen kommen vor Tickets: Erhebe sie zuerst mit dem Nutzer, siehe
  [Zuerst die Anforderungen erheben](#engineer-the-requirements-first)
- Halte jede Datei in jeder Sprache des Repos, siehe
  [Die Sprachen pflegen](#keep-the-languages)

## @structure Das Repo so strukturieren <a id="structure-the-repo-like-this"></a>

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

- `pm` enthält alles, was das Projekt plant und schreibt, `doc` die
  Dokumentation, die zu keinem Quartal gehört. Beide haben einen Ordner pro
  Sprache, siehe [Die Sprachen pflegen](#keep-the-languages)
- In `pm/<lang>` liegt alles in einem Quartalsordner `<yyyy>-Q<n>`, unten
  `pm/<lang>/<quarter>` genannt. Nichts davon liegt neben den
  Quartalsordnern, damit das Repo über die Jahre nicht dicker und schwerer
  lesbar wird: Der neueste Quartalsordner enthält alles, was noch gilt, die
  älteren sind Geschichte
- Der neueste Quartalsordner ist das aktuelle Quartal. Lies und schreibe
  nur dort; ändere nie ein älteres Quartal
- Was am Ende eines Quartals noch gilt, wird in das nächste kopiert, siehe
  [Ein Quartal beginnen](#start-a-quarter)
- `doc/<lang>/guides` und `doc/<lang>/templates` kommen aus den
  DNA-Schichten; bearbeite sie nie
- `README.md` nennt das Projekt und verlinkt das aktuelle Quartal, seine
  aktiven Ziele und seine Anforderungen
- `architecture` — das Zielbild des Systems: `architecture.md` plus
  Diagramme in `img` als Mermaid-Dateien `.mmd`
- `blog` — ein Beitrag pro abgeschlossenem Ticket; existiert nur, wenn das
  Repo `doc/en/guides/blog-guide.md` aus der Schicht `dna_blog` hat, siehe
  unten
- `bugs` — eine Datei pro Bug; ein Bug wird zum Ticket, sobald er geplant
  wird
- `charts` — der Zeitplan `schedule.md` und jedes andere Diagramm des
  Quartals, siehe [Diagramme zeichnen](#draw-charts)
- `concepts` — was das Produkt ist und warum: `topics`, `decisions` und
  `ux`, siehe unten
- `exports` — CSV-Dateien mit Tickets für Jira, siehe
  [Tickets nach Jira exportieren](#export-tickets-to-jira)
- `goals` — was das Projekt erreichen will und für wen; eine Datei pro
  Ziel, siehe unten
- `meetings` — eine Datei pro Besprechung, siehe
  [Die Besprechungen festhalten](#keep-the-meetings)
- `prompts` — Prompts, die es wert sind, aufbewahrt zu werden, z. B. der
  Prompt, der ein Ticket gestartet hat; eine Datei pro Prompt,
  `<yyyy>-<mm>-<dd>-<title>.md`
- `reports` — ein Bericht pro Person mit den Punkten, die ihr mitzuteilen
  sind, siehe [Den Menschen berichten](#report-to-the-people)
- `requirements` — was das Produkt tun oder sein muss; eine Datei pro
  Bereich, siehe unten
- `team` — wer am Projekt arbeitet und in welchen Rollen, siehe
  [Das Team kennen](#know-the-team)
- `tickets` — eine Plan-Datei pro Ticket

## @goals-requirements Ziele und Anforderungen unterscheiden <a id="tell-goals-and-requirements-apart"></a>

- Ein Ziel sagt **warum** und **für wen**: ein Ergebnis, das das Projekt
  will, z. B. „Vereine werten ihre Rennen ohne Desktop-Software aus“. Es
  lässt offen, wie es erreicht wird, und ist erledigt, wenn das Ergebnis da
  ist
- Eine Anforderung sagt, **was** das Produkt tun oder sein muss: eine
  prüfbare Aussage über das System, z. B. „die Ergebnisliste steht zwei
  Sekunden nach dem letzten Zieleinlauf bereit“. Sie sagt nichts darüber,
  wie es gebaut wird, und gilt, bis sie geändert oder verworfen wird
- Ein Ticket sagt **wie** und **wann**: ein Schritt, der Anforderungen im
  Dienst eines Ziels erfüllt
- Themen (Topics) enthalten den Problemraum — Belege und
  Nutzerbedürfnisse. Anforderungen sind die daraus abgeleiteten
  Verpflichtungen; schreibe keine Anforderungen in Themen
- Ziele und Anforderungen überdauern Quartale: Ein Ziel kann mehrere
  Quartale brauchen, eine Anforderung gilt so lange wie das Produkt. Darum
  werden die offenen in jedes neue Quartal kopiert, siehe
  [Ein Quartal beginnen](#start-a-quarter)

## @goals Die Ziele schreiben <a id="write-the-goals"></a>

- Lege `pm/<lang>/<quarter>/goals/<title>.md` an, Titel in englischem
  Kebab-Case
- Verwende diese Abschnitte in dieser Reihenfolge:

```markdown
# <Title>

## Status

## Outcome

## Measure

## Requirements
```

- `Status` — `proposed`, `active`, `reached` oder `dropped`, dazu die
  Quartale, in denen am Ziel gearbeitet wurde, z. B.
  `active since 2026-Q3`. Ein Ziel ist `proposed`, bis das Team es
  bestätigt
- `Outcome` — ein Absatz: was sich ändert, für wen und warum es zählt
- `Measure` — woran wir erkennen, dass das Ziel erreicht ist
- `Requirements` — Links auf die aus dem Ziel abgeleiteten Anforderungen
- Lösche nie ein Ziel; setze es auf `reached` oder `dropped` und sage,
  warum

## @write-requirements Die Anforderungen schreiben <a id="write-the-requirements"></a>

- Gruppiere Anforderungen nach Bereich des Produkts, eine Datei pro
  Bereich: `pm/<lang>/<quarter>/requirements/<area>.md`, Bereich in
  englischem Kebab-Case
- Gib jeder Anforderung eine ID `req-<area>-<nnn>`, z. B.
  `req-results-001`; das Präfix hält sie von Entscheidungs-IDs getrennt.
  Verwende eine ID nie wieder und nummeriere nie um. Eine neue ID folgt auf
  die höchste des Bereichs über alle Quartale, da erledigte Anforderungen
  in älteren Quartalen zurückbleiben
- Schreibe jede Anforderung als eigenen Abschnitt:

```markdown
## req-results-001: Result list right after the race

- Status: accepted
- Priority: must
- Statement: The result list is ready two seconds after the last finisher
- Why: [results without desktop software](../goals/results-without-desktop-software.md),
  topic `timing`
- Acceptance: a race with 500 finishers shows the list within two seconds
```

- `Status` — `proposed`, `accepted`, `done` oder `dropped`
- `Priority` — `must`, `should` oder `could`; was gar nicht gewollt ist,
  ist `dropped`
- `Statement` — ein Satz dazu, was das Produkt tun oder sein muss, nie wie
- `Why` — das Ziel, dem sie dient, und das Thema, aus dem sie stammt
- `Acceptance` — die Prüfungen, die sie belegen; bei Bedarf ein
  Aufzählungspunkt pro Prüfung
- Ändere eine Anforderung an Ort und Stelle und sage, was sich wann
  geändert hat; eine ersetzte Anforderung wird auf `dropped` gesetzt und
  verlinkt ihre Nachfolgerin
- Eine kaputte `done`-Anforderung ist ein Bug, keine neue Anforderung

## @engineer Zuerst die Anforderungen erheben <a id="engineer-the-requirements-first"></a>

- Finde Ziele und Anforderungen gemeinsam mit dem Nutzer, eine Frage nach
  der anderen und mit Vorschlägen: Der
  [Leitfaden Requirements Engineering](requirements-guide.md) sagt, wie,
  `/gg-plan-requirements` führt es aus
- Tu es vor dem ersten Ticket, immer wenn
  `pm/<lang>/<quarter>/requirements` leer ist, und immer wenn die Arbeit
  eines Tickets von keiner akzeptierten Anforderung abgedeckt ist
- Plane und lege Tickets erst danach an. Bug-Tickets sind die Ausnahme:
  Sie nennen stattdessen ihre Bug-Datei
- `/gg-plan-intro` listet die Planungs-Skills auf und sagt, welcher als
  Nächstes kommt

## @team Das Team kennen <a id="know-the-team"></a>

- Halte in `pm/<lang>/<quarter>/team/people.md` fest, wer am Projekt
  arbeitet, ein Abschnitt pro Person:

```markdown
# People

- Sprint length: 2 weeks
- Hours per day: 8

## Anna

- Areas: result list, import of race data, the `timing_app` repo
- Days per week: 4
- Jira: anna
```

- Der Abschnittstitel ist der Vorname; die Dateinamen der Person
  verwenden ihn in Kleinbuchstaben und Kebab-Case: `anna`
- `Areas` — worum sich die Person kümmert: Features, Themen, Repos. Der
  Jira-Export ordnet Tickets darüber Personen zu
- `Days per week` — wie viel der Woche die Person am Projekt arbeitet
- `Jira` — der Name, unter dem Jira die Person kennt: der Benutzername auf
  Jira Data Center oder Server, z. B. `anna`, die Atlassian-Konto-ID auf
  Jira Cloud; optional
- `Sprint length` — einmal, ganz oben; Standard zwei Wochen
- `Hours per day` — einmal, ganz oben: die Arbeitsstunden eines Tages,
  um Schätzungen in Tagen in Stunden umzurechnen; Standard 8
- Halte die Rollen in `pm/<lang>/<quarter>/team/roles.md` fest, ein
  Abschnitt pro Rolle. Beginne mit Developer, Product Owner, Management,
  Sales und Customer und ergänze die, die das Projekt braucht:

```markdown
# Roles

## Product Owner

- Responsible for: goals, requirements and their priority
- People: Anna
- Hears about: goals, requirements, decisions, schedule shifts
```

- `People` — die Vornamen aus `people.md`, die die Rolle haben. Dies ist
  die einzige Stelle, die sagt, wer welche Rolle hat; `people.md`
  wiederholt es nicht
- `Hears about` entscheidet, was in den Berichten der Personen in dieser
  Rolle landet. Kunden und Vertrieb hören von Ergebnissen und Terminen,
  nie von Interna wie Code, offenen Entscheidungen oder Schätzungen
- Eine Person kann mehrere Rollen haben und daher unter mehreren
  aufgeführt sein; ihr Bericht deckt alle ab
- Frage den Nutzer vor dem ersten Bericht oder Export nach dem Team; rate
  nie Personen oder Rollen
- Halte in `team` nur Vornamen, Bereiche und Rollen fest, außerdem das
  Jira-Konto und die Git-Benutzernamen; keine Kontaktdaten
- Frage nie nach E-Mail-Adressen und schreibe nie eine ins PM-Repo, weder
  in `team` noch sonst wohin. Bietet der Nutzer eine an, frage stattdessen
  nach dem Git-Benutzernamen oder dem Jira-Konto

## @concepts Den Ordner concepts füllen <a id="fill-the-concepts-folder"></a>

- `topics` — eine Datei pro Produktthema: Belege, Anwendungsfälle,
  Nutzerbedürfnisse, was versucht wurde und was gilt; der Ort für Wissen
  über den Problemraum
- `decisions` — eine Datei pro Entscheidung, `<area>-<nnn>.md`, z. B.
  `design-001.md`; `000-index.md` listet alle Entscheidungen mit ID,
  Status, Datum, einer Zeile und offener Arbeit
- `ux` — akzeptierte Aussagen über Oberfläche und Abläufe des Produkts:
  welchen Objekten, Orten und Worten der Nutzer begegnet, und warum
- Schreibe eine Entscheidungsdatei mit: Titel, Status (proposed /
  accepted / superseded), Datum, maßgeblicher Quelle, offener Arbeit, der
  Entscheidung in einem Absatz
- Schreibe eine Entscheidung nie um; löse sie durch eine neue ab und
  verlinke in beide Richtungen

## @blog Blog-Beiträge schreiben <a id="write-blog-posts"></a>

- Schreibe einen Beitrag nur, wenn `doc/en/guides/blog-guide.md` existiert;
  er kommt aus der Schicht `dna_blog`. Ohne ihn schreibe keinen Beitrag und
  überspringe den Rest dieses Abschnitts
- Folge dem Blog-Leitfaden für Inhalt und Vorlage
- Lege den Beitrag in `pm/<lang>/<quarter>/blog` des PM-Repos ab, im
  Quartal des Tages, an dem das Ticket abgeschlossen wird
- Benenne ihn `<yyyy>-<mm>-<dd>-<title>.md`, Titel in englischem Kebab-Case
- Ein Beitrag kann alle Repos des Tickets abdecken, die zur Organisation
  des PM-Repos gehören
- Schreibe nur Wissen der Organisation des PM-Repos
- Lass Repos anderer Organisationen im Ocean weg, auch wenn sie am Ticket
  beteiligt waren. Nenne sie nur als aktualisierte Abhängigkeiten:
  öffentlicher Paketname, Version und was das Update für die Repos dieser
  Organisation bedeutet; nie ihre Tickets, Pläne oder Interna

## @files Die Dateien benennen <a id="name-the-files"></a>

- Stelle Ticket- und Bug-Dateien das Datum voran: `<yyyy>-<mm>-<dd>-`
- Füge die Ticket-ID in Kleinbuchstaben hinzu: `cdm-1317`
- Schließe mit dem Titel in englischem Kebab-Case ab:
  `2026-09-10-cdm-1317-infrastructure-discovery-server.md`
- Benenne Ziele, Anforderungsbereiche, Themen, UX-Dateien,
  Architekturdateien und Diagramme nach ihrem Thema, in englischem
  Kebab-Case
- Benenne Berichte `<name>.md` und Exporte
  `<yyyy>-<mm>-<dd>-<name>-sprint.csv`, wobei `<name>` der Vorname in
  Kleinbuchstaben und Kebab-Case ist
- Behalte die englischen Dateinamen in jeder Sprache bei

## @meetings Die Besprechungen festhalten <a id="keep-the-meetings"></a>

- Schreibe eine Datei pro Besprechung in `pm/<lang>/<quarter>/meetings`,
  benannt `<yyyy>-<mm>-<dd>-<topic>.md`, Thema in englischem Kebab-Case
- Verwende diese Abschnitte in dieser Reihenfolge:

```markdown
# <Topic> — <yyyy>-<mm>-<dd>

## Participants

## Topics

## Decisions

## Tasks
```

- `Participants` — die Vornamen aus `team/people.md`, dazu Gäste nach
  Rolle; nie Kontaktdaten
- `Decisions` — eine Zeile pro Entscheidung; eine Entscheidung, die das
  Produkt prägt, bekommt zusätzlich eine eigene Datei in
  `concepts/decisions`
- `Tasks` — eine Checkbox pro Aufgabe mit dem Vornamen der Person, die sie
  erledigt
- Mache aus Aufgaben, die das Produkt ändern, Tickets; verlinke das Ticket
  aus der Aufgabe

## @charts Diagramme zeichnen <a id="draw-charts"></a>

- Lege jedes Diagramm des Quartals in `pm/<lang>/<quarter>/charts` ab,
  eine Markdown-Datei pro Diagramm mit dem Diagramm als Mermaid, z. B. den
  Zeitplan `schedule.md`, ein Burn-down oder die Verteilung der Tickets
- Benenne ein Diagramm nach seinem Thema, in englischem Kebab-Case
- Sage in einem Absatz über dem Diagramm, was es zeigt und aus welchen
  Dateien es gezeichnet wird, damit es neu gezeichnet werden kann
- Zeichne ein Diagramm neu, wenn sich seine Quellen ändern; bearbeite nie
  ein Diagramm eines älteren Quartals

## @languages Die Sprachen pflegen <a id="keep-the-languages"></a>

- Dieses Repo hält seine Dateien in diesen Sprachen, die führende zuerst:
  `dnaLanguages`. Ändere sie in den `vars` von `dna/_dna.json`, unter dem
  Schlüssel `dna` + `Languages` in einem Wort, z. B. `"en,de"`
- Jede Datei von `pm` und `doc` existiert einmal pro Sprache, unter
  `pm/<lang>` und `doc/<lang>` mit gleichem Pfad und Dateinamen, wobei
  `<lang>` der zweibuchstabige Code der Sprache ist
- `README.md` ist Englisch, jede andere Sprache hat `README.<lang>.md`
- Schreibe die Datei der führenden Sprache zuerst, auch wenn der Nutzer
  eine andere spricht, dann die anderen Sprachen; ändere alle im selben
  Commit
- Übersetze Überschriften und Fließtext. Lass IDs, Dateinamen, Links, die
  Status- und Prioritätswerte und die Feldnamen der Anforderungen, wie sie
  sind, damit jede Kopie für Werkzeuge lesbar bleibt
- Halte alle Kopien inhaltlich und strukturell gleich; ein abgehakter
  Punkt in einem Bericht ist in allen abgehakt
- Übersetze auch die Exporte: die Zusammenfassungen und Beschreibungen,
  nie die Kopfzeile, die Schlüssel, die IDs oder die Namen, damit Jira
  jeden davon importiert
- Die Leitfäden und Vorlagen kommen in jeder Sprache aus den DNA-Schichten;
  übersetze oder bearbeite sie nie

## @people Den Menschen berichten <a id="report-to-the-people"></a>

- Führe einen Bericht pro Person und Quartal in
  `pm/<lang>/<quarter>/reports/<name>.md`: die Punkte, die die Person
  erfahren muss, jeder mit einer Checkbox, die abgehakt wird, sobald er
  mitgeteilt ist
- Der [Leitfaden Berichte](report-guide.md) sagt, wie, `/gg-plan-report`
  führt es aus: Er sammelt, was sich für die Rollen und Bereiche der Person
  geändert hat, hängt es an und beginnt die Datei eines neuen Quartals mit
  den übernommenen offenen Punkten

## @export Tickets nach Jira exportieren <a id="export-tickets-to-jira"></a>

- Exportiere die nächsten Tickets einer Person als CSV-Datei, die Jira
  importiert: `pm/<lang>/<quarter>/exports/<yyyy>-<mm>-<dd>-<name>-sprint.csv`
- Der [Leitfaden Jira-Export](jira-export-guide.md) sagt, wie,
  `/gg-plan-jira-export` führt es aus: Er ordnet die offenen Tickets ohne
  Jira-Schlüssel über ihre Bereiche der Person zu, füllt einen Sprint
  anhand der Schätzungen und schreibt die Datei
- Die Person wird nur zum Zeitpunkt des Exports zugewiesen, nie in der
  Ticket-Datei

## @layers Die Design-Schichten nutzen <a id="use-the-design-layers"></a>

- Plane mit den sieben Schichten des Produktdesigns; die Schicht
  `dna_design_layers` liefert den
  [Leitfaden zu den Schichten](layers-guide.md), einen Leitfaden pro
  Schicht und die `/layers-*`-Skills
- Führe `/layers-orient` aus, bevor du ein Ticket planst, das das Produkt
  ändert; es nennt die Schicht, die zuerst Aufmerksamkeit braucht
- Schreibe das Ergebnis jeder Schicht ins PM-Repo:

| Schicht                                           | Landet in                     |
| ------------------------------------------------- | ----------------------------- |
| Beobachtetes Verhalten, Domäne, Nutzerbedürfnisse | `concepts/topics`             |
| Produktstrategie                                  | `goals`                       |
| Wozu Bedürfnisse und Strategie verpflichten       | `requirements`                |
| Konzeptmodell, Interaktionsablauf                 | `concepts/ux`, `architecture` |
| Oberfläche                                        | `concepts/ux`                 |
| Jede Entscheidung auf dem Weg                     | `concepts/decisions`          |

- Plane kein Ticket auf einer Schicht, deren Fundament schwach ist; plane
  zuerst das Fundament oder sage klar, dass das Ticket eine Wette ist

## @ticket Ein Ticket planen <a id="plan-a-ticket"></a>

Lege das Ziel fest: ein Absatz dazu, was erreicht wird und für wen, und
welchem Ziel des Projekts es dient.

Liste die Anforderungen, die das Ticket erfüllt, per ID auf. Deckt keine
akzeptierte Anforderung die Arbeit ab, halte an und erhebe die
Anforderungen zuerst mit dem Nutzer, siehe
[Zuerst die Anforderungen erheben](#engineer-the-requirements-first).

Nenne die betroffenen Repos und was sich in jedem ändert.

Liste die groben Schritte der Reihe nach auf; eine Zeile pro Schritt.

Sammle die offenen Fragen; kläre sie mit dem Nutzer vor der Umsetzung.

Verlinke die Ziele, Anforderungen, Entscheidungen und Themen, auf denen der
Plan beruht.

Lass den Nutzer den Plan prüfen und überarbeite ihn, bis er ihn bestätigt.

## @ticket-file Die Ticket-Datei schreiben <a id="write-the-ticket-file"></a>

- Lege `pm/<lang>/<quarter>/tickets/<date>-<id>-<title>.md` an
- Verwende diese Abschnitte in dieser Reihenfolge:

```markdown
# <ID>: <Title>

## Goal

## Requirements

## Affected repos

## Steps

## Open questions
```

- Halte den Plan kurz; schreibe mehr nur bei komplexen Tickets
- Brich Zeilen bei 80 Zeichen um
- Bette Mermaid-Diagramme ein, wenn ein Bild mehr sagt als Text

## @plan Den Plan lebendig halten <a id="keep-the-plan-alive"></a>

- Aktualisiere den Plan, wenn die Umsetzung von ihm abweicht
- Verschiebe beantwortete Fragen aus `Open questions` in den Plan oder in
  eine Entscheidungsdatei
- Setze die Anforderungen, die das Ticket erfüllt hat, auf `done`, wenn es
  abgeschlossen ist
- Markiere das Ticket in `pm/<lang>/<quarter>/charts/schedule.md` mit
  `done`, falls das Projekt einen Zeitplan hat
- Verweise im Blog-Beitrag, der das Ticket abschließt, auf den Plan
- Behalte die Datei: Der Plan dokumentiert, warum die Dinge so sind, wie
  sie sind

## @time Die Zeit planen <a id="plan-the-time"></a>

- Ein Zeitplan ist optional; erstelle einen, wenn der Nutzer ihn will
  oder einen Zieltermin für das Projekt nennt
- Der [Leitfaden Zeitplan](schedule-guide.md) sagt, wie,
  `/gg-plan-schedule` führt es aus: Er fragt nach Zieltermin und
  Kapazität, schneidet die akzeptierten Anforderungen in Tickets, schätzt
  jedes und zeichnet den Plan als Gantt-Diagramm in
  `pm/<lang>/<quarter>/charts/schedule.md`
- Plane die Zeit nur auf akzeptierten Anforderungen

## @quarter Ein Quartal beginnen <a id="start-a-quarter"></a>

Lege den Ordner eines neuen Quartals an, bevor die erste Datei dieses
Quartals geschrieben wird, z. B. `pm/en/2027-Q1` beim ersten Ticket im
Januar. Sage es dem Nutzer, zeige, was übernommen wird, und committe es
für sich als `Start <yyyy>-Q<n>`.

Kopiere, was aus dem Vorquartal noch gilt:

| Was                  | In das neue Quartal kopiert                          |
| -------------------- | ---------------------------------------------------- |
| `goals`              | die Ziele mit `proposed` und `active`                |
| `requirements`       | pro Bereich die Anforderungen nicht `done`/`dropped` |
| `team`               | alles                                                |
| `architecture`       | alles                                                |
| `concepts/ux`        | alles                                                |
| `concepts/decisions` | `000-index.md` ohne die abgelösten Entscheidungen    |
| `charts/schedule.md` | die Tickets nicht `done`, eine frische `History`     |
| `reports`            | die offenen Punkte, per `/gg-plan-report`            |

Verschiebe die offenen Tickets und Bugs mit `git mv` in `tickets` und
`bugs` des neuen Quartals: Ein Ticket ist offen, solange es im Zeitplan
nicht `done` ist und nicht alle seine Anforderungen `done` sind; frage
den Nutzer im Zweifel. Das ist die einzige Änderung an einem älteren
Quartal.

Lass den Rest, wo er geschrieben wurde: Themen, Entscheidungsdateien,
abgeschlossene Tickets, Blog-Beiträge, Besprechungen, Prompts, Exporte und
die Diagramme außer dem Zeitplan. Das neue Quartal beginnt ohne sie und
verlinkt sie im älteren Quartal, z. B.
`../../2026-Q4/concepts/decisions/design-001.md`.

- Korrigiere die Links der kopierten und verschobenen Dateien: Links
  innerhalb des Quartals bleiben, wie sie sind, Links auf das
  Zurückgebliebene zeigen ins ältere Quartal
- Lass einen Anforderungsbereich weg, dessen Anforderungen alle `done`
  oder `dropped` sind; ihre IDs bleiben vergeben
- Ergänze das neue Quartal im `Status` der übernommenen Ziele, z. B.
  `active since 2026-Q3`
- Lass `README.md` auf das neue Quartal zeigen
- Mache dasselbe in jeder Sprache des Repos

## @quarter-2 Ein Quartal planen <a id="plan-a-quarter"></a>

Lege zuerst den Quartalsordner an, siehe
[Ein Quartal beginnen](#start-a-quarter).

Wähle die Ziele, an denen das Quartal arbeitet: Füge neue zu `goals` hinzu,
setze übernommene Ziele auf `reached` oder `dropped`, wenn sie es sind.

Leite die Anforderungen gemeinsam mit dem Nutzer aus den Zielen und Themen
ab; füge neue hinzu und ändere die, die die Ziele verändern.

Aktualisiere `architecture/architecture.md`, wenn ein Ziel das Zielbild
ändert.

Leite Tickets aus den Anforderungen ab; jedes Ticket nennt das Ziel, dem es
dient, und die Anforderungen, die es erfüllt.

Aktualisiere `charts/schedule.md`, falls das Projekt einen Zeitplan hat,
und prüfe die Prognose gegen den Zieltermin.

Prüfe `team` und beginne die Berichte des Quartals mit `/gg-plan-report`;
es übernimmt die offenen Punkte des letzten Quartals.
