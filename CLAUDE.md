# Counsel — Kontradiktorischer Rechtsaustausch

Dieses Projekt simuliert einen vollständigen außergerichtlichen Schriftwechsel zwischen zwei gegnerischen Fachanwälten. Ziel ist es, die eigene Rechtsposition **vor dem Gang zum echten Anwalt** vorzubereiten, zu schärfen und auf Schwachstellen zu testen.

> **RDG-Hinweis:** Keine Rechtsberatung i.S.d. § 2 RDG. Alle Ausgaben sind Entwürfe zur Vorbereitung. Generierte Schreiben **nicht ungeprüft versenden**. Vor Versand: Prüfung durch zugelassenen Rechtsanwalt empfohlen.

## Konzept

Zwei unabhängige Skills agieren als gegnerische Anwälte, die ausschließlich über formelle Briefe miteinander kommunizieren — genau wie in der Realität:

- **`/counsel:anspruch`** — Dein Anwalt. Erhebt die Sachlage, analysiert deine Rechtsposition, erstellt ein Forderungsschreiben.
- **`/counsel:abwehr`** — Der Gegenanwalt. Erhält nur den Brief deines Anwalts und zerlegt ihn systematisch. Kennt deine interne Strategie nicht.

Das Rechtsgebiet ist **flexibel wählbar** (Vertragsrecht, Mietrecht, Arbeitsrecht, IT-Recht, Baurecht, Handelsrecht, etc.) — wird beim Erstaufruf per Q&A erhoben.

### Informationsbarriere

Das zentrale Designprinzip ist die **strikte Informationstrennung** — wie beim echten Anwaltsgeheimnis:

| | `/counsel:anspruch` (Anwalt) | `/counsel:abwehr` (Gegenanwalt) |
|---|---|---|
| **Liest** | `anwalt/SACHLAGE.md`, `anwalt/data/*` | **nur** `gegenseite/data/*` |
| **Schreibt** | `anwalt/data/BRIEF_ANWALT_N.md` | `gegenseite/data/BRIEF_GEGENSEITE_N.md` |
| **TABU** | — | `anwalt/` (komplett), `skills/anspruch/` |

Der Gegenanwalt kennt nur das, was ihm formal zugestellt wurde.

**Wichtig:** `/counsel:abwehr` sollte idealerweise in einer **separaten Konversation** ausgeführt werden, um Kontextkontamination zu vermeiden. Die Informationsbarriere ist prompt-basiert — in derselben Session wie `/counsel:anspruch` kann sie nicht zuverlässig gewährleistet werden.

### Benennungskonvention Briefe

Alle Briefe liegen in `data/` und tragen den Absender im Namen:

| Datei | Absender | Beschreibung |
|---|---|---|
| `BRIEF_ANWALT_1.md` | Dein Anwalt | Erstes Forderungsschreiben |
| `BRIEF_GEGENSEITE_1.md` | Gegenanwalt | Erste Erwiderung |
| `BRIEF_ANWALT_2.md` | Dein Anwalt | Replik |
| `BRIEF_GEGENSEITE_2.md` | Gegenanwalt | Duplik |

Gleicher Dateiname in beiden Ordnern — beim Zustellen wird nichts umbenannt.

## Ablauf

