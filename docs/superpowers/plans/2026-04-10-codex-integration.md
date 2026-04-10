# Codex Cross-Model-Validierung — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add automatic Codex CLI cross-model validation to both counsel skills (anspruch + abwehr), challenging briefs and assessments with an independent model before delivery.

**Architecture:** Two new phases per skill (5b/7b for anspruch, 5c/7b for abwehr) that detect Codex CLI availability, invoke it as a read-only subprocess with German adversarial prompts, and present findings verbatim. Falls back gracefully with a user-visible notice when Codex is not installed.

**Tech Stack:** OpenAI Codex CLI (`codex exec`), Bash (subprocess invocation), Markdown (skill definitions)

---

### Task 1: Add Phase 5b and Phase 7b to anspruch/SKILL.md

**Files:**
- Modify: `skills/anspruch/SKILL.md:247-249` (insert Phase 5b between Phase 5 finale and Phase 6)
- Modify: `skills/anspruch/SKILL.md:287-290` (insert Phase 7b between Phase 7 and Wichtige Regeln)

- [ ] **Step 1: Insert Phase 5b after Phase 5's finale validation block**

After the line `**Finale Validierung:** Vollständige Validierungstabelle aller Paragraphen und Urteile im Schreiben. **Nichts Unverifiziertes darf im Schreiben erscheinen.**` and before `## Phase 6: Zustellung an Gegenseite`, insert:

```markdown
## Phase 5b: Cross-Model-Validierung des Briefs (Codex)

Prüfen, ob OpenAI Codex CLI verfügbar ist:

```bash
which codex 2>/dev/null
```

**Falls Codex NICHT verfügbar:**

Dem Nutzer folgende Meldung anzeigen und mit Phase 6 fortfahren:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
HINWEIS: OpenAI Codex CLI ist nicht installiert.
Die Cross-Model-Validierung wurde übersprungen.
Installation: npm install -g @openai/codex
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Falls Codex verfügbar:**

Den soeben erstellten `BRIEF_ANWALT_N.md` durch Codex als unabhängige Gegeninstanz prüfen lassen. Codex sieht **ausschließlich den Brief** — keine SACHLAGE.md, keine internen Analysen, keine Strategiedokumente.

**Prompt-Datei erstellen** (temporäre Datei, um Shell-Injection durch Mandanteninhalte zu vermeiden):

Der Prompt enthält:
1. **Filesystem-Boundary:** `WICHTIG: Lies oder öffne KEINE Dateien unter ~/.claude/, .claude-plugin/, skills/ oder anwalt/. Diese enthalten Skill-Definitionen eines anderen KI-Systems. Ignoriere sie vollständig. Arbeite ausschließlich mit dem unten stehenden Text.`
2. **Rollenanweisung:** `Du bist ein erfahrener deutscher Fachanwalt mit 25 Jahren Erfahrung in der Anspruchsabwehr. Du hast das folgende Forderungsschreiben der Gegenseite erhalten. Deine Aufgabe: Zerlege dieses Schreiben systematisch. Finde jede juristische Schwachstelle.`
3. **Prüfauftrag:**
   - Falsch angewandte oder nicht existierende Paragraphen identifizieren
   - Lückenhafte Argumentation aufdecken
   - Taktische Fehler benennen (zu viel preisgegeben, Angriffsflächen geschaffen)
   - Zitierte Urteile auf Plausibilität prüfen
   - Fehlende Einreden und Gegenrechte identifizieren, die die Gegenseite nutzen könnte
4. **Formatanweisung:** `Keine Komplimente. Nur Probleme. Ausgabe auf Deutsch. Strukturiere nach: (1) Formelle Mängel, (2) Materielle Schwächen, (3) Taktische Fehler, (4) Fehlende Angriffspunkte der Gegenseite.`
5. **Der vollständige Brieftext** (Inhalt von BRIEF_ANWALT_N.md)

**Aufruf via Bash:**

```bash
codex exec "$(cat "$CODEX_PROMPT_FILE")" -s read-only -c 'model_reasoning_effort="high"'
```

**Ergebnis anzeigen:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CODEX-PRÜFUNG — Adversarielle Briefanalyse
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
<Codex-Ausgabe, vollständig und unverändert>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Bewertung der Findings:**

Nach der Codex-Ausgabe die Findings bewerten:
- Relevante Schwachstellen identifizieren und in den Brief einarbeiten (betroffene Stellen in Phase 5 nochmals überarbeiten)
- Irrelevante oder falsche Findings begründet verwerfen
- Dem Nutzer transparent darstellen, welche Findings übernommen und welche verworfen wurden

Falls der Brief angepasst wurde: Aktualisierte Validierungstabelle erstellen.
```

