---
adr_id: ADR-0002
title: Introduce tracks/ layer and IDEAS.md inbox under projects/<name>/
status: accepted
date: 2026-04-22
author: Hauser Zhang + Claude
supersedes: []
superseded_by: []
related_spec: CLAUDE.md §2, §3, §6
---

# ADR-0002 · Tracks layer + IDEAS.md quick-capture inbox

> **TL;DR**: Wave A's original design used a flat `projects/<name>/threads/` list, which lost the researcher's mental "research-direction" dimension. Add a `tracks/<track>/<thread>/` two-level structure + a `projects/<name>/IDEAS.md` inbox, aligning with the way external-platform project-home multi-dimensional tables organise work.

## Context

After Wave A, the maintainer reviewed and found two gaps:

**Gap 1: flat threads lose the research-direction partition**

In actual work, a project's tasks are **mentally partitioned by direction** (matching the big categories on an external-platform project-home multi-dimensional table), e.g.:
- Model architecture improvements (sub-module A / sub-module B / positional encoding / ...)
- SOTA comparisons (vs baseline 1 / vs baseline 2 / ...)
- Model interpretability (feature ablation A / feature ablation B / ...)
- Case studies (case A / case B / specific scenario / ...)

The original design put all threads flat under `threads/`, losing the "which direction does this sub-task belong to" signal. When the maintainer checks project status, the first thing they want to ask is "what's the status of the interpretability line?", not "what's the status of every thread?"

**Gap 2: ideas and mentor-assigned tasks have no low-cost capture**

The maintainer constantly generates new ideas or receives new tasks during group meetings / paper reading / discussions. If every one needs a thread and a five-stage flow, **the capture cost is high enough that ideas get lost**. If they just stay in the head or scattered notes, batch triage becomes impossible.

## Options

### Option A: keep flat threads, use a `track:` field in frontmatter for implicit classification

- **Pros**: no directory change
- **Cons**: the first-level entry is still a flat list; seeing "what threads are in this track" requires walking all thread frontmatters; not intuitive

### Option B: introduce `tracks/<track>/<thread>/` two-level directories, each track with an `_index.md` (**this ADR's choice**)

- **Pros**: the directory itself is the classification; track-level `_index.md` carries "why this direction"; 1:1 correspondence with external-platform multi-dim tables
- **Cons**: deeper directory nesting; cross-track search slightly harder

### Option C: each track as its own standalone project

- **Pros**: cleanest isolation
- **Cons**: interpretability and model-architecture still belong to the same paper, the same codebase, the same dataset — artificial splits backfire

## Decision

**Choose B**. Also introduce `projects/<name>/IDEAS.md` as a low-cost capture inbox for bursts of inspiration.

## Rationale

1. **Matches the user's mental model**: tracks map to the big categories on the external platform's project home; `_index.md` maps to that category's status table plus why statement. The local and external views are consistent.
2. **Supports track-level decisions**: when deciding "should the interpretability line continue", `tracks/interpretability/_index.md` is the single source of truth — no need to walk through each of N thread READMEs.
3. **Clear task attribution**: opening a new thread starts with "which track does this belong to?"; the track's why statement constrains whether the new thread aligns.
4. **IDEAS cost vs benefit**: one line of markdown vs the cost of losing an idea. Weekly meta-review does batch triage at predictable cost.
5. **No impact on Dual-Primary**: thread internal structure (five stages + `wiki_touches:` frontmatter) is unchanged; the wiki layer is unaffected.

## Consequences

### Positive

- The project overview page (`projects/<name>/README.md`) naturally aligns with the external-platform multi-dim table
- Track-level `_index.md` captures why and success criteria, preventing sub-tasks from drifting from the direction
- IDEAS.md stops idea loss; triage flow is explicit
- During Wave B migration, processing by track gives controllable pacing

### Negative

- Thread paths lengthen: `projects/<name>/tracks/<track>/<thread>/` vs original `projects/<name>/threads/<thread>/`
- Requires judgement on "does this new task need a new track, or should it join an existing one?" (a boundary call)
- Wave A's already-written `HANDOFF.md` Mode A and `CLAUDE.md` directory map need patches

### Neutral / Things to Monitor

- If a track consistently has only 1 thread, the classification is too fine — merge it
- If IDEAS.md accumulates >30 untriaged entries, weekly meta-review cadence has slipped — nudge

## Follow-ups

- [x] Patch repo-root `CLAUDE.md` §2 architecture diagram, §3 thread-path description, §6 directory map
- [x] Rewrite `.claude/HANDOFF.md` Mode A to use the two-step track → thread lookup
- [x] Add figures/ chapter spec to `writing/_index.md`

## References

- Maintainer feedback: "First I mentally partition a project's tasks into a few big categories (model architecture improvements / SOTA comparisons / interpretability / case studies / ...), and under each category are the specific tasks."
- Maintainer feedback: "Each project should have a project-overview page (corresponding to the multi-dim table on an external-platform project home)."
- Maintainer feedback: "Sometimes I have a burst of ideas (or my mentor assigns me things) that I want to capture quickly."
