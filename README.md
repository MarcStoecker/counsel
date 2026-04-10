# Counsel

Ein Claude Code Plugin, das einen kontradiktorischen Schriftwechsel zwischen zwei gegnerischen Fachanwälten simuliert — damit du deine Rechtsposition auf Herz und Nieren prüfen kannst, bevor du Geld beim echten Anwalt lässt.

## Was es macht

Zwei KI-Skills agieren als gegnerische Anwälte, die ausschließlich über formelle Briefe kommunizieren:

- **`/counsel:anspruch`** — Dein Anwalt. Erhebt die Sachlage, analysiert deine Position, erstellt ein Forderungsschreiben.
- **`/counsel:abwehr`** — Der Gegenanwalt. Erhält nur den Brief deines Anwalts und zerlegt ihn systematisch.

Eine strikte Informationsbarriere stellt sicher, dass die Gegenseite nur kennt, was ihr formal zugestellt wurde — wie beim echten Anwaltsgeheimnis.

### Rechtsgebiete

Flexibel wählbar — Vertragsrecht, Mietrecht, Arbeitsrecht, IT-Recht, Baurecht, Handelsrecht und mehr.

## Schnellstart

```
/counsel:anspruch      # Dein Anwalt erhebt die Sachlage und erstellt den ersten Brief
/counsel:abwehr        # Neue Session starten — Die Gegenseite antwortet
/counsel:anspruch      # Dein Anwalt repliziert — und so weiter
```

Belege (PDFs, E-Mails, Screenshots) in `anwalt/data/` ablegen — werden automatisch berücksichtigt.

## Wie es funktioniert

```
Du ──> /counsel:anspruch ──> BRIEF_ANWALT_1.md ──> Zustellung an Gegenseite
                                                          │
                                            /counsel:abwehr <──┘
                                                    │
                                    BRIEF_GEGENSEITE_1.md ──> Zustellung zurück
                                                                    │
                                              /counsel:anspruch <───┘
                                                      │
                                                ... und so weiter
```

Jede Runde erzeugt Briefe in `anwalt/data/` und `gegenseite/data/`. Gleicher Dateiname auf beiden Seiten — beim Zustellen wird nichts umbenannt.

## Features

- **9-Punkt-Analyse** — Anspruchsgrundlagen, Verjährung, Nebenforderungen, Sicherungsmaßnahmen, Stufenklage, Teilklage, AGB-Kontrolle
- **6-Stufen-Verteidigung** — Prozesshindernisse, Primär, Hilfs, Gegenansprüche/Widerklage, Prozesstaktik, Vollstreckungsabwehr
- **4 parallele Subagenten** pro Skill für Gesetzes-, Urteils- und Gegenrecherche
- **Prozesstaktik** — Informationsökonomie, stufenweise Argumentation, Schadensreflexion
- **Codex-Validierung** (optional) — Cross-Model-Prüfung jedes Briefs und Mandantenberichts
- **Mandantenbericht** — Erfolgseinschätzung mit Kostenrisiko und Handlungsempfehlung nach jeder Runde
- **Wahrheitspflicht** — § 138 ZPO und Standesrecht (§ 43a BRAO) als harte Grenzen

## Was es NICHT ist

- **Kein Ersatz für einen echten Anwalt.** Anwälte haben Berufshaftpflicht, können für dich handeln, sind Organe der Rechtspflege. Ein LLM kann einen scharfen Brief entwerfen und dann von der Seitenlinie zusehen.
- **Keine Rechtsberatung i.S.d. § 2 RDG.** Generierte Schreiben nicht ohne anwaltliche Prüfung versenden.

Nutze Counsel zur Vorbereitung. Nutze einen echten Anwalt zur Durchsetzung.