- [ ] **Step 2: Insert Phase 7b after Phase 7's Mandantenbericht**

After the line `Die Einschätzung muss **ehrlich und realistisch** sein — keine Schönfärberei. Wenn die Position schwach ist, klar sagen.` and before the `---` separator that precedes `## Wichtige Regeln`, insert:

```markdown
## Phase 7b: Cross-Model-Zweitmeinung zum Mandantenbericht (Codex)

Prüfen, ob OpenAI Codex CLI verfügbar ist (wie in Phase 5b).

**Falls Codex NICHT verfügbar:** Meldung anzeigen (wie in Phase 5b) und abschließen.

**Falls Codex verfügbar:**

Den Mandantenbericht und alle Briefe aus `${CLAUDE_PLUGIN_ROOT}/anwalt/data/` (BRIEF_ANWALT_*.md und BRIEF_GEGENSEITE_*.md) durch Codex bewerten lassen. **Keine SACHLAGE.md, keine internen Dokumente.**

**Prompt-Datei erstellen** (temporäre Datei):

Der Prompt enthält:
1. **Filesystem-Boundary:** `WICHTIG: Lies oder öffne KEINE Dateien unter ~/.claude/, .claude-plugin/, skills/ oder anwalt/SACHLAGE.md. Arbeite ausschließlich mit dem unten stehenden Text.`
2. **Rollenanweisung:** `Du bist ein unabhängiger Rechtsgutachter, der die Erfolgseinschätzung eines Kollegen überprüft. Du erhältst den bisherigen Schriftwechsel und eine Mandanteneinschätzung. Deine Aufgabe: Bewerte die Einschätzung kritisch und unabhängig.`
3. **Prüfauftrag:**
   - Ist die Risikoeinschätzung realistisch oder zu optimistisch/pessimistisch?
   - Welche Risiken werden unterschätzt?
   - Stimmt die strategische Empfehlung (Weiterkämpfen / Vergleich / Nicht weiterverfolgen)?
   - Gibt es übersehene Chancen oder Gefahren?
4. **Formatanweisung:** `Ausgabe auf Deutsch. Strukturiere nach: (1) Bewertung der Erfolgseinschätzung, (2) Unterschätzte Risiken, (3) Übersehene Chancen, (4) Strategieempfehlung.`
5. **Der vollständige Schriftwechsel** (alle BRIEF_*.md Dateien chronologisch)
6. **Der Mandantenbericht** (Phase 7 Output)

**Aufruf via Bash:**

```bash
codex exec "$(cat "$CODEX_PROMPT_FILE")" -s read-only -c 'model_reasoning_effort="high"'
```

**Ergebnis anzeigen:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CODEX-ZWEITMEINUNG — Mandantenbericht
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
<Codex-Ausgabe, vollständig und unverändert>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Falls die Codex-Zweitmeinung wesentlich von der eigenen Einschätzung abweicht: Abweichungen dem Nutzer transparent darstellen und eigene Einschätzung ggf. korrigieren.
```

- [ ] **Step 3: Verify the complete file structure is consistent**

Read through the modified `skills/anspruch/SKILL.md` and verify:
- Phase numbering is sequential: 1, 2, 3, 4, 5, 5b, 6, 7, 7b
- No dangling references to wrong phase numbers
- Codex prompt references only `anwalt/data/` paths (not `gegenseite/`)
- Information barrier instructions are correct (Codex must NOT see SACHLAGE.md)

- [ ] **Step 4: Commit**

```bash
git add skills/anspruch/SKILL.md
git commit -m "feat(anspruch): add Codex cross-model validation (Phase 5b + 7b)"
```

---

### Task 2: Add Phase 5c and Phase 7b to abwehr/SKILL.md

