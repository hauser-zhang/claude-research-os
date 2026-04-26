<div align="center">

# claude-research-os

**Your research, as an operating system.**

A Claude Code template for researchers who run more than one project.
Three scopes, one cross-project wiki, decisions that survive session resets, batteries-included skills.

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/powered%20by-Claude%20Code-8a63d2)](https://docs.anthropic.com/en/docs/claude-code)
[![Status](https://img.shields.io/badge/status-v1.2%20dogfooding-orange)](CLAUDE.md)

[Architecture](docs/architecture.md) · [Philosophy](docs/philosophy.md) · [ADRs](decisions/) · [Skills catalog](.claude/skills/_catalog.md)

**English | [简体中文](README.zh-CN.md)**

</div>

---

## What is Research OS?

Research OS turns multi-project academic research into a layered operating system on top of Claude Code. It splits rules into three physical scopes (global → framework → per-project), accumulates cross-project knowledge in a wiki that **compounds** instead of scattering, and records every architectural decision as an ADR so the next session — or the next month — can actually pick up where you left off.

It ships **batteries included**: a curated set of skills (some original, some mirrored from the community with full attribution) that `git clone` installs for free.

---

## The Problem

Four things every solo researcher runs into with Claude Code after a few weeks:

> *"Didn't we already decide against this architecture? I can't find where we discussed it. Let me just re-reason from scratch."*

> *"Wait, 'NT-Xent loss' — didn't I already summarise this for the previous paper? Forget it, I'll re-read the GraphCL paper for the third time."*

> *"Ideas are in Feishu. Notes in Notion. Rejected hypotheses in chat scrollback. Nothing is the source of truth."*

> *"I need the SSH conventions from project A. But they're mixed with A's wave-migration state. Copy-paste and hope?"*

Root cause: Claude Code's default single `CLAUDE.md` + flat `.claude/` cannot hold multi-project research.

---

## The Solution

Four design choices, each addressing one of the problems above:

| Choice | Addresses | Where it lives |
|--------|-----------|----------------|
| **Three-scope cascade** — `L1 global / L2 framework / L3 project` `CLAUDE.md` layered load | "Copy-paste and hope" | Repo root + `projects/<name>/` |
| **Dual-Primary knowledge** — timeless facts in `wiki/`, time-ordered process in `tracks/<t>/<thread>/`, bidirectional links | "Already summarised this" | `wiki/` (L2) + `projects/<name>/tracks/` (L3) |
| **Five-stage flow + ADRs + frictions backlog** — every decision and rejected idea leaves a trail | "Didn't we already decide" | `decisions/` + `meta/` + thread `00..04.md` |
| **Batteries-included skills** — `git clone` comes with `own/` + `upstream/` skills (Karpathy guidelines, superpowers brainstorming / TDD / debugging) | "Ideas scattered everywhere" | `.claude/skills/` |

**See [docs/architecture.md](docs/architecture.md) for the detailed architecture** (diagrams, Dual-Primary contract, five-stage flow, self-evolving mechanism).

---

## Quick Start

```bash
# 1. Clone
git clone https://github.com/hauser-zhang/claude-research-os.git
cd claude-research-os

# 2. Start a project at L3 (inherits L2 skeleton automatically)
mkdir -p projects/my-paper/{.claude,tracks}
echo "# My Paper — Project Charter (L3)" > projects/my-paper/CLAUDE.md
echo "# Session Handoff (L3)" > projects/my-paper/.claude/HANDOFF.md

# 3. Tell Claude
#    "Please start by reading projects/my-paper/.claude/HANDOFF.md"
```

Full new-project guide: [`projects/README.md`](projects/README.md).

---

## What ships with this repo

Skills live under `.claude/skills/`, physically split so license and authorship are always visible. Full index in [`.claude/skills/_catalog.md`](.claude/skills/_catalog.md).

| Skill | Source | Trigger |
|-------|--------|---------|
| [code-walkthrough](.claude/skills/own/code-walkthrough/) | **own** · MIT | Explaining diffs / PR review / cross-layer tracing |
| [karpathy-guidelines](.claude/skills/upstream/karpathy-guidelines/) | **upstream** — [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) · MIT | Writing / reviewing / refactoring any code |
| [superpowers-brainstorming](.claude/skills/upstream/superpowers-brainstorming/) | **upstream** — [obra/superpowers](https://github.com/obra/superpowers) · MIT | Any creative work before implementation |
| [superpowers-systematic-debugging](.claude/skills/upstream/superpowers-systematic-debugging/) | **upstream** — [obra/superpowers](https://github.com/obra/superpowers) · MIT | Any bug / test failure / unexpected behavior |
| [superpowers-test-driven-development](.claude/skills/upstream/superpowers-test-driven-development/) | **upstream** — [obra/superpowers](https://github.com/obra/superpowers) · MIT | New features / bugfixes, tests first |

**Every `upstream/` skill ships a `_UPSTREAM.md` with source URL, pinned commit, license, and author attribution.** PRs mirroring new high-quality community skills are welcome — see [ADR-0004](decisions/ADR-0004-learning-sources-and-skills-split.md) for the contract.

---

## Architecture (30 seconds)

| Scope | Where | Holds |
|-------|-------|-------|
| **L1 · Global** | `~/.claude/` | Python / git / testing conventions |
| **L2 · Research OS** | this repo | Skeleton, cross-project wiki, skills, ADRs |
| **L3 · Per-project** | `projects/<name>/` | Project charter, tracks, active threads |

Claude Code's cascading `CLAUDE.md` loader walks the directory tree and layers all three automatically. No glue code.

**For the full diagram and the Dual-Primary / five-stage / self-evolving mechanics → [docs/architecture.md](docs/architecture.md).**

---

## How to know it's working

- **Decisions stop reappearing.** Week 3's Claude doesn't re-propose what Week 1 rejected — it's in an ADR.
- **`wiki_touches:` grows.** A paper's wiki page shows 3, 5, 7 thread references. Knowledge compounding.
- **New project bootstraps in <10 minutes.** Two boilerplate files and the L2 skeleton is inherited.
- **Frictions backlog empties weekly.** 2-minute real-time capture, batched in `/meta-review`.
- **Commits trace to one logical feature.** Sessions end with `git commit + push`.

If the opposite happens — stale wiki, growing backlog, ADRs nobody reads — read [`docs/philosophy.md`](docs/philosophy.md) and reconsider which pieces you're actually using.

---

## Deep dive

| Topic | Where |
|-------|-------|
| Full architecture (diagrams + mechanics) | [docs/architecture.md](docs/architecture.md) |
| Philosophy (LLM bookkeeping / Dual-Primary / Five-stage / Self-Evolving) | [docs/philosophy.md](docs/philosophy.md) |
| Annotated repo layout | [docs/repo-layout.md](docs/repo-layout.md) |
| Three-scope ADR | [decisions/ADR-0001](decisions/ADR-0001-research-os-architecture.md) |
| Tracks + IDEAS inbox ADR | [decisions/ADR-0002](decisions/ADR-0002-tracks-and-ideas-inbox.md) |
| Open-source L2/L3 split ADR | [decisions/ADR-0003](decisions/ADR-0003-open-source-split.md) |
| Learning-sources + skill own/upstream ADR | [decisions/ADR-0004](decisions/ADR-0004-learning-sources-and-skills-split.md) |
| Skill spec (Anthropic 3-layer) | [CLAUDE.md §5](CLAUDE.md) |
| Citation three-step verification | [.claude/rules/research-and-reporting.md](.claude/rules/research-and-reporting.md) |

---

## Inspired by

Research OS stands on the shoulders of these projects. Each one is reused here in a concrete, verifiable way — not as a slogan.

### [![](https://img.shields.io/github/stars/forrestchang/andrej-karpathy-skills?style=social&label=Star)](https://github.com/forrestchang/andrej-karpathy-skills) &nbsp; [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) · MIT

> *A single `CLAUDE.md` file to improve Claude Code behavior, derived from Andrej Karpathy's observations on LLM coding pitfalls.*

Four behavioral principles (Think Before Coding · Simplicity First · Surgical Changes · Goal-Driven Execution) baked into [CLAUDE.md §12](CLAUDE.md) as default session-level behavior, plus full mirror under [`.claude/skills/upstream/karpathy-guidelines/`](.claude/skills/upstream/karpathy-guidelines/) with pinned commit.

### [![](https://img.shields.io/github/stars/obra/superpowers?style=social&label=Star)](https://github.com/obra/superpowers) &nbsp; [obra/superpowers](https://github.com/obra/superpowers) · MIT · by [Jesse Vincent](https://github.com/obra)

> *An agentic skills framework & software development methodology that works.*

Three of its skills (`brainstorming`, `systematic-debugging`, `test-driven-development`) ship in [`.claude/skills/upstream/`](.claude/skills/upstream/) with pinned commits and `_UPSTREAM.md` attribution files.

### [![](https://img.shields.io/badge/ADR-adr.github.io-blue)](https://adr.github.io/) &nbsp; [Architecture Decision Records](https://adr.github.io/)

> *Lightweight, text-based decision records for software architecture.*

The `decisions/ADR-NNNN-<slug>.md` format is taken verbatim from the ADR template (frontmatter + Context / Options / Decision / Rationale / Consequences).

### [![](https://img.shields.io/badge/Anthropic-skill--creator-8a63d2)](https://docs.anthropic.com/en/docs/claude-code) &nbsp; [Anthropic skill-creator convention](https://docs.anthropic.com/en/docs/claude-code)

> *Skills extend Claude with reusable capabilities — packaged as metadata + a SKILL.md narrative + supporting references.*

The three-layer skill spec (trigger description → SKILL.md narrative → `references/` for volatile detail) is the official one.

---

Everything else — three-scope cascade, Dual-Primary, five-stage flow, self-evolving frictions, own/upstream skill split — is this repo's own design.

---

## Not suited for

- **One-off projects that finish in a week.** No cross-session accumulation — plain Cursor / Copilot is enough.
- **Pure application engineering.** Research OS is for hypothesis → validation → interpretation; wiki + threads are overkill for feature dev.
- **Team-first collaboration.** This is **solo + Claude**. External mirrors (Feishu / Notion) are views, not sources of truth.
- **Structured data pipelines.** Snakemake / Airflow have their own philosophies; Research OS is the meta-layer of research *process*.

---

## Status & contributing

**v1.2** · dogfooding since 2026-04 on the maintainer's own multi-month project.

- Issues for architectural ambiguity / missing examples / concrete pain points.
- PRs for skeleton improvements (open an issue first — template changes affect every fork).
- Structural changes: propose a new ADR ([template](decisions/ADR-TEMPLATE.md)).
- Community skill mirrors: follow the license + `_UPSTREAM.md` contract in [ADR-0004](decisions/ADR-0004-learning-sources-and-skills-split.md).

## License

[MIT](LICENSE) © 2026 [Hauser Zhang](https://github.com/hauser-zhang). Upstream skills retain their original licenses — see each skill's `_UPSTREAM.md`.