```
1. /counsel:anspruch ausführen
   ├── Rechtsgebiet und Sachlage per Q&A erheben → SACHLAGE.md (vertraulich in anwalt/)
   ├── Belege in anwalt/data/ analysieren (inkl. AGB-Kontrolle)
   ├── Rechtliche Analyse mit Webrecherche (4 parallele Subagenten)
   │   ├── Subagent 1: Gesetzesrecherche
   │   ├── Subagent 2: Urteilsrecherche
   │   ├── Subagent 3: Gegenrecherche (eigene Schwachstellen)
   │   └── Subagent 4: Validierung
   ├── Nachfragen per Q&A klären
   ├── Schadensreflexion: Jeden Satz auf Schadenspotenzial prüfen
   ├── BRIEF_ANWALT_1.md in anwalt/data/ erstellen
   ├── Kopie nach gegenseite/data/ zustellen
   └── Mandantenbericht: Erfolgseinschätzung + Kostenrisiko

2. /counsel:abwehr ausführen (NEUE SESSION empfohlen)
   ├── BRIEF_ANWALT_1.md in gegenseite/data/ lesen
   ├── Schwachstellenanalyse (4 parallele Subagenten)
   │   ├── Subagent 1: Gegnerische Paragraphen verifizieren
   │   ├── Subagent 2: Gegenurteile recherchieren
   │   ├── Subagent 3: Eigene Verteidigungsrecherche
   │   └── Subagent 4: Eigenvalidierung
   ├── Verteidigungsstrategie (6 Stufen: Prozesshindernisse → Primär → Hilfs → Gegen → Taktik → Vollstreckungsabwehr)
   ├── Nachfragen per Q&A (aus Gegenseiten-Perspektive, inkl. Wahrheitspflicht-Check)
   ├── Strategiewahl: Zurückweisung / Teilanerkenntnis / Vergleich
   ├── BRIEF_GEGENSEITE_1.md in gegenseite/data/ erstellen
   ├── Kopie nach anwalt/data/ zustellen
   └── Mandantenbericht: Abwehrchancen + Empfehlung

3. /counsel:anspruch erneut ausführen
   ├── BRIEF_GEGENSEITE_1.md lesen und analysieren
   ├── SACHLAGE.md aktualisieren
   ├── BRIEF_ANWALT_2.md erstellen (Eskalationsstufe situativ)
   └── Kopie nach gegenseite/data/ zustellen

4. Wiederholen bis Ergebnis zufriedenstellend.
```

## Phasenübersicht

### /counsel:anspruch (9 Phasen)

| Phase | Inhalt |
|-------|--------|
| 1 | **Sachlage aufnehmen** — Rechtsgebiet, Fakten, SACHLAGE.md erstellen/aktualisieren, neue Gegenbriefe erkennen |
| 2 | **Aktenanalyse** — Belege lesen, AGB-Kontrolle, Widerklage-Handling |
| 3 | **Rechtliche Analyse** — 9 Prüfpunkte: Anspruchsgrundlagen, Voraussetzungen, Einwendungen/Aufrechnung, Beweislage, Verjährung/Hemmung, Risikobewertung, Strategie/Stufenklage/Teilklage, Nebenforderungen, Sicherungsmaßnahmen |
| 4 | **Fragenkatalog (Q&A)** — Gezielte Nachfragen, Sachlage ergänzen |
| 5 | **Brief erstellen** — Situative Eskalation, Nebenforderungen, Zugangsnachweis, Nötigungsgrenze beachten, Schadensreflexion (7-Punkte-Checklist) |
| 5b | **Codex-Prüfung** (optional) — Adversarielle Briefanalyse durch unabhängiges Modell, Schwachstellen vor Zustellung aufdecken |
| 6 | **Zustellung** — Kopie nach gegenseite/data/ |
| 7 | **Mandantenbericht** — Erfolgsaussichten, Durchsetzbarkeit, Beweislage, Kostenrisiko, Empfehlung |
| 7b | **Codex-Zweitmeinung** (optional) — Unabhängige Bewertung der Erfolgseinschätzung durch zweites Modell |

### /counsel:abwehr (10 Phasen, davon 5b + 5c optional)

