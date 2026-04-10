# counsel

A Claude Code plugin that simulates a full adversarial legal exchange between two opposing attorneys — so you can stress-test your legal position before spending money on the real thing.

## What it does

Two independent AI skills act as opposing lawyers, communicating exclusively through formal letters — just like in real life:

- **`/counsel:anspruch`** — Your attorney. Gathers the facts, analyzes your legal position, drafts a demand letter.
- **`/counsel:abwehr`** — The opposing attorney. Receives only your lawyer's letter and systematically tears it apart. Has no access to your internal strategy.

Both sides actively research statutes, court rulings, and legal commentary online. Every cited paragraph is verified — nothing from memory.

A strict information barrier ensures the opposing side only knows what was formally served, just like attorney-client privilege in the real world.

## Why this exists

Going to a lawyer cold is expensive. Going to a lawyer *prepared* is smart.

**counsel** lets you:
- Sharpen your arguments before the first billable hour starts
- Discover weak spots in your position that you hadn't considered
- Understand what the other side will likely throw at you
- Walk into your lawyer's office with a clear, structured case

## What this is NOT

This is a first line of defense, not a replacement for an actual lawyer. Here's why:

- **Lawyers have professional liability insurance (Berufshaftpflicht).** If they mess up, you're covered. An LLM gives you a confident-sounding paragraph and wishes you good luck.
- **Lawyers can act on your behalf.** They sign documents, file motions, represent you in court, negotiate settlements. An LLM can draft a strongly worded letter and then watch from the sidelines.
- **Lawyers are officers of the court.** Their statements carry legal weight. An LLM's output carries the legal weight of a sticky note.
- **Lawyers understand context, nuance, and your specific jurisdiction.** An LLM understands tokens.

Use **counsel** to prepare. Use a real lawyer to execute.

## Usage

### Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI or Desktop App
- This plugin installed (clone the repo, Claude Code discovers it automatically)

### Quick start

```
/counsel:anspruch      # Start: your attorney gathers facts and drafts the first letter
/counsel:abwehr        # Opposing counsel responds
/counsel:anspruch      # Your attorney replies — and so on
```

Alternate between the two until you're satisfied with the exchange. Drop supporting documents (PDFs, emails, screenshots) into `anwalt/data/` and they'll be picked up automatically.

### Supported legal areas

Flexible — contract law, tenancy law, employment law, IT law, and more. The skill asks you at the start.

## How it works

```
You ──▶ /counsel:anspruch ──▶ Demand letter ──▶ served to opposing side
                                                        │
                                          /counsel:abwehr ◀──┘
                                                  │
                                          Rebuttal letter ──▶ served back
                                                                  │
                                            /counsel:anspruch ◀───┘
                                                    │
                                              ... and so on
```

Each round produces formal letters stored in `anwalt/data/` and `gegenseite/data/`. The information barrier is enforced structurally — the opposing attorney skill literally cannot read your confidential files.

## License

This project does not constitute legal advice within the meaning of the German Legal Services Act (RDG). It is a preparation and self-assessment tool.
