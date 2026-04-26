# Philosophy — why the design is shaped this way

> This document explains the four core ideas behind `claude-research-os`. It is not a spec, not a how-to — it is the **why**.
> Read here if you are evaluating whether to adopt the template, or if you want the theory-of-mind behind a specific design choice.
> For operational rules, see [`CLAUDE.md`](../CLAUDE.md). For the decision trail, see [`decisions/`](../decisions/).

---

## 1. LLM is for bookkeeping; you are for thinking

### Observation

After a while using Claude Code you notice an anti-pattern: **you start asking Claude to make research decisions for you.** "Which of these two models is better", "should we re-run this experiment", "is this paper worth reading" — give these to an LLM and you typically get a plausible-sounding answer that is essentially priors, while **the decision authority has been taken out of your hands**. You become a rubber stamp.

Flip it: keep decision authority yourself, and let Claude do the mechanical-but-tedious work — **literature compilation, cross-referencing, format checks, operation logs, friction capture, path housekeeping, rename consistency**. Now Claude is an amplifier of your thinking bandwidth, not a replacement.

### Principle

Research OS positions Claude as a **bookkeeper**:

| Give to Claude | Keep for yourself |
|----------------|-------------------|
| Read a PDF, extract key points, cross-reference | Decide whether this paper is worth reading |
| Format Writing Material to spec | Decide whether this result belongs in the paper |
| Flag cross-document naming inconsistencies | Decide which name to adopt |
| Sort frictions into the backlog | Decide which friction graduates into a rule |
| Aggregate subagent results for sanity check | Decide whether to change experimental direction |
| Maintain bidirectional links in the wiki | Decide which of two papers is the more fundamental source |

### How it lands

- **The five-stage flow's per-stage agency** (divergent brainstormer / autonomous surveyor / critical reviewer / implementer / reporter) is not asking Claude to make decisions — it is asking Claude **not to drift from the current stage's cognitive task**. Don't converge early during brainstorm. Self-poke holes during proposal. Separate observation from explanation during experiment.
- **The frictions.md mechanism**: any "Claude missed my point" / "a rule gap" moment gets one line logged in 2 minutes, never mid-flow. Weekly review batches them. No interruption to research flow.
- **Sub-agent isolation**: have a sub-agent read 1000 lines of raw material and summarise in 300 words for the main agent. Main agent does orchestration, cross-checking, and decisions only.

---

## 2. Dual-Primary knowledge: process and facts stay separate

### Observation

Research knowledge has two distinct natures:

- **Timeless facts**: what a Transformer is, what STRING's 7 edge channels are, what a paper's core claim is. **Does not evolve with research progress** — last year's definition is still today's.
- **Time-ordered process**: at T0 I considered hypothesis X; at T1 I rejected it because Y; at T2 I decided on Z. **Strongly dependent on time and context** — strip the narrative and it loses meaning.

Traditional note systems (Obsidian, Notion, Logseq) tend to mix both on one page — entity-per-page, but the entity page interleaves process narrative, rejected hypotheses, and currently valid conclusions. Result:

- Every time you write, you hesitate over "is this timeless or time-ordered?"
- When you read, you get neither a clean fact comparison nor a clean decision narrative
- When writing a paper, doing a survey, or preparing a defense, you need one view or the other — but all you have is mixed notes

### Principle

**Physically separate two stores:**

| Layer | Path | Content | Why read |
|-------|------|---------|----------|
| **Wiki** | `wiki/{papers,concepts,datasets,benchmarks,syntheses}/` | Entity-per-page, **timeless facts only**. Comparisons, contradictions flagged, synthesised arguments | Quick "what is X", writing surveys, cross-project fact comparison |
| **Threads** | `projects/<name>/tracks/<track>/<thread>/` | Per-five-stage 00–05 markdown, **time-ordered process only**. Decision narrative, hypotheses, rejection reasons, failure lessons | Cross-session handoff, reviewing decisions, writing methods / discussion |

**Bidirectional-link contract**:
- Thread phase docs list `wiki_touches: [transformer, graphsage, string-db]` in frontmatter
- Wiki pages auto-list `## Touched By` with all threads that reference them

