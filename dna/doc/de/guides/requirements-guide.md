<!--
@license
Copyright (c) dnaCopyrightHolder

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# Leitfaden Requirements Engineering

Wie die Anforderungen eines Projekts gemeinsam mit dem Nutzer gefunden
werden. Ziele und Anforderungen liegen im aktuellen Quartalsordner
`pm/<lang>/<quarter>`. Wo sie geschrieben werden und wie eine Anforderung
aussieht, steht im
[Leitfaden PM-Repo](pm-repo-guide.md#write-the-requirements).

## @engineer Wissen, wann Anforderungen erhoben werden <a id="know-when-to-engineer-requirements"></a>

- Vor dem ersten Ticket eines Projekts
- Vor jedem Ticket, dessen Arbeit keine akzeptierte Anforderung abdeckt
- Wenn `pm/<lang>/<quarter>/requirements` fehlt oder leer ist
- Wenn ein Ziel hinzukommt oder sich ändert
- Wenn der Nutzer darum bittet

Tickets kommen nach den Anforderungen: Plane ein Ticket nur auf
akzeptierten Anforderungen. Bug-Tickets sind die Ausnahme, sie nennen ihre
Bug-Datei.

## @user Mit dem Nutzer arbeiten, nicht für ihn <a id="work-with-the-user-not-for-them"></a>

- Stelle eine Frage nach der anderen und gib dem Nutzer pro Antwort ein
  einziges Eingabefeld
- Schlage vor, statt blind zu fragen: Biete zwei bis vier mögliche
  Antworten an, abgeleitet aus Zielen, Themen, Code und früheren Antworten,
  und lass Raum für eine freie Antwort
- Sage, worauf jeder Vorschlag beruht, damit der Nutzer die Quelle
  korrigieren kann
- Schreibe nichts, was der Nutzer nicht bestätigt hat. Behalte
  unbestätigte Kandidaten nur dann als `proposed`, wenn der Nutzer später
  darauf zurückkommen will
- Hinterfrage vage Antworten: Bitte um eine Zahl, ein Beispiel oder eine
  Prüfung
- Halte nach jedem Bereich an, fasse zusammen, was vereinbart wurde, und
  frage, ob es weitergehen soll
- Sprich mit dem Nutzer in seiner Sprache; schreibe die Dateien zuerst in
  der führenden Sprache des Repos, dann in seinen anderen Sprachen, siehe
  den [Leitfaden PM-Repo](pm-repo-guide.md#keep-the-languages)

## @session Die Sitzung durchführen <a id="run-the-session"></a>

1. Lies das PM-Repo: `README.md` und die Ziele, Anforderungen, Themen,
   UX-Dateien, Entscheidungen und Architektur des aktuellen Quartals
2. Ziele: Gibt es kein aktives Ziel, finde zuerst eines — das Ergebnis,
   für wen, und woran wir erkennen, dass es erreicht ist — und schreibe es
   nach `goals`. Frage, welchen Zielen die Sitzung dient und ob
   `proposed`-Ziele bestätigt sind
3. Personen: Wer nutzt das Produkt, wer betreibt es, wer bezahlt, wer ist
   noch betroffen? Bestätige die Liste
4. Szenarien: Gehe die Hauptszenarien jedes Ziels mit dem Nutzer Schritt
   für Schritt durch. Schlage sie aus den Themen vor, wenn es welche gibt
5. Funktionale Anforderungen: Leite Kandidaten aus jedem Szenarioschritt
   ab, gruppiere sie nach Bereich und lass den Nutzer jeden bestätigen,
   ändern oder ablehnen
6. Qualitätsanforderungen: Gehe die Liste unten durch und frage nur nach
   den Punkten, die für dieses Produkt zählen
7. Randbedingungen: feste Technologien, Plattformen, Termine, Budgets,
   Gesetze. Schreibe sie als Anforderungen des Bereichs `constraints`
8. Abnahme: Schlage die Prüfungen vor, die jede Anforderung belegen, und
   lass den Nutzer sie bestätigen
9. Priorität: Lass den Nutzer jede Anforderung als `must`, `should` oder
   `could` markieren. Widersprich, wenn alles `must` ist
10. Prüfe die Menge, siehe unten, und stelle jeden Befund als Frage
11. Schreibe die Anforderungsdateien, verlinke sie aus den Zielen und fasse
    zusammen: was neu ist, was noch `proposed` ist und was als Nächstes
    kommt — die Tickets oder `/gg-plan-schedule` für einen Zeitplan

## @quality Nach den Qualitätsanforderungen fragen <a id="ask-for-the-quality-requirements"></a>

| Bereich              | Frage nach                                             |
| -------------------- | ------------------------------------------------------ |
| Performance          | Antwortzeiten, Mengen, Spitzenlast                     |
| Verfügbarkeit        | Betriebszeit, Offline-Nutzung, Wiederherstellung       |
| Sicherheit           | Wer darf was, Authentifizierung, Angriffe              |
| Datenschutz          | Personendaten, Einwilligung, Aufbewahrung, Recht (DSGVO) |
| Plattformen          | Geräte, Betriebssysteme, Browser                       |
| Barrierefreiheit     | Screenreader, Kontrast, Tastaturbedienung              |
| Sprachen             | Sprachen, Formate von Datum, Zahlen, Währungen         |
| Betrieb              | Deployment, Monitoring, Backups, Updates               |
| Kompatibilität       | Schnittstellen, Datenformate, Migration alter Daten    |
| Kosten               | Hosting, Lizenzen, Wartungsaufwand                     |

## @check Die Menge prüfen <a id="check-the-set"></a>

- Testbar — die Abnahmeprüfungen lassen sich tatsächlich ausführen
- Eine Sache — kein „und“, das zwei Bedürfnisse verbindet
- Was, nicht wie — keine Technologie, außer sie ist eine Randbedingung
- Eindeutig — kein „schnell“, „einfach“ oder „benutzerfreundlich“ ohne
  Zahl oder Prüfung
- Nachverfolgbar — nennt das Ziel, dem sie dient, und das Thema, aus dem
  sie stammt
- Widerspruchsfrei — widerspricht keiner anderen Anforderung und keiner
  Entscheidung
- Vollständig — das Maß jedes Ziels und jeder Szenarioschritt ist
  abgedeckt

## @requirements Anforderungen später ändern <a id="change-requirements-later"></a>

- Ändere sie auf dieselbe Weise: interaktiv, mit Bestätigung des Nutzers
- Vermerke in der Anforderung, was sich wann und warum geändert hat
- Nenne die Tickets und Zeitplaneinträge, die auf einer geänderten
  Anforderung beruhen, damit der Nutzer sie neu planen kann