| Phase | Inhalt |
|-------|--------|
| 1 | **Eingangsanalyse** — Briefe lesen, Konsistenzprüfung, Bestandsaufnahme |
| 2 | **Schwachstellenanalyse** — Prozessuale Einreden, Formelle Prüfung/Verzug, Materielle Prüfung (Anfechtung, Unmöglichkeit, § 313, § 242, AGB-Kontrolle, Aufrechnung, Mitverschulden), Beweislastanalyse, Gegnerische Urteile prüfen |
| 3 | **Verteidigungsstrategie** — 6 Stufen: Prozesshindernisse, Primärverteidigung, Hilfsverteidigung, Gegenansprüche/Widerklage, Prozesstaktik/Streitverkündung/Schlichtung, Vollstreckungsabwehr |
| 4 | **Fragenkatalog (Q&A)** — Gegenseiten-Perspektive, Wahrheitspflicht-Check (§ 138 ZPO) |
| 5 | **Erwiderungsschreiben** — Strategiewahl (Zurückweisung/Teilanerkenntnis/Vergleich), Schadensreflexion |
| 5b | **Vergleichsangebot** (optional) — Ohne-Präjudiz, Erledigungsklausel |
| 5c | **Codex-Prüfung** (optional) — Adversarielle Briefanalyse durch unabhängiges Modell, Schwachstellen vor Zustellung aufdecken |
| 6 | **Zustellung** — Kopie nach anwalt/data/ |
| 7 | **Mandantenbericht** — Abwehrchancen, Stärke der Gegenseite, Empfehlung |
| 7b | **Codex-Zweitmeinung** (optional) — Unabhängige Bewertung der Abwehreinschätzung durch zweites Modell |

## Prozesstaktik

### Anwalt — Angriffsstrategie

- **Informationsökonomie** — Nur das Nötigste preisgeben. Jeder Satz auf Schadenspotenzial prüfen.
- **Stufenweise Argumentation** — Nicht alles auf einmal. Stärkste Argumente erst einsetzen, wenn Gegenseite ihre Verteidigung offenlegt.
- **Selbstbewusst auftreten** — Anspruch als Selbstverständlichkeit, nie als Meinung. Keine Rechtfertigung.
- **Informationskontrolle** — Gegenseite zum Reden bringen, nicht selbst offenlegen.
- **Wahrheitspflicht** — Grenze: § 138 ZPO. Tatsachen wahr, rechtliche Einordnung bestimmt.
- **Nötigungsgrenze** — § 240 StGB beachten. Nur sachlich zusammenhängende Konsequenzen androhen.

### Gegenanwalt — Verteidigungsstrategie

- **Pauschal bestreiten** — Substanziierungslast beim Gegner lassen. Wahrheitspflicht beachten (§ 138 ZPO).
- **Eigene Karten verdeckt halten** — Nicht alle Einreden sofort ausspielen.
- **Formfehler sofort rügen** — Prozessuale Einreden zuerst. Können materiellen Anspruch komplett blockieren.
- **Gegenseite zur Offenlegung zwingen** — Widersprüche aufdecken.
- **Standesrecht beachten** — § 43a BRAO, § 1 BORA. Konsequent, aber sachlich.

## Subagenten-Architektur

Beide Skills setzen **4 parallele Subagenten** (Agent tool) für die Recherchephasen ein:

### /counsel:anspruch

| Subagent | Aufgabe | Ergebnis |
|----------|---------|----------|
| 1 — Gesetzesrecherche | Alle Paragraphen im Volltext nachschlagen | Tabelle: Paragraph, Wortlaut, Gültigkeit |
| 2 — Urteilsrecherche | BGH-/OLG-Urteile zu jeder Anspruchsgrundlage | Gericht, Az., Datum, Leitsatz, Relevanz |
| 3 — Gegenrecherche | Urteile/Meinungen GEGEN eigene Position | Schwachstellenanalyse |
| 4 — Validierung | Alle Zitate unabhängig prüfen | Validierungstabelle |

### /counsel:abwehr

| Subagent | Aufgabe | Ergebnis |
|----------|---------|----------|
| 1 — Gegner-Verifikation | Gegnerische Paragraphen im Volltext prüfen | Validierungstabelle mit Schwachstellen |
| 2 — Gegenurteile | Urteile gegen den gegnerischen Anspruch | Gericht, Az., Kernaussage |
| 3 — Verteidigungsrecherche | Urteile/Meinungen für Einreden | Argumentationsstützen |
| 4 — Eigenvalidierung | Eigene Zitate unabhängig prüfen | Validierungstabelle |

## Ordnerstruktur