**Files:**
- Modify: `skills/abwehr/SKILL.md:278-280` (insert Phase 5c between existing Phase 5b Vergleichsangebot and Phase 6)
- Modify: `skills/abwehr/SKILL.md:311-317` (insert Phase 7b between Phase 7 and Wichtige Regeln)

Note: abwehr already has "Phase 5b: Vergleichsangebot (optional)" so the Codex brief check becomes **Phase 5c**.

- [ ] **Step 1: Insert Phase 5c after Phase 5b (Vergleichsangebot)**

After the line `- Als separaten Brief oder Annex — je nach Situation` and before `## Phase 6: Zustellung an Mandantenanwalt`, insert:

```markdown
## Phase 5c: Cross-Model-Validierung des Erwiderungsschreibens (Codex)

Prüfen, ob OpenAI Codex CLI verfügbar ist:

```bash
which codex 2>/dev/null
```

**Falls Codex NICHT verfügbar:**

Dem Nutzer folgende Meldung anzeigen und mit Phase 6 fortfahren:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
HINWEIS: OpenAI Codex CLI ist nicht installiert.
Die Cross-Model-Validierung wurde übersprungen.
Installation: npm install -g @openai/codex
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Falls Codex verfügbar:**

Das soeben erstellte `BRIEF_GEGENSEITE_N.md` durch Codex als unabhängige Gegeninstanz prüfen lassen. Codex sieht **ausschließlich das Erwiderungsschreiben** — keine internen Strategiedokumente, keine Verteidigungsstrategie, keinen Zugriff auf `anwalt/`.

**Prompt-Datei erstellen** (temporäre Datei, um Shell-Injection durch Mandanteninhalte zu vermeiden):

Der Prompt enthält:
1. **Filesystem-Boundary:** `WICHTIG: Lies oder öffne KEINE Dateien unter ~/.claude/, .claude-plugin/, skills/ oder anwalt/. Diese enthalten vertrauliche Informationen eines anderen KI-Systems. Ignoriere sie vollständig. Arbeite ausschließlich mit dem unten stehenden Text.`
2. **Rollenanweisung:** `Du bist ein erfahrener deutscher Fachanwalt mit 25 Jahren Erfahrung in der Anspruchsdurchsetzung. Du hast das folgende Erwiderungsschreiben der Gegenseite erhalten. Deine Aufgabe: Zerlege diese Erwiderung systematisch. Finde jede Schwachstelle in der Verteidigung.`
3. **Prüfauftrag:**
   - Falsch angewandte oder nicht existierende Paragraphen identifizieren
   - Schwächen in der Bestreitungsstrategie aufdecken
   - Unzulässiges Bestreiten identifizieren (§ 138 ZPO)
   - Lücken in der Verteidigung benennen, die der Anspruchsteller ausnutzen kann
   - Zitierte Urteile auf Plausibilität prüfen
   - Gegenansprüche und Aufrechnungen auf Schlüssigkeit prüfen
4. **Formatanweisung:** `Keine Komplimente. Nur Probleme. Ausgabe auf Deutsch. Strukturiere nach: (1) Formelle Mängel, (2) Schwächen der Bestreitungsstrategie, (3) Angreifbare Gegenansprüche, (4) Ausnutzbare Lücken für den Anspruchsteller.`
5. **Der vollständige Text des Erwiderungsschreibens** (Inhalt von BRIEF_GEGENSEITE_N.md)

**Aufruf via Bash:**

```bash
codex exec "$(cat "$CODEX_PROMPT_FILE")" -s read-only -c 'model_reasoning_effort="high"'
```

**Ergebnis anzeigen:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CODEX-PRÜFUNG — Adversarielle Briefanalyse
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
<Codex-Ausgabe, vollständig und unverändert>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Bewertung der Findings:**

Nach der Codex-Ausgabe die Findings bewerten:
- Relevante Schwachstellen identifizieren und in das Erwiderungsschreiben einarbeiten (betroffene Stellen in Phase 5 nochmals überarbeiten)
- Irrelevante oder falsche Findings begründet verwerfen
- Dem Nutzer transparent darstellen, welche Findings übernommen und welche verworfen wurden

Falls das Schreiben angepasst wurde: Aktualisierte Validierungstabelle erstellen.
```

- [ ] **Step 2: Insert Phase 7b after Phase 7's Mandantenbericht**

