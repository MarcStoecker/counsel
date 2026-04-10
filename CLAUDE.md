# Counsel — Kontradiktorischer Rechtsaustausch

Simuliert einen außergerichtlichen Schriftwechsel zwischen zwei gegnerischen Fachanwälten zur Vorbereitung vor dem Gang zum echten Anwalt.

> **RDG-Hinweis:** Keine Rechtsberatung i.S.d. § 2 RDG. Generierte Schreiben **nicht ungeprüft versenden**.

## Skills

- **`/counsel:anspruch`** — Dein Anwalt. Erhebt Sachlage, analysiert, erstellt Forderungsschreiben.
- **`/counsel:abwehr`** — Gegenanwalt. Erhält nur den Brief, zerlegt ihn. Kennt deine Strategie nicht.

Rechtsgebiet flexibel (Vertragsrecht, Mietrecht, Arbeitsrecht, IT-Recht, etc.).

## Informationsbarriere

| | `/counsel:anspruch` | `/counsel:abwehr` |
|---|---|---|
| **Liest** | `anwalt/SACHLAGE.md`, `anwalt/data/*` | **nur** `gegenseite/data/*` |
| **Schreibt** | `anwalt/data/BRIEF_ANWALT_N.md` | `gegenseite/data/BRIEF_GEGENSEITE_N.md` |
| **TABU** | — | `anwalt/` (komplett), `skills/anspruch/` |

`/counsel:abwehr` in **separater Session** ausführen — Informationsbarriere ist prompt-basiert.

## Ablauf

```
1. /counsel:anspruch
   ├── Sachlage erheben → SACHLAGE.md
   ├── Aktenanalyse (AGB-Kontrolle, Widerklage-Check)
   ├── Rechtliche Analyse (4 Subagenten parallel)
   ├── Q&A → Schadensreflexion → BRIEF_ANWALT_1.md
   ├── Codex-Prüfung (optional)
   ├── Zustellung → gegenseite/data/
   └── Mandantenbericht + Codex-Zweitmeinung (optional)

2. /counsel:abwehr (neue Session)
   ├── Eingangsanalyse + Konsistenzprüfung
   ├── Schwachstellenanalyse (4 Subagenten parallel)
   ├── 6-Stufen-Verteidigung
   ├── Q&A (Wahrheitspflicht-Check) → Strategiewahl
   ├── BRIEF_GEGENSEITE_1.md + Codex-Prüfung (optional)
   ├── Zustellung → anwalt/data/
   └── Mandantenbericht + Codex-Zweitmeinung (optional)

3. Wiederholen.
```

## Phasen

### /counsel:anspruch

| Phase | Inhalt |
|-------|--------|
| 1 | **Sachlage** — Rechtsgebiet, Fakten, SACHLAGE.md, neue Gegenbriefe erkennen |
| 2 | **Aktenanalyse** — Belege, AGB-Kontrolle, Widerklage-Handling |
| 3 | **Analyse** — Anspruchsgrundlagen, Anfechtung/Widerruf, Einwendungen/Aufrechnung, Beweislage, Verjährung/Hemmung, Risiko, Strategie (Stufenklage/Teilklage), Nebenforderungen, Sicherungsmaßnahmen |
| 4 | **Q&A** — Nachfragen, SACHLAGE.md ergänzen |
| 5 | **Brief** — Situative Eskalation, Nebenforderungen, Zugangsnachweis, Nötigungsgrenze, 7-Punkte-Schadensreflexion |
| 5b | **Codex-Prüfung** (optional) — Adversarielle Briefanalyse durch unabhängiges Modell |
| 6 | **Zustellung** — Kopie nach gegenseite/data/ |
| 7 | **Mandantenbericht** — Erfolgsaussichten, Kostenrisiko, Empfehlung |
| 7b | **Codex-Zweitmeinung** (optional) — Unabhängige Bewertung der Einschätzung |

### /counsel:abwehr

| Phase | Inhalt |
|-------|--------|
| 1 | **Eingangsanalyse** — Briefe, Konsistenzprüfung, Bestandsaufnahme |
| 2 | **Schwachstellenanalyse** — Prozessuale Einreden, Formelles/Verzug, Materielles (Anfechtung, § 275, § 313, § 242, AGB, Aufrechnung, § 254), Beweislast, gegnerische Urteile |
| 3 | **Verteidigung** — Stufe 0: Prozesshindernisse, 1: Primär, 2: Hilfs, 3: Gegenansprüche/Widerklage, 4: Taktik/Streitverkündung/Schlichtung, 5: Vollstreckungsabwehr |
| 4 | **Q&A** — Gegenseiten-Perspektive, Wahrheitspflicht-Check (§ 138 ZPO) |
| 5 | **Erwiderung** — Strategiewahl (Zurückweisung/Teilanerkenntnis/Vergleich), Schadensreflexion |
| 5b | **Vergleichsangebot** (optional) — Ohne-Präjudiz, Erledigungsklausel |
| 5c | **Codex-Prüfung** (optional) — Adversarielle Briefanalyse |
| 6 | **Zustellung** — Kopie nach anwalt/data/ |
| 7 | **Mandantenbericht** — Abwehrchancen, Empfehlung |
| 7b | **Codex-Zweitmeinung** (optional) — Unabhängige Bewertung |

## Subagenten

Beide Skills setzen 4 parallele Subagenten (Agent tool) ein:

| # | Anspruch | Abwehr |
|---|----------|--------|
| 1 | Gesetzesrecherche | Gegnerische Paragraphen verifizieren |
| 2 | Urteilsrecherche | Gegenurteile recherchieren |
| 3 | Gegenrecherche (eigene Schwächen) | Eigene Verteidigungsrecherche |
| 4 | Validierung | Eigenvalidierung |

## Codex-Integration (optional)

Falls [OpenAI Codex CLI](https://github.com/openai/codex) installiert (`npm install -g @openai/codex`):

- **Phase 5b/5c:** Brief wird als gegnerischer Fachanwalt zerlegt — Schwachstellen vor Zustellung
- **Phase 7b:** Mandantenbericht wird als unabhängiger Gutachter bewertet

Codex läuft read-only und sieht nur den formellen Brief — Informationsbarriere bleibt intakt. Ohne Codex läuft alles normal weiter.

## Ordnerstruktur

```
counsel/
├── CLAUDE.md
├── anwalt/                         ← VERTRAULICH
│   ├── SACHLAGE.md                 ← (generiert) Sachlage
│   └── data/                       ← Akte (Belege + Briefe)
│       ├── BRIEF_ANWALT_1.md
│       ├── BRIEF_GEGENSEITE_1.md   ← (zugestellt)
│       └── BRIEF_ANWALT_2.md
├── gegenseite/
│   └── data/                       ← Nur Zustellungen
│       ├── BRIEF_ANWALT_1.md       ← (zugestellt)
│       └── BRIEF_GEGENSEITE_1.md
└── skills/
    ├── anspruch/SKILL.md
    └── abwehr/SKILL.md
```

## Qualitätssicherung

- Jeden Paragraphen online nachschlagen — nichts aus dem Gedächtnis
- Keine Aktenzeichen oder Urteile erfinden
- Validierungstabelle nach jeder Phase
- Wahrheitspflicht (§ 138 ZPO) und Standesrecht (§ 43a BRAO)
- Schadensreflexion vor jeder Zustellung
- Codex als unabhängige Gegeninstanz (optional)
