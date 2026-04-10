# Recht — Kontradiktorischer Rechtsaustausch

Dieses Projekt simuliert einen vollständigen außergerichtlichen Schriftwechsel zwischen zwei gegnerischen Fachanwälten. Ziel ist es, die eigene Rechtsposition **vor dem Gang zum echten Anwalt** vorzubereiten, zu schärfen und auf Schwachstellen zu testen.

## Konzept

Zwei unabhängige Skills agieren als gegnerische Anwälte, die ausschließlich über formelle Briefe miteinander kommunizieren — genau wie in der Realität:

- **`/counsel:anspruch`** — Dein Anwalt. Erhebt die Sachlage, analysiert deine Rechtsposition, erstellt ein Forderungsschreiben.
- **`/counsel:abwehr`** — Der Gegenanwalt. Erhält nur den Brief deines Anwalts und zerlegt ihn systematisch. Kennt deine interne Strategie nicht.

Beide Skills recherchieren aktiv im Web nach Gesetzestexten, Urteilen und Fachmeinungen. Jeder zitierte Paragraph wird online verifiziert — nichts aus dem Gedächtnis. Das Rechtsgebiet ist flexibel wählbar (Vertragsrecht, Mietrecht, Arbeitsrecht, IT-Recht, etc.).

### Informationsbarriere

Das zentrale Designprinzip ist die **strikte Informationstrennung** — wie beim echten Anwaltsgeheimnis:

| | `/counsel:anspruch` (Anwalt) | `/counsel:abwehr` (Gegenanwalt) |
|---|---|---|
| **Liest** | `anwalt/SACHLAGE.md`, `anwalt/data/*` | `gegenseite/data/*` (nur Briefe + eigene Belege) |
| **Schreibt** | `anwalt/data/BRIEF_ANWALT_N.md` | `gegenseite/data/BRIEF_GEGENSEITE_N.md` |
| **TABU** | — | `anwalt/SACHLAGE.md`, `anwalt/data/*` |

Der Gegenanwalt kennt nur das, was ihm formal zugestellt wurde. Die Sachlage, Strategie und Belege deines Anwalts bleiben vertraulich.

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
   ├── Belege in anwalt/data/ analysieren
   ├── Rechtliche Analyse mit Webrecherche
   ├── Nachfragen per Q&A klären
   ├── BRIEF_ANWALT_1.md in anwalt/data/ erstellen
   └── Kopie nach gegenseite/data/ zustellen

2. /counsel:abwehr ausführen
   ├── BRIEF_ANWALT_1.md in gegenseite/data/ lesen
   ├── Schwachstellenanalyse (formell + materiell)
   ├── Gegnerische Paragraphen und Urteile online prüfen
   ├── Verteidigungsstrategie (4 Stufen)
   ├── Nachfragen per Q&A (aus Gegenseiten-Perspektive)
   ├── BRIEF_GEGENSEITE_1.md in gegenseite/data/ erstellen
   └── Kopie nach anwalt/data/ zustellen

3. /counsel:anspruch erneut ausführen
   ├── BRIEF_GEGENSEITE_1.md lesen und analysieren
   ├── SACHLAGE.md aktualisieren
   ├── BRIEF_ANWALT_2.md erstellen
   └── Kopie nach gegenseite/data/ zustellen

4. Wiederholen bis Ergebnis zufriedenstellend.
```

## Ordnerstruktur

```
counsel/
├── CLAUDE.md                           ← Diese Datei
├── .claude-plugin/
│   └── plugin.json                     ← Plugin "recht"
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

Der Skill fragt per Q&A nach:
- Rechtsgebiet (Vertragsrecht, Mietrecht, Arbeitsrecht, IT-Recht, etc.)
- Sachlage (Parteien, Vertrag, Problem, Ziel)

Die Sachlage wird als `SACHLAGE.md` gesichert. Bei Folgeaufrufen wird sie wiederverwendet.

### Belege bereitstellen

PDFs, E-Mails, Screenshots und andere Dokumente in `anwalt/data/` ablegen. Der Skill liest alle Dateien automatisch.

### Gegenseite simulieren

```
/counsel:abwehr
```

Startet den Gegenanwalt. Dieser liest nur `gegenseite/data/` und stellt Nachfragen aus Gegenseiten-Perspektive.

### Schriftwechsel fortsetzen

Einfach `/counsel:anspruch` bzw. `/counsel:abwehr` abwechselnd aufrufen. Jeder Skill erkennt automatisch vorhandene Briefe und knüpft an.

## Qualitätssicherung

Beide Skills sind verpflichtet:

- **Jeden Paragraphen online nachzuschlagen** (dejure.org, gesetze-im-internet.de, buzer.de)
- **Einschlägige Urteile zu recherchieren** (BGH, OLG, LG, BAG via openjur.de, dejure.org)
- **Nach jeder Phase eine Validierungstabelle** zu erstellen:

| Paragraph | Geprüft | Gültige Fassung | Korrekt angewandt | Anmerkung |
|-----------|---------|-----------------|-------------------|-----------|
| § XXX BGB | Ja/Nein | Ja/Nein         | Ja/Nein           | ...       |

Kein Paragraph und kein Urteil darf in einen Brief aufgenommen werden, das nicht online verifiziert wurde.

## Hinweis

Dieses System ersetzt keine Rechtsberatung i.S.d. RDG. Es dient der **Vorbereitung und Selbsteinschätzung** vor dem Gang zum echten Anwalt.
