# Codex-Integration: Cross-Model-Validierung

## Zusammenfassung

Beide Skills (`/counsel:anspruch` und `/counsel:abwehr`) erhalten zwei neue automatische Phasen, die OpenAI Codex CLI als unabhängige Gegeninstanz einsetzen. Codex läuft read-only im Subprocess, sieht nur den fertigen Brief bzw. den Mandantenbericht (Informationsbarriere bleibt intakt), und liefert eine adversarielle Gegenanalyse auf Deutsch.

Codex ist optional. Wenn nicht installiert, wird der Nutzer informiert und der Ablauf läuft ohne Codex weiter.

## Motivation

Counsel simuliert bereits einen kontradiktorischen Schriftwechsel zwischen zwei KI-Anwälten. Beide laufen aber auf demselben Modell (Claude). Ein zweites, unabhängiges Modell (Codex/OpenAI) deckt blinde Flecken auf, die Claude systematisch übersieht — gleiche Trainingsdaten-Bias, gleiche Reasoning-Schwächen. Cross-Model-Validierung erhöht die Robustheit der Analyse erheblich.

Vorbild: [gstack](https://github.com/garrytan/gstack) nutzt Codex CLI als adversariellen Reviewer für Code. Counsel überträgt dieses Muster auf juristische Argumentation.

## Integration in den bestehenden Ablauf

### anspruch

```
Phase 5:  Brief erstellen (BRIEF_ANWALT_N.md)
Phase 5b: Codex-Prüfung des Briefs (NEU)
          → Claude bewertet Findings, passt Brief ggf. an
Phase 6:  Zustellung an Gegenseite
Phase 7:  Mandantenbericht
Phase 7b: Codex-Zweitmeinung zum Mandantenbericht (NEU)
```

### abwehr

Identisches Muster — Phase 5b nach dem Erwiderungsschreiben, Phase 7b nach dem Mandantenbericht.

## Codex-Erkennung

```bash
which codex 2>/dev/null
```

**Verfügbar:** Phasen 5b und 7b laufen automatisch.

**Nicht verfügbar:** Meldung an den Nutzer:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
HINWEIS: OpenAI Codex CLI ist nicht installiert.
Die Cross-Model-Validierung wurde übersprungen.
Installation: npm install -g @openai/codex
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Keine stille Auslassung — der Nutzer soll wissen, dass eine Validierungsschicht fehlt.

## Phase 5b — Adversarielle Briefanalyse

### Input

Nur der fertige Brief (BRIEF_ANWALT_N.md bzw. BRIEF_GEGENSEITE_N.md). Keine internen Dokumente (SACHLAGE.md, Strategienotizen, etc.).

### Aufruf

```bash
codex exec "$(cat "$CODEX_PROMPT_FILE")" -s read-only -c 'model_reasoning_effort="high"'
```

Der Prompt wird in eine temporäre Datei geschrieben (Shell-Injection-Schutz durch Mandanteninhalte im Brief).

### Prompt (Deutsch)

Der Prompt weist Codex an:

- Den Brief als erfahrener gegnerischer Fachanwalt zu lesen
- Jede juristische Schwachstelle zu identifizieren: falsch angewandte Paragraphen, lückenhafte Argumentation, taktische Fehler, Angriffsflächen
- Zitierte Paragraphen und Urteile auf Plausibilität zu prüfen
- Keine Komplimente — nur Probleme
- Ausgabe auf Deutsch

Filesystem-Boundary-Instruktion im Prompt: Codex darf keine Dateien unter `~/.claude/`, `.claude-plugin/`, `skills/` oder `anwalt/` (bei abwehr) lesen.

### Output

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CODEX-PRÜFUNG — Adversarielle Briefanalyse
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
<Codex-Ausgabe, vollständig und unverändert>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Codex-Output wird immer vollständig und unverändert dargestellt — nie zusammengefasst oder gekürzt.

### Nach der Codex-Ausgabe

Claude bewertet die Findings und entscheidet:
- Relevante Schwachstellen in den Brief einarbeiten (Phase 5 nochmals durchlaufen für betroffene Stellen)
- Irrelevante oder falsche Findings begründet verwerfen
- Dem Nutzer die Entscheidung transparent darstellen

## Phase 7b — Zweitmeinung zum Mandantenbericht

### Input

- Alle Briefe aus dem jeweiligen data-Ordner (BRIEF_ANWALT_*.md und BRIEF_GEGENSEITE_*.md)
- Der Mandantenbericht (Phase 7 Output als Text)
- Keine internen Dokumente

### Prompt (Deutsch)

Codex soll die Erfolgseinschätzung unabhängig bewerten:
- Ist die Risikoeinschätzung realistisch oder zu optimistisch/pessimistisch?
- Welche Risiken werden unterschätzt?
- Stimmt die strategische Empfehlung (Weiterkämpfen / Vergleich / Aufgeben)?
- Ausgabe auf Deutsch

### Output

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CODEX-ZWEITMEINUNG — Mandantenbericht
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
<Codex-Ausgabe, vollständig und unverändert>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Informationsbarriere

Die bestehende Informationsbarriere gilt unverändert auch für Codex:

| Kontext | Codex sieht | Codex sieht NICHT |
|---|---|---|
| Phase 5b in `anspruch` | BRIEF_ANWALT_N.md | SACHLAGE.md, anwalt/data/*, Strategie |
| Phase 5b in `abwehr` | BRIEF_GEGENSEITE_N.md | anwalt/*, gegenseite interne Notizen |
| Phase 7b in `anspruch` | Alle Briefe in anwalt/data/ + Mandantenbericht | SACHLAGE.md, Strategie |
| Phase 7b in `abwehr` | Alle Briefe in gegenseite/data/ + Mandantenbericht | anwalt/*, interne Strategie |

Filesystem-Boundary-Instruktion in jedem Prompt stellt sicher, dass Codex nicht eigenständig auf verbotene Verzeichnisse zugreift.

## Sicherheit

- **Read-only Sandbox:** Codex läuft immer mit `-s read-only` — kann keine Dateien ändern
- **Prompt via Temp-File:** Kein Shell-Injection-Risiko durch Mandanteninhalte
- **Filesystem-Boundary:** Explizite Anweisung im Prompt, keine Skill- oder .claude-Dateien zu lesen
- **Keine neue Abhängigkeit:** Codex ist vollständig optional

## Was sich NICHT ändert

- Der bestehende Ablauf bleibt intakt — Codex-Phasen sind additiv
- Die Informationsbarriere wird nicht aufgeweicht
- Ohne Codex funktioniert alles wie bisher (mit Hinweismeldung)
- Keine Änderungen an plugin.json oder der Ordnerstruktur
- Keine Änderungen an der Zustellungslogik

## Implementierung

Änderungen an genau zwei Dateien:
- `skills/anspruch/SKILL.md` — Phase 5b und Phase 7b einfügen
- `skills/abwehr/SKILL.md` — Phase 5b und Phase 7b einfügen

Die Codex-Logik (Erkennung, Prompt-Erstellung, Aufruf, Output-Formatierung) wird direkt als Skill-Anweisungen formuliert — kein separates Script, keine externe Abhängigkeit.
