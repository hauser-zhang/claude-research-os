---
adr_id: ADR-0003
title: Open-source split — L2 framework skeleton vs L3 project content
status: accepted
date: 2026-04-25
author: Hauser Zhang + Claude
supersedes: []
superseded_by: []
---

# ADR-0003 · Open-source split: L2 framework skeleton vs L3 project content

> **TL;DR**: Separate "template framework" from "private project content" out of the mixed monorepo: the L2 root `CLAUDE.md` holds only the generic skeleton (open-source), while L3 `projects/<name>/CLAUDE.md` holds project-specific charter content (gitignored or created by the user). Single repo + whitelist-style `.gitignore`.

## Context

Research OS is currently the maintainer's personal research operating system; `projects/<author-main-project>/` is the first (and currently only) active project. The future goal is to **open-source this as a Claude-assisted research template**.

After closing out Waves B / C / D, two forms of pollution surfaced:

1. **The root `CLAUDE.md` is polluted by project specifics**: §9 "migration progress" literally lists the main project's Wave A/B/C/D status; §8 cites rules that use the main project's examples as the default; §6 hard-codes `projects/<author-main-project>/` in the directory map.
2. **Should `projects/<author-main-project>/` itself be tracked in git?** The directory has both privacy content (frictions, internal decisions, research process) and demo value ("this is what a real project looks like").

Without fixing this, open-sourcing either means "publish everything" (exposes private research process) or "trim the repo each time" (brittle, error-prone).

## Options

### Option A: single repo + `_example/` demo (main project gitignored)

- Root `CLAUDE.md` cleansed into pure skeleton
- L3 `projects/<author-main-project>/CLAUDE.md` absorbs project-specific content
- `.gitignore` excludes the entire `projects/<author-main-project>/`
- Additionally build `projects/_example/` as an anonymised demo; open-source users get a live demo on `git clone`

**Pros**: single source of truth, clean demo, local work unaffected
**Cons**: extra maintenance (every skeleton change must be mirrored to `_example/`)

### Option B: single repo, no demo

- Same as A but skip `_example/`; put a `README.md` under `projects/` that teaches how to create one
- Open-source users see an empty `projects/` on clone

**Pros**: minimum maintenance
**Cons**: open-source users don't see a "real project structure" — steeper learning curve

### Option C: two repos (`research-os` + `research-os-template`)

- Local `research-os` keeps everything (including main project)
- Public `research-os-template` periodically synced manually with skeleton + anonymised demo

**Pros**: two repos, two clean responsibilities
**Cons**: every skeleton evolution requires syncing two repos; easy to forget

### Option D: single repo, main / personal branches

- `main` branch: skeleton + optional demo (public)
- `personal` branch: `main` + main project
- Only push `main` when open-sourcing

**Pros**: native git mechanism
**Cons**: every main-project change needs to rebase; every framework change needs to merge back into personal; merge traps easy to hit

## Decision

Choose **Option B** (single repo + main project gitignored; skip `_example/` for now).

Add `_example/` later — once the skeleton has stabilised and the demo cost is lower.

## Rationale

1. **Single repo has the lowest maintenance cost**: one source of truth, no cross-repo sync
2. **Main project fully private**: the whole directory is gitignored; open-source never exposes it; local work stays the same
3. **Aligned with Claude Code's cascading load**: L2 `CLAUDE.md` at the repo root loads automatically; L3 at `projects/<name>/CLAUDE.md` loads when you `cd` into the project — structure and tooling match natively
4. **L3 `CLAUDE.md` vs `.claude/HANDOFF.md` split**:
   - `projects/<name>/CLAUDE.md` = **charter** (static: core definition, track inventory, wave migration final state, remote servers, conda env)
   - `projects/<name>/.claude/HANDOFF.md` = **session entry** (dynamic: active threads, next-step candidates, session startup guide)
5. **`_example/` is premature**: no users yet for v1; building it now would be extra maintenance for no benefit

## Consequences

### Positive

- Root `CLAUDE.md` slims down (from 277 → ~200 lines), pure L2 skeleton
- The main project's wave migration table, junction notes, active threads all move to L3 `projects/<author-main-project>/CLAUDE.md` — one source of truth
- `git push` works directly when open-sourcing; no ad-hoc trimming
- When a future project is added via `projects/<new>/`, charter content naturally lands at L3 and won't pollute the root `CLAUDE.md`

### Negative

- Short-term migration cost: this refactor moves ~50–100 lines of text from L2 to L3
- Open-source users see an empty `projects/` on first clone (but `projects/README.md` explains how to create one)

### Neutral / Things to Monitor

- **When to build `_example/`**: when a second active project appears, or when the first external user says they need a demo
- **HANDOFF templating**: the current `.claude/HANDOFF.md` "task dispatcher + modes A–F" is generic and open-sourceable; if main-project-specific session state leaks in, demote it to the L3 HANDOFF promptly

## Follow-ups

- [x] Cleanse L2 `CLAUDE.md` (remove the §9 wave table / project name / junction refs)
- [x] Create `projects/<author-main-project>/CLAUDE.md` (L3 charter)
- [x] Build `projects/README.md` (new-project guide)
- [x] Add the maintainer's main-project path to `.gitignore`
- [ ] Build `projects/_example/` (anonymised skeleton demo) when the second active project lands or before open-sourcing
- [x] Before open-source: repo-level README + LICENSE

## References

- ADR-0001 — Research OS three-scope architecture (this ADR is the concrete L2 vs L3 boundary grounding)
- ADR-0002 — tracks and ideas inbox (this ADR does not touch the internal tracks structure, only the outer layering)
