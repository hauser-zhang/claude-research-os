<div align="center">

# claude-research-os

**The research OS for the AI-agent era.**

An open-source Claude Code template that turns multi-project research into a layered operating system — so PhD students and researchers can compound knowledge, experience, and decisions across sessions, projects, and years instead of losing them to scrollback.

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/powered%20by-Claude%20Code-8a63d2)](https://docs.anthropic.com/en/docs/claude-code)
[![Status](https://img.shields.io/badge/status-v1.4%20dogfooding-orange)](CLAUDE.md)

[Architecture](docs/architecture.md) · [Philosophy](docs/philosophy.md) · [ADRs](decisions/) · [Skills catalog](.claude/skills/_catalog.md) · [Example project](projects/_example/)

**English | [简体中文](README.zh-CN.md)**

</div>

---

## TL;DR (10 seconds)

1. Claude Code cascades multiple `CLAUDE.md` files by directory depth.
2. This repo arranges them into **L1 global / L2 framework / L3 per-project** scopes, plus a wiki ⇄ threads knowledge split and a five-stage flow.
3. `git clone` + paste one prompt → Claude bootstraps your first project in ~15 min.

> A personal research OS for the individual PhD / researcher — compound your knowledge, decisions, and lessons across years.

---

## What is Research OS?

Research OS turns multi-project academic research into a layered operating system on top of Claude Code.

Working with AI agents every day shifts the bottleneck of a research career. Generating text and code is cheap; **organising what you've decided, learned, and rejected across dozens of sessions is not**. PhD students and researchers who run more than one project end up fighting the same walls — decisions disappear into chat scrollback, literature gets re-read three times, ideas scatter across Feishu / Notion / GitHub issues, and the moment a second project lands, the single `CLAUDE.md` file collapses under its own weight.

`claude-research-os` is a template that fixes this with four layered mechanisms (three-scope cascade, Dual-Primary knowledge, five-stage flow, batteries-included skills) and ships with a working example project so you can bootstrap your own in ~30 minutes with one prompt to Claude.

**Open the box, talk to Claude, run your research.**

---

## The problem

Four walls every solo researcher runs into with Claude Code after a few weeks:

> *"Didn't we already decide against this architecture? I can't find where we discussed it. Let me just re-reason from scratch."*

> *"Wait, 'NT-Xent loss' — didn't I already summarise this for the previous paper? Forget it, I'll re-read the GraphCL paper for the third time."*

> *"Ideas are in Feishu. Notes in Notion. Rejected hypotheses in chat scrollback. Nothing is the source of truth."*

> *"I need the SSH conventions from project A. But they're mixed with A's wave-migration state. Copy-paste and hope?"*

Root cause: Claude Code's default single `CLAUDE.md` + flat `.claude/` cannot hold multi-project research. **Sessions are cheap; cross-session continuity is what's missing.**

---

## Why researchers stay

Five concrete benefits you feel within the first week:

### 1. Starting a session is one prompt — Claude figures out the rest

You don't keep a mental map of which files to load. You say **"please read `.claude/HANDOFF.md`"** and Claude walks the routing table: it asks you which project, loads that project's `CLAUDE.md`, reads the project `HANDOFF.md` for active threads, and confirms the stage you're on. The dispatcher covers six task modes (research / writing / literature learning / scheduling / code walkthrough / meta-review). See [`.claude/HANDOFF.md`](.claude/HANDOFF.md).

### 2. `git clone` lands with a runnable skeleton and a working example

You don't stare at an empty `projects/` wondering what goes where. [`projects/_example/`](projects/_example/) is a complete meta-project with filled-in Brainstorm and Survey documents so the shape of a "done" Stage 00 or Stage 01 is visible. Tell Claude "use `_example/` as the shape reference" and it bootstraps your project by example, not by hallucination.

### 3. Research and writing live in separate layers — no more mixing them up

When you write a paper, you do not want the prose, the live experiment decisions, and the rejected-hypothesis narrative on the same page. Research OS physically separates them:

- **`projects/<name>/tracks/<track>/<thread>/`** — your live research process (five stages: brainstorm, survey, proposal, implement, experiment)
- **`writing/<target>/`** — paper-ready material: chapter structure, figure directories, five-layer writing material per panel

Once a thread's experiment stage lands, you copy curated figures and metadata into `writing/<target>/` at the right time, leaving the thread's `results/` directory as the experimental truth and the `writing/` version as the polished artefact. See [`writing/_index.md`](writing/_index.md).

### 4. The archival problem is already solved

A big share of post-project pain is "how do I put this on Feishu / Notion / Confluence now that it's done, in a way future-me can read?" Research OS ships a full external-platform mirror workflow at [`.claude/rules/writing-and-archival.md`](.claude/rules/writing-and-archival.md): document-type conventions, writing-material five-layer spec, citation three-step verification, plus a separate figure-style spec at [`figure-style-guidelines.md`](.claude/rules/figure-style-guidelines.md). Tell Claude "push this thread's results to Feishu" and the rules activate. Both Feishu and Notion playbooks ship in [`.claude/rules/platforms/`](.claude/rules/platforms/) — setup checklists + minimal verify commands included.

### 5. Pre-installed skills activate exactly when you need them

No `/plugin install` required. `git clone` gives you five skills that trigger on the right moments:

| Skill | Source | Triggers on |
|-------|--------|-------------|
| [code-walkthrough](.claude/skills/own/code-walkthrough/) | **own** · MIT | Explaining a diff / PR review / cross-layer call tracing |
| [karpathy-guidelines](.claude/skills/upstream/karpathy-guidelines/) | [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) · MIT | Writing / reviewing / refactoring any code — also baked into [CLAUDE.md §12](CLAUDE.md) as default behavior |
| [superpowers-brainstorming](.claude/skills/upstream/superpowers-brainstorming/) | [obra/superpowers](https://github.com/obra/superpowers) · MIT | Any creative work before implementation — **including bootstrapping your first project** |
| [superpowers-systematic-debugging](.claude/skills/upstream/superpowers-systematic-debugging/) | [obra/superpowers](https://github.com/obra/superpowers) · MIT | Any bug / test failure / unexpected behavior |
| [superpowers-test-driven-development](.claude/skills/upstream/superpowers-test-driven-development/) | [obra/superpowers](https://github.com/obra/superpowers) · MIT | New feature / bugfix — tests first |

Full index with attribution: [`.claude/skills/_catalog.md`](.claude/skills/_catalog.md). Every `upstream/` skill carries a `_UPSTREAM.md` with source URL, pinned commit, license, and author credit.

### 6. Bundled cross-project feedback memory — war stories, not rules

[`memory/`](memory/) ships ~20 desensitized feedback notes from real multi-project use: Feishu/Notion markdown pitfalls, SSH heredoc traps, figure pipelines, Opus token guardrails, session-boundary discipline. **One researcher's war stories, not prescriptive rules** — adopt, delete, append. Private entries (`user_*.md` / `private_*.md`) stay local via `.gitignore`.

---

## Quick start

### Recommended path: let Claude bootstrap your first project

The repo is a Claude Code template — the fastest way in is to let Claude read the template + shipped example and generate your project for you.

**Step 1 — clone:**

```bash
git clone https://github.com/hauser-zhang/claude-research-os.git
cd claude-research-os
```

**Step 2 — open Claude Code in this directory and paste this single prompt:**

> Please read `.claude/HANDOFF.md`, `CLAUDE.md`, `projects/README.md`, and `projects/_example/` thoroughly. Then use the `superpowers-brainstorming` skill to help me create `projects/<my-project-slug>/` for my actual research project — explore the project goals, track partition, baseline, and remote environment before generating any files. Use `projects/_example/` as the shape reference.

What happens next:

1. `.claude/HANDOFF.md`'s routing table tells Claude this is a "new project bootstrap" task
2. Claude reads `_example/` to learn what a real L3 project looks like
3. The brainstorming skill auto-triggers because you mentioned it — Claude walks you through 5–10 questions about your research (question, tracks, baseline, remote env, active hypotheses)
4. Claude generates `projects/<your-slug>/` with `CLAUDE.md`, `.claude/HANDOFF.md`, track `_index.md` files, and a first thread with Stage 00 already filled in from the brainstorming conversation

Total time: **15–30 minutes**, and the brainstorming conversation **is** the first thread's Stage 00 — zero wasted work.

**Step 3 — day-to-day usage.** For every subsequent session, the pattern is the same:

> Please read `.claude/HANDOFF.md` and continue.

The HANDOFF dispatcher asks which project you're working on, loads the right L3 files, and drops you into the active thread's current stage.

<details>
<summary><b>Manual bootstrap</b> — offline, no AI assistance</summary>

```bash
# After git clone + cd:
cp -r projects/_example projects/my-project
cd projects/my-project
rm HOW-TO-USE-THIS-EXAMPLE.md    # delete the example-only instructions
# then hand-edit every file to replace example content with your own
```

Works offline, but slower — you re-derive every section yourself instead of letting Claude scope them to your project. Full new-project guide: [`projects/README.md`](projects/README.md).

</details>

---

## Your first week

| Day | What | Where |
|-----|------|-------|
| 1 | Clone, paste the HANDOFF prompt, brainstorm your first project from `_example/` | `projects/<slug>/` created |
| 2-3 | Write Stage 00 → 01 → 02 of your first thread at your own pace | `tracks/<t>/<thread>/{00,01,02}.md` |
| 4 | Hit a friction? Append one line. Don't debate where it goes | `tracks/<t>/<thread>/frictions.md` |
| 5+ | Wiki page a paper only when you re-read it a second time | `wiki/papers/<slug>.md` |
| Week 2 | First meta-review from accumulated frictions | `meta/reviews/YYYY-MM-DD.md` |

---

## The four core mechanisms

| Mechanism | Addresses | Where it lives |
|-----------|-----------|----------------|
| **Three-scope cascade** — `L1 global / L2 framework / L3 project` `CLAUDE.md` layered load | "Copy-paste and hope" | Repo root + `projects/<name>/` |
| **Dual-Primary knowledge** — timeless facts in `wiki/`, time-ordered process in `tracks/<t>/<thread>/`, bidirectional links | "Already summarised this" | `wiki/` (L2) + `projects/<name>/tracks/` (L3) |
| **Five-stage flow + ADRs + frictions backlog** — every decision and rejected idea leaves a trail | "Didn't we already decide" | `decisions/` + `meta/` + thread `00..04.md` |
| **Research ⇄ writing separation** — live process in `tracks/`, paper-ready material in `writing/<target>/` | Mixing experimental decisions with paper prose | `projects/<name>/tracks/` + `writing/` |

See [docs/architecture.md](docs/architecture.md) for detailed diagrams and mechanics.

---

## Architecture (30 seconds)

```
~/.claude/                  (L1 · global)
  └─ coding / testing / git conventions

research-os/                (L2 · this repo — framework)
  ├─ CLAUDE.md              ← framework constitution
  ├─ .claude/rules/         ← archival workflows (Feishu / Notion)
  ├─ .claude/skills/        ← brainstorming / debugging / TDD (bundled)
  ├─ wiki/                  ← cross-project timeless knowledge
  ├─ memory/                ← ~20 desensitized feedback notes
  └─ projects/
      └─ <your-project>/    (L3 · per-project)
          ├─ CLAUDE.md      ← project charter + remote env
          └─ tracks/<t>/<thread>/
              └─ {00..04}.md  ← five-stage flow
```

Claude Code's cascading `CLAUDE.md` loader walks the directory tree and layers all three automatically. No glue code.

For the full diagram and the Dual-Primary / five-stage / self-evolving mechanics → [docs/architecture.md](docs/architecture.md).

### What each top-level folder does

The layout reflects the Dual-Primary split (source → knowledge → process → output) plus a self-evolving layer on top:

| Folder | Role |
|--------|------|
| `projects/<name>/` | Your research projects (L3) — charter, tracks, threads, project-local rules |
| `wiki/` | Cross-project timeless knowledge — papers, concepts, datasets, benchmarks, syntheses |
| `raw/` | Immutable source material — PDFs, clipped blog / GitHub notes, `manifest.json` |
| `learning/` | Non-task-driven reading digest — blog / GitHub / tutorial notes; can later promote to `wiki/syntheses/` |
| `writing/<target>/` | Paper / thesis material per writing target — chapter structure + figures + five-layer panel material |
| `journal/` | Daily lab notebook — cross-thread process observations + today's frictions |
| `schedule/` | Cross-thread ToDo and long-term goals — paper deadlines, weekly routines |
| `meta/` | Self-evolving layer — frictions backlog, weekly reviews, improvements backlog |
| `memory/` | Cross-project feedback notes — war stories the maintainer keeps adding |
| `decisions/` | ADRs — architectural decisions with rationale, reversibly documented |

---

## How to know it's working

- **Decisions stop reappearing.** Week 3's Claude doesn't re-propose what Week 1 rejected — it's in an ADR.
- **`wiki_touches:` grows.** A paper's wiki page shows 3, 5, 7 thread references. Knowledge compounding.
- **New project bootstraps in <30 minutes.** AI-assisted brainstorm + an example to mirror = you skip the "where does what go" phase entirely.
- **Frictions backlog empties weekly.** 2-minute real-time capture, batched in `/meta-review`.
- **Results reach Feishu / Notion without you re-thinking the schema.** The archival rules cover document structure, figure style, and citation verification — you don't re-invent the process per project.
- **Commits trace to one logical feature.** Sessions end with `git commit + push`.

If the opposite happens — stale wiki, growing backlog, ADRs nobody reads — read [`docs/philosophy.md`](docs/philosophy.md) and reconsider which pieces you're actually using.

---

## Deep dive

| Topic | Where |
|-------|-------|
| Full architecture (diagrams + mechanics) | [docs/architecture.md](docs/architecture.md) |
| Philosophy (LLM bookkeeping / Dual-Primary / Five-stage / Self-Evolving) | [docs/philosophy.md](docs/philosophy.md) |
| Annotated repo layout | [docs/repo-layout.md](docs/repo-layout.md) |
| Reference project with filled-in phase docs | [projects/_example/](projects/_example/) |
| Three-scope ADR | [decisions/ADR-0001](decisions/ADR-0001-research-os-architecture.md) |
| Tracks + IDEAS inbox ADR | [decisions/ADR-0002](decisions/ADR-0002-tracks-and-ideas-inbox.md) |
| Open-source L2/L3 split ADR | [decisions/ADR-0003](decisions/ADR-0003-open-source-split.md) |
| Learning-sources + skill own/upstream ADR | [decisions/ADR-0004](decisions/ADR-0004-learning-sources-and-skills-split.md) |
| Feishu archival playbook | [.claude/rules/platforms/feishu.md](.claude/rules/platforms/feishu.md) |
| Notion archival playbook | [.claude/rules/platforms/notion.md](.claude/rules/platforms/notion.md) |
| Figure style (publication-quality) | [.claude/rules/figure-style-guidelines.md](.claude/rules/figure-style-guidelines.md) |
| Citation three-step verification | [.claude/rules/research-and-reporting.md](.claude/rules/research-and-reporting.md) |

---

## Inspired by

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

## Who is this for

- **PhD students / postdocs running 2+ research projects in parallel**
- **Scientists who write papers/theses AND run experiments** — need separation between live decisions and paper prose
- **Researchers with Feishu / Notion / Confluence archival habit** — who want Claude to push curated updates to shared platforms on demand
- **People who want Claude Code to remember decisions across months, not just sessions** — the wiki ⇄ threads architecture is the answer

---

## Why not a fully-autonomous AI scientist?

**Short answer: use both.** Let the agent run a bounded sub-task; keep the human on the outer loop. Research OS is built for that outer loop.

Projects like [SakanaAI/AI-Scientist](https://github.com/SakanaAI/AI-Scientist) (13.4k ★ — *"Towards Fully Automated Open-Ended Scientific Discovery"*), [stanford-oval/storm](https://github.com/stanford-oval/storm) (28.1k ★ — *"LLM-powered knowledge curation that researches a topic and generates a full-length report with citations"*), and [Future-House/paper-qa](https://github.com/Future-House/paper-qa) (8.4k ★ — *"High-accuracy RAG for questions from scientific documents with citations"*) excel at **closed, well-scoped tasks**: write a focused survey, query a paper corpus end-to-end, run a synthetic ML benchmark from hypothesis to plot. When a sub-problem fits inside one of those tasks, delegate it.

Research OS covers what a PhD career spans across years, which the autonomous loops don't try to cover:

- **Wet-lab / instrument / field work** — biology, chemistry, physics, astronomy. The experimental middle is irreducibly human; autonomous systems can accelerate the bookends (literature, figures, drafts), but cannot close the loop alone.
- **Cross-project knowledge that compounds** — three years of decisions, rejected hypotheses, validated techniques. Optimizing a single paper is a different problem than optimizing *you*.
- **Verifiable mid-steps** — autonomous pipelines can silently fail at step N; Research OS keeps citation three-step verification and real-time friction capture as explicit rules, so every mid-step leaves a checkable trail.

**Same workflow, different layers.** Plug an autonomous agent in as a sub-task runner under a Research OS thread when you have a bounded sub-problem (e.g. *"survey papers on topic X"*, *"run benchmarks Y"*). The thread keeps the history and the decisions; the agent does the grunt work.

---

## Not suited for

- **One-off projects that finish in a week.** No cross-session accumulation — plain Cursor / Copilot is enough.
- **Pure application engineering.** Research OS is for hypothesis → validation → interpretation; wiki + threads are overkill for feature dev.
- **Structured data pipelines.** Snakemake / Airflow have their own philosophies; Research OS is the meta-layer of research *process*.

---

## Status & contributing

**v1.4** · dogfooding since 2026-04 on the maintainer's own multi-month project.

- Issues for architectural ambiguity / missing examples / concrete pain points.
- PRs for skeleton improvements (open an issue first — template changes affect every fork).
- Structural changes: propose a new ADR ([template](decisions/ADR-TEMPLATE.md)).
- Community skill mirrors: follow the license + `_UPSTREAM.md` contract in [ADR-0004](decisions/ADR-0004-learning-sources-and-skills-split.md).

## License

[MIT](LICENSE) © 2026 [Hauser Zhang](https://github.com/hauser-zhang). Upstream skills retain their original licenses — see each skill's `_UPSTREAM.md`.
