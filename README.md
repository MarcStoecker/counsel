# Counsel

Ein Claude Code Plugin, das einen vollständigen kontradiktorischen Schriftwechsel zwischen zwei gegnerischen Fachanwälten simuliert — damit du deine Rechtsposition auf Herz und Nieren prüfen kannst, bevor du Geld beim echten Anwalt lässt.

## Was es macht

Zwei unabhängige KI-Skills agieren als gegnerische Anwälte, die ausschließlich über formelle Briefe miteinander kommunizieren — genau wie in der Realität:

- **`/counsel:anspruch`** — Dein Anwalt. Erhebt die Sachlage, analysiert deine Rechtsposition, erstellt ein Forderungsschreiben.
- **`/counsel:abwehr`** — Der Gegenanwalt. Erhält nur den Brief deines Anwalts und zerlegt ihn systematisch. Kennt deine interne Strategie nicht.

Beide Seiten recherchieren aktiv Gesetzestexte, Urteile und Fachmeinungen im Web. Jeder zitierte Paragraph wird online verifiziert — nichts aus dem Gedächtnis.

Eine strikte Informationsbarriere stellt sicher, dass die Gegenseite nur das kennt, was ihr formal zugestellt wurde — wie beim echten Anwaltsgeheimnis.

## Warum es das gibt

Unvorbereitet zum Anwalt gehen ist teuer. *Vorbereitet* zum Anwalt gehen ist schlau.

**Counsel** ermöglicht dir:
- Argumente schärfen, bevor die erste Stunde abgerechnet wird
- Schwachstellen in der eigenen Position entdecken, an die du nicht gedacht hast
- Verstehen, was die Gegenseite voraussichtlich vorbringt
- Mit einem klaren, strukturierten Fall beim Anwalt aufschlagen

## Was es NICHT ist

Dies ist eine erste Verteidigungslinie, kein Ersatz für einen echten Anwalt. Und zwar deshalb:

- **Anwälte haben eine Berufshaftpflicht.** Wenn sie Mist bauen, bist du abgesichert. Ein LLM liefert dir einen selbstbewusst klingenden Absatz und wünscht dir viel Glück.
- **Anwälte können für dich handeln.** Sie unterschreiben Dokumente, stellen Anträge, vertreten dich vor Gericht, verhandeln Vergleiche. Ein LLM kann einen scharfen Brief entwerfen und dann von der Seitenlinie zusehen.
- **Anwälte sind Organe der Rechtspflege.** Ihre Aussagen haben rechtliches Gewicht. Die Ausgabe eines LLM hat das rechtliche Gewicht eines Post-its.
- **Anwälte verstehen Kontext, Nuancen und deine konkrete Jurisdiktion.** Einem LLM fehlen möglicherweise die Daten, um diese Nuancen zu erkennen.

Nutze **Counsel** zur Vorbereitung. Nutze einen echten Anwalt zur Durchsetzung.

## Nutzung

### Voraussetzungen

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI oder Desktop App
- Dieses Plugin installiert (Repo klonen, Claude Code erkennt es automatisch)

### Schnellstart

```
/counsel:anspruch      # Start: Dein Anwalt erhebt die Sachlage und erstellt den ersten Brief
/counsel:abwehr        # Die Gegenseite antwortet
/counsel:anspruch      # Dein Anwalt repliziert — und so weiter
```

Wechsle zwischen beiden, bis du mit dem Ergebnis zufrieden bist. Belege (PDFs, E-Mails, Screenshots) einfach in `anwalt/data/` ablegen — sie werden automatisch berücksichtigt.

### Unterstützte Rechtsgebiete

Flexibel wählbar — Vertragsrecht, Mietrecht, Arbeitsrecht, IT-Recht und mehr. Der Skill fragt beim Start danach.

## Wie es funktioniert

```
Du ──▶ /counsel:anspruch ──▶ Forderungsschreiben ──▶ Zustellung an Gegenseite
                                                              │
                                                /counsel:abwehr ◀──┘
                                                        │
                                                Erwiderung ──▶ Zustellung zurück
                                                                        │
                                                  /counsel:anspruch ◀───┘
                                                          │
                                                    ... und so weiter
```

Jede Runde erzeugt formelle Briefe in `anwalt/data/` und `gegenseite/data/`. Die Informationsbarriere wird strukturell durchgesetzt — der Gegenanwalt-Skill kann deine vertraulichen Dateien schlicht nicht lesen.

## Lizenz

Dieses Projekt stellt keine Rechtsberatung im Sinne des Rechtsdienstleistungsgesetzes (RDG) dar. Es dient der Vorbereitung und Selbsteinschätzung.
