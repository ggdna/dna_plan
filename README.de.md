# dna_plan

[English](README.md) | Deutsch

Gibt einem Repo den Guide, um ein Projekt in einem Projektmanagement-Repo zu
planen: Ziele, Konzepte, Tickets, Quartale und Design-Ergebnisse.

## Motivation

Ziele, Konzepte, Entscheidungen und Ticket-Pläne sind kein Code und gehören
nicht in ein Code-Repo. Diese Schicht gibt ihnen einen eigenen Ort: ein
Projektmanagement-Repo (PM-Repo) mit fester Struktur, einem Ordner pro Quartal
und festen Dateinamen. Jedes Ticket gehört zu genau einem PM-Repo, und der
gg-Ticket-Ablauf liest diesen Guide, wenn er dort ein Ticket plant — so landet
der Plan immer an derselben Stelle.

## Verwendung

Die Schicht kommt in das Projektmanagement-Repo selbst. Als Dev-Dependency
eintragen und einmal initialisieren:

```bash
dart pub add dev:dna_plan     # Dart projects
pnpm add -D @ggdna/dna-plan   # TypeScript projects
gg dna init
gg dna build
```

`gg dna init` legt einen Test ab, der die Schicht bei jedem Testlauf
instanziiert; `gg dna build` führt dieselbe Instanziierung einmal ohne
Test-Framework aus. Dabei landet der Guide in `doc/guides/pm-repo-guide.md`.

Nimmt ein gg-Ticket das PM-Repo auf, liest der Skill `/gg-ticket` aus
[dna_gg](https://github.com/ggsuite/dna_gg) diesen Guide und schreibt den Plan
so, wie er es beschreibt, nach `doc/<yyyy>-Q<n>/tickets/`.

## Guides

- `dna/doc/guides/pm-repo-guide.md` — was ein PM-Repo ist, seine
  Ordnerstruktur pro Quartal, der Konzept-Ordner mit Themen, Entscheidungen
  und UX, Blogposts, Dateinamen, wohin die Ergebnisse der Design-Schichten
  kommen und wie ein Ticket und ein Quartal geplant werden

## Umfang

Die Schicht liefert nur den Guide für das PM-Repo, keine Skills und keine
Templates. Die sieben Schichten des Produktdesigns, mit denen der Guide plant
— der [Layers-Guide](https://github.com/ggdna/dna_design_layers), ein Guide pro
Schicht und die Skills `/layers-*` —, kommen aus dna_design_layers. Blogposts
entstehen nur, wenn das Repo auch den Blog-Guide aus dna_blog hat. Der
Ticket-Ablauf selbst gehört zu dna_gg.

## Schichten

Die Schicht ist orthogonal: `dna/_dna.json` nennt keine Eltern-Schichten. Sie
trägt nur ihr eigenes Thema und bleibt bewusst ohne Eltern — eine Eltern-Schicht
würde jeden Nutzer dieses Themas erreichen, ob das Repo danach gefragt hat oder
nicht.

Heute listet kein Umbrella die Schicht, auch dna_ggdna nicht: Ein PM-Repo
bindet dna_plan selbst ein.

## Variablen

- `dnaCopyrightHolder` — der Rechteinhaber im Copyright-Kopf des abgelegten
  Guides. `dna/_dna.json` deklariert kein `mustOverride`, ein nutzendes Repo
  muss ihn also nicht setzen; ohne eigenen Wert in `dna/_vars.json` nennt der
  Kopf `ggdna`

## Entwicklung

Der Ordner `dna/` ist handgeschriebene Quelle und wird nie generiert. Das Repo
instanziiert seine eigene DNA — nach Änderungen `dart test` laufen lassen;
vorher committen, denn eine Datei, die die DNA überschreiben würde, darf keine
uncommittete Arbeit enthalten.

Bearbeite die Dateien unter `dna/`, nie ihre Kopien in `doc/`: Der Test
überschreibt sie.

## Lizenz

MIT — siehe [LICENSE](LICENSE).
