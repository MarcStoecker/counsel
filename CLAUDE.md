# Counsel — Kontradiktorischer Rechtsaustausch

Simuliert einen außergerichtlichen Schriftwechsel zwischen zwei gegnerischen Fachanwälten zur Vorbereitung vor dem Gang zum echten Anwalt.

> **RDG-Hinweis:** Keine Rechtsberatung i.S.d. § 2 RDG. Generierte Schreiben **nicht ungeprüft versenden**.

## Skills

- **`/counsel:anspruch`** — Dein Anwalt. Erhebt Sachlage, analysiert, erstellt Forderungsschreiben.
- **`/counsel:abwehr`** — Gegenanwalt. Erhält nur den Brief, zerlegt ihn. Kennt deine Strategie nicht.
- **`/counsel:vertrag`** — Vertragsgestaltung. Erstellt/prüft Verträge mit iterativem 5-Subagenten-Prüfgremium.

Rechtsgebiet flexibel (Vertragsrecht, Mietrecht, Arbeitsrecht, IT-Recht, etc.).

## Informationsbarriere

| | `/counsel:anspruch` | `/counsel:abwehr` | `/counsel:vertrag` |
|---|---|---|---|
| **Liest** | `anwalt/SACHLAGE.md`, `anwalt/data/*` | **nur** `gegenseite/data/*` | `vertrag/SACHLAGE.md`, `vertrag/data/*` |
| **Schreibt** | `anwalt/data/BRIEF_ANWALT_N.md` | `gegenseite/data/BRIEF_GEGENSEITE_N.md` | `vertrag/data/VERTRAG_vN.md` |
| **TABU** | — | `anwalt/` (komplett), `skills/anspruch/` | — |
| **Subagenten sehen** | — | — | **nur** `VERTRAG_vN.md` (kein Kontext) |

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

4. /counsel:vertrag (eigenständig)
   ├── Sachlage erheben → SACHLAGE.md
   ├── Grundlagenrecherche (4 Subagenten parallel) → GRUNDLAGEN.md
   │   ├── Mustervertragsrecherche (IHK, BMJ, Anwaltsverlage)
   │   ├── Zwingende Gesetzesvorgaben
   │   ├── Standardklauseln und Best Practices
   │   └── Typische Fallstricke und Streitpunkte
   ├── Vertragsentwurf auf Basis der Grundlagensynthese → VERTRAG_v1.md
   ├── Prüfgremium (5 Subagenten parallel, Convergence Loop)
   │   ├── Gegenseiten-Anwalt
   │   ├── AGB-Prüfer
   │   ├── Vollständigkeits-Check
   │   ├── Widerspruchs-Scanner
   │   └── Formvorschriften-Gate
   ├── Konsolidierung → VERTRAG_v2.md → Loop bis CLEAN
   ├── Codex-Prüfung (optional)
   └── Mandantenbericht + Codex-Zweitmeinung (optional)
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

### /counsel:vertrag

| Phase | Inhalt |
|-------|--------|
| 1 | **Sachlage** — Vertragstyp, Parteien, Anforderungen, SACHLAGE.md |
| 2 | **Grundlagenrecherche** — 4 Subagenten parallel: Mustervorlagen, zwingendes Recht, Best Practices, Fallstricke → GRUNDLAGEN.md |
| 3 | **Entwurf** — Auf Basis der Grundlagensynthese, nicht frei formuliert → VERTRAG_v1.md |
| 4 | **Prüfgremium** — 5 Subagenten parallel (Convergence Loop), nur Vertragstext als Input |
| 5 | **Konsolidierung** — Findings einarbeiten → VERTRAG_v(N+1).md, Loop bis CLEAN/Max/Oszillation |
| 6 | **Codex-Prüfung** (optional) — Cross-Model-Validierung des finalen Vertrags |
| 7 | **Mandantenbericht** — Schutzqualität, AGB-Festigkeit, Vollständigkeit, Risiken |
| 7b | **Codex-Zweitmeinung** (optional) — Unabhängige Bewertung |

## Subagenten

Anspruch und Abwehr setzen 4 parallele Subagenten (Agent tool) ein:

| # | Anspruch | Abwehr |
|---|----------|--------|
| 1 | Gesetzesrecherche | Gegnerische Paragraphen verifizieren |
| 2 | Urteilsrecherche | Gegenurteile recherchieren |
| 3 | Gegenrecherche (eigene Schwächen) | Eigene Verteidigungsrecherche |
| 4 | Validierung | Eigenvalidierung |

Vertrag setzt 5 parallele Subagenten im **Convergence Loop** ein:

| # | Subagent | Auftrag |
|---|----------|---------|
| 1 | Gegenseiten-Anwalt | Klauseln gegen den Auftraggeber ausnutzen |
| 2 | AGB-Prüfer | §§ 305-310 BGB Konformität |
| 3 | Vollständigkeits-Check | Fehlende Standardklauseln/Regelungslücken |
| 4 | Widerspruchs-Scanner | Interne Widersprüche und Ambiguitäten |
| 5 | Formvorschriften-Gate | Form, Fristen, Registrierungspflichten |

Jeder Subagent gibt `CLEAN` oder konkrete Neuformulierungen zurück. Frische Instanzen pro Runde. Loop endet bei: alle CLEAN, max 5 Runden, oder Oszillation.

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
├── vertrag/                        ← Vertragsgestaltung
│   ├── SACHLAGE.md                 ← (generiert) Vertragssachlage
│   ├── GRUNDLAGEN.md               ← (generiert) Recherche-Synthese
│   └── data/                       ← Vertragsentwürfe
│       ├── VERTRAG_v1.md
│       ├── VERTRAG_v2.md           ← (nach Prüfgremium)
│       └── VERTRAG_v3.md           ← (final)
├── gegenseite/
│   └── data/                       ← Nur Zustellungen
│       ├── BRIEF_ANWALT_1.md       ← (zugestellt)
│       └── BRIEF_GEGENSEITE_1.md
└── skills/
    ├── anspruch/SKILL.md
    ├── abwehr/SKILL.md
    └── vertrag/SKILL.md
```

## Qualitätssicherung

- Jeden Paragraphen online nachschlagen — nichts aus dem Gedächtnis
- Keine Aktenzeichen oder Urteile erfinden
- Validierungstabelle nach jeder Phase
- Wahrheitspflicht (§ 138 ZPO) und Standesrecht (§ 43a BRAO)
- Schadensreflexion vor jeder Zustellung
- Codex als unabhängige Gegeninstanz (optional)