```
counsel/
├── CLAUDE.md                           ← Diese Datei
├── anwalt/                             ← VERTRAULICH — Deine Seite
│   ├── SACHLAGE.md                     ← (generiert) Deine vollständige Sachlage
│   └── data/                           ← Deine Akte
│       ├── vertrag.pdf                 ← Beispiel: Dein Vertrag
│       ├── email-verlauf.pdf           ← Beispiel: Korrespondenz
│       ├── BRIEF_ANWALT_1.md           ← (generiert) Dein erstes Schreiben
│       ├── BRIEF_GEGENSEITE_1.md       ← (zugestellt) Erwiderung der Gegenseite
│       └── BRIEF_ANWALT_2.md           ← (generiert) Deine Replik
├── gegenseite/                         ← Gegenseite — Nur formelle Zustellungen
│   └── data/                           ← Akte der Gegenseite
│       ├── BRIEF_ANWALT_1.md           ← (zugestellt) Kopie deines Schreibens
│       ├── BRIEF_GEGENSEITE_1.md       ← (generiert) Erwiderung
│       └── BRIEF_ANWALT_2.md           ← (zugestellt) Kopie deiner Replik
└── skills/
    ├── anspruch/
    │   └── SKILL.md                    ← /counsel:anspruch — Dein Anwalt
    └── abwehr/
        └── SKILL.md                    ← /counsel:abwehr — Gegenanwalt (Simulation)
```

## Nutzung

### Erstmaliger Start

```
/counsel:anspruch
```

Der Skill fragt per Q&A nach Rechtsgebiet und Sachlage. Die Sachlage wird als `SACHLAGE.md` gesichert. Bei Folgeaufrufen wird sie wiederverwendet.

### Belege bereitstellen

PDFs, E-Mails, Screenshots und andere Dokumente in `anwalt/data/` ablegen. Der Skill liest alle Dateien automatisch.

### Gegenseite simulieren

```
/counsel:abwehr
```

In einer **neuen Session** starten. Liest nur `gegenseite/data/` und stellt Nachfragen aus Gegenseiten-Perspektive.

### Schriftwechsel fortsetzen

`/counsel:anspruch` bzw. `/counsel:abwehr` abwechselnd aufrufen. Jeder Skill erkennt automatisch vorhandene Briefe und knüpft an.

## Qualitätssicherung

Beide Skills sind verpflichtet:

- **Jeden Paragraphen online nachzuschlagen** (dejure.org, gesetze-im-internet.de, buzer.de)
- **Einschlägige Urteile zu recherchieren** (BGH, OLG, LG, BAG via openjur.de, dejure.org)
- **Keine Aktenzeichen oder Urteile zu erfinden** — offen sagen, wenn nichts gefunden
- **4 parallele Subagenten** für gründliche, unabhängige Recherche einzusetzen
- **Nach jeder Phase eine Validierungstabelle** zu erstellen
- **Wahrheitspflicht** (§ 138 ZPO) und **Standesrecht** (§ 43a BRAO) zu beachten
- **Jeden Brief auf Schadenspotenzial** zu prüfen vor Zustellung

## Cross-Model-Validierung (Codex)

Beide Skills unterstützen optional eine zusätzliche Validierungsschicht durch [OpenAI Codex CLI](https://github.com/openai/codex). Falls installiert, wird jeder Brief und jeder Mandantenbericht automatisch durch ein unabhängiges Modell geprüft:

- **Phase 5b/5c:** Codex liest den fertigen Brief als gegnerischer Fachanwalt und identifiziert juristische Schwachstellen, falsch angewandte Paragraphen und taktische Fehler.
- **Phase 7b:** Codex bewertet den Mandantenbericht als unabhängiger Rechtsgutachter — ist die Risikoeinschätzung realistisch? Werden Risiken unterschätzt?

Codex läuft im Read-only-Modus und sieht nur den formellen Brief bzw. den Schriftwechsel — die Informationsbarriere bleibt intakt.

### Installation

```
npm install -g @openai/codex
```

Falls Codex nicht installiert ist, wird der Nutzer informiert und der Ablauf läuft ohne Codex weiter.

## Hinweis

Dieses System ersetzt keine Rechtsberatung i.S.d. § 2 RDG. Es dient der **Vorbereitung und Selbsteinschätzung** vor dem Gang zum echten Anwalt. Generierte Schreiben dürfen nicht ohne Prüfung durch einen zugelassenen Rechtsanwalt versendet werden.