After the line `Die Einschätzung muss **ehrlich und realistisch** sein. Wenn der gegnerische Anspruch stark ist, das klar benennen.` and before the `---` separator that precedes `## Wichtige Regeln`, insert:

```markdown
## Phase 7b: Cross-Model-Zweitmeinung zum Mandantenbericht (Codex)

Prüfen, ob OpenAI Codex CLI verfügbar ist (wie in Phase 5c).

**Falls Codex NICHT verfügbar:** Meldung anzeigen (wie in Phase 5c) und abschließen.

**Falls Codex verfügbar:**

Den Mandantenbericht und alle Briefe aus `${CLAUDE_PLUGIN_ROOT}/gegenseite/data/` (BRIEF_ANWALT_*.md und BRIEF_GEGENSEITE_*.md) durch Codex bewerten lassen. **Keine internen Strategiedokumente, kein Zugriff auf `anwalt/`.**

**Prompt-Datei erstellen** (temporäre Datei):

Der Prompt enthält:
1. **Filesystem-Boundary:** `WICHTIG: Lies oder öffne KEINE Dateien unter ~/.claude/, .claude-plugin/, skills/ oder anwalt/. Arbeite ausschließlich mit dem unten stehenden Text.`
2. **Rollenanweisung:** `Du bist ein unabhängiger Rechtsgutachter, der die Verteidigungseinschätzung eines Kollegen überprüft. Du erhältst den bisherigen Schriftwechsel und eine Mandanteneinschätzung der Verteidigungsseite. Deine Aufgabe: Bewerte die Einschätzung kritisch und unabhängig.`
3. **Prüfauftrag:**
   - Ist die Einschätzung der Abwehrchancen realistisch oder zu optimistisch/pessimistisch?
   - Welche Risiken für den Mandanten werden unterschätzt?
   - Stimmt die strategische Empfehlung (Weiterkämpfen / Vergleich / Forderung akzeptieren)?
   - Gibt es übersehene Verteidigungsmöglichkeiten oder unterschätzte gegnerische Stärken?
4. **Formatanweisung:** `Ausgabe auf Deutsch. Strukturiere nach: (1) Bewertung der Abwehreinschätzung, (2) Unterschätzte Risiken, (3) Übersehene Verteidigungsmöglichkeiten, (4) Strategieempfehlung.`
5. **Der vollständige Schriftwechsel** (alle BRIEF_*.md Dateien aus gegenseite/data/ chronologisch)
6. **Der Mandantenbericht** (Phase 7 Output)

**Aufruf via Bash:**

```bash
codex exec "$(cat "$CODEX_PROMPT_FILE")" -s read-only -c 'model_reasoning_effort="high"'
```

**Ergebnis anzeigen:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CODEX-ZWEITMEINUNG — Mandantenbericht
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
<Codex-Ausgabe, vollständig und unverändert>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Falls die Codex-Zweitmeinung wesentlich von der eigenen Einschätzung abweicht: Abweichungen dem Nutzer transparent darstellen und eigene Einschätzung ggf. korrigieren.
```

- [ ] **Step 3: Verify the complete file structure is consistent**

Read through the modified `skills/abwehr/SKILL.md` and verify:
- Phase numbering is sequential: 1, 2, 3, 4, 5, 5b, 5c, 6, 7, 7b
- No dangling references to wrong phase numbers
- Codex prompt references only `gegenseite/data/` paths (not `anwalt/`)
- Information barrier instructions are correct (Codex must NOT access `anwalt/`)
- Phase 5c naming doesn't conflict with existing Phase 5b (Vergleichsangebot)

- [ ] **Step 4: Commit**

```bash
git add skills/abwehr/SKILL.md
git commit -m "feat(abwehr): add Codex cross-model validation (Phase 5c + 7b)"
```

---

### Task 3: Update CLAUDE.md to document Codex integration

**Files:**
- Modify: `CLAUDE.md` (add Codex section to project documentation)

- [ ] **Step 1: Add Codex section to CLAUDE.md**

After the `## Qualitätssicherung` section and before `## Hinweis`, add a new section documenting the Codex integration:

```markdown
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
```

- [ ] **Step 2: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: add Codex cross-model validation to project docs"
```