Result:
- When writing a new thread and hitting "what is a Transformer", link to the wiki page, don't re-write
- When onboarding a new project, the wiki is **automatically reusable** (it's cross-project); threads start fresh
- Wiki pages thicken as more threads reference them (knowledge compounding); threads stay narrow

### How it lands

- Wiki has 5 types: `papers/` (author-year-keyword) · `concepts/` (methods / terms) · `datasets/` · `benchmarks/` · `syntheses/` (cross-page synthesised arguments, the second-order product of the dual-primary architecture)
- Each page has `status: stub | draft | mature | stale` — it does not need to be written in one sitting; gradual filling is allowed
- When a thread finishes a stage, the phase doc gets `status: accepted` — from that point it is not modified; new findings open a v2

---

## 3. Five-stage flow: agency as cognitive constraint, not persona

### Observation

Most "LLM-assisted research" READMEs tell you to "have Claude play different roles" — critic, implementer, writer. But when Claude is prompted "you are now the critic", it just changes its tone. If it was going to jump to a conclusion, it still jumps.

Real value is not in the persona but in the **cognitive constraint**:

- Brainstorm should be **divergent**, not converge early on "the best answer"
- Survey should use **implementation-reproducible citations**, not write from memory
- Proposal should **poke ≥3 holes in itself**
- Implement should **record frictions** — "the bug was fixed" is not "done"
- Experiment should **separate observed from explained** — do not report correlation as causation

### Principle

The five stages are not a timeline (though nominally 00→04). They are **five cognitive tasks**:

```
00 Brainstorm ─ pair divergent ────── ≥5 candidates with pros/cons, don't decide yet
01 Survey ───── autonomous ────────── implementation-reproducible citations, 3-step verification
02 Proposal ─── pair + critical ───── define the question, falsifiable claims, ≥3 self-pokes
03 Implement ── autonomous + milestone write code, log frictions, commit per stage
04 Experiment ─ critical reporter ─── observed vs explained, layered report, no overclaim
```

Each stage emits one markdown file. `status: done / accepted` gates the next. **Stage-skipping is forbidden** — jumping from brainstorm straight to implement is the single most common failure mode.

### How it lands

- Each stage has a fixed skeleton (00-brainstorm: candidate table + decision + self-poke; 01-survey: literature comparison table + citation verification trail; 04-experiment: Analysis metadata + full numbers + Surprises / Counter-evidence)
- Writing Material (`05-writing-material.md`) sits separately — it serves "turn results into paper text", not "do research"
- ADRs are not stage artifacts — they are decision records about the research **system itself**

---

## 4. Self-Evolving: the system adapts to your habits

### Observation

Any workflow with "fixed rules" will **drift from your actual habits within a few weeks**. Either you start routing around it, or you maintain it and feel it's not paying off. A system that survives long-term must keep **evolving itself**.

But "keep evolving" cannot mean "stop and change the rules every time a rule feels off" — that interrupts research flow. Correct approach: **low-cost capture + batched decision**.

### Principle

```
Real-time capture ──→ Session-end auto-grep ──→ Weekly meta-review
     ↓                      ↓                         ↓
  frictions.md         frictions-backlog.md      ADR / rule change / template update
  (2 min / item)       (aggregated)              (batched, 10–20 min)
```

| Cadence | Action | Cost | Interruption |
|---------|--------|------|--------------|
| **Real-time** | Hit a rule gap → append one line to the current thread's `frictions.md` | 2 min | 0 |
| **Session-end** | `grep` all frictions.md files → aggregate into `meta/frictions-backlog.md` | Agent automates | 0 |
| **Weekly** | Batch-process the backlog: tweak rules / update templates / write a new ADR / archive stale items | 10–20 min | Yes, but weekly only |

### How it lands

- **Friction = any gap in the system** — a missing rule / a template without a needed section / a missing command / Claude misreading intent / a naming inconsistency / a step you keep redoing
- **Friction entry format**: one line `YYYY-MM-DD | source | symptom | hypothesis` — don't aim for complete, aim for fast
- **Meta-review output**: a pattern that shows up ≥3 times graduates into a rule or an ADR; a singleton is probably noise, archive
- **ADRs are immutable**: status can move through proposed / accepted / superseded / deprecated, but the history stays — including rejected decisions, so the evolution of thought is visible

---

## How the four ideas reinforce each other

The four are not independent — they support each other:

- **LLM bookkeeping** makes Dual-Primary maintainable — auto-syncing bidirectional links, flagging naming inconsistencies, aggregating frictions are all bookkeeping tasks
- **Dual-Primary** makes the five-stage flow reusable — wiki shared across threads avoids re-writing facts each time
- **Five-stage flow** anchors Self-Evolving — frictions tagged by stage let weekly review spot "which stage produces the most frictions"
- **Self-Evolving** keeps the other three honest — when bookkeeping lapses, the wiki design is wrong, or stage boundaries blur, frictions accumulate and the meta-review catches it

Any one of them works on its own. **Together**, they form a positive-feedback system: every friction you log and every ADR you write makes next month's research smoother.

---

## Not suited for

This OS is **not** a good fit for:

- **One-off small projects**: done in a week, no cross-session accumulation needed; a plain Cursor / Copilot project structure is enough
- **Pure application engineering**: this OS targets **research-type work** (hypothesis → validation → interpretation); the wiki / threads layer is overkill for feature development
- **Team-collaboration-primary**: designed as **solo + Claude**. Multi-person collaboration needs additional synchronisation machinery (this is the explicit split between this OS and Feishu / Notion — external platforms are the team-shared mirror, local markdown is the individual source of truth)
- **Fully structured data pipelines**: Snakemake / Airflow have their own philosophies; Research OS is the meta-layer around research *process*, not the pipeline itself

---

## Further reading

- [CLAUDE.md](../CLAUDE.md) — concrete spec (three scopes, five-stage skeleton, sub-agent orchestration)
- [decisions/ADR-0001](../decisions/ADR-0001-research-os-architecture.md) — full decision record for the three-scope cascade
- [decisions/ADR-0002](../decisions/ADR-0002-tracks-and-ideas-inbox.md) — tracks + IDEAS inbox rationale
- [decisions/ADR-0003](../decisions/ADR-0003-open-source-split.md) — L2 / L3 open-source split
- [decisions/ADR-0004](../decisions/ADR-0004-learning-sources-and-skills-split.md) — external learning sources + own/upstream skill split

## Design rationale / Related work

Research OS is not invented from scratch — it combines two existing conventions into a reusable cross-project skeleton:

- **[Architecture Decision Records](https://adr.github.io/)** — architectural decisions are traceable. The `decisions/` directory follows the official ADR template (`ADR-NNNN-<slug>.md` with frontmatter + Context / Options / Decision / Rationale / Consequences).
- **[Anthropic skill-creator convention](https://docs.anthropic.com/en/docs/claude-code)** — the Skill three-layer spec (metadata trigger description → SKILL.md narrative → `references/` for volatile details) comes from Anthropic's skill-creator documentation; Research OS uses it verbatim.

The other choices (three-scope cascade, Dual-Primary, five-stage flow, self-evolving frictions) are this repo's own design, with theory-of-mind unpacked in the four sections above. When you see similar shapes elsewhere, it is more likely convergent design for the same problem than direct borrowing.
