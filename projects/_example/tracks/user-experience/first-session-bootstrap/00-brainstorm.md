---
stage: 00-brainstorm
thread: first-session-bootstrap
track: user-experience
agency: pair-divergent
status: done
started: 2026-04-26
decided: 2026-04-26
---

# 00 · Brainstorm

## Lead question

What must happen in the first session for a new user to reach "I can run my own research in this OS" **without reading every ADR**?

## Candidates (≥5 scenarios of how the first session could unfold)

### Scenario A: user reads README sequentially, then manually edits files

- **Pros**: zero tooling dependencies; user learns by doing
- **Cons**: 30-60 min of reading before first concrete action; fragile attention; high dropout

### Scenario B: user clones, runs a bootstrap script that prompts for project name + a few fields, gets a populated `projects/<name>/`

- **Pros**: 60-second path to a usable skeleton
- **Cons**: the generated skeleton is still empty — user hasn't thought about tracks, threads, research goals yet; they'll abandon the filled template

### Scenario C: user clones, talks to Claude, Claude reads `_example/` and guides them through a brainstorm-style onboarding, then generates `projects/<name>/`

- **Pros**: matches the tool's actual use pattern (this is a Claude Code template); the brainstorming skill is already bundled and will auto-trigger; the onboarding **is** a research session, which both teaches and produces real output
- **Cons**: requires the user to trust Claude with scaffolding; if bundled skills don't load correctly, the experience degrades to Scenario A

### Scenario D: maintainer publishes a video walkthrough; user watches it, then follows steps

- **Pros**: lowest cognitive load for users who learn visually
- **Cons**: videos go stale fast; maintenance cost high; doesn't scale to translations

### Scenario E: user pastes a single mega-prompt to Claude that reads the entire repo and produces a project

- **Pros**: one-shot, no back-and-forth
- **Cons**: Claude makes too many assumptions without brainstorming; output quality varies; user ends up re-doing the scaffolding anyway

## Decision

**Primary path: Scenario C.** Secondary / fallback: Scenario A (the manual route).

Scenarios B, D, E are rejected for v1 but may be revisited once usage data accumulates (B if users ask for it, D if translation or marketing demands it, E if skill triggering becomes reliable enough).

## Rationale

1. **Plays to the tool's strengths.** This repo is a Claude Code template; the user is already in a Claude session. Using Claude to bootstrap a project is not a bolt-on — it's the native mode.
2. **The brainstorming skill is bundled and will auto-trigger.** The user didn't install it; they inherited it via `git clone`. The onboarding experience **demonstrates** the batteries-included promise rather than claiming it.
3. **The onboarding produces real research output.** A brainstorm about the user's project goals is exactly what Stage 00 of their first thread needs. Zero wasted work.
4. **Scenario A stays as a fallback.** Some users can't or won't delegate scaffolding to an AI — they should have a documented manual path, but it doesn't need to be the primary.

## Self-pokes (≥3 holes)

1. **"Skills will auto-trigger" is optimistic.** Skills trigger on description-matching heuristics. If the user's first prompt doesn't mention "brainstorm" / "plan" / "explore", the brainstorming skill may not activate. The Survey stage should check actual trigger rates via transcript analysis.
2. **Assumes Claude is the preferred agent.** Users on other CLI tools (Cursor, Codex, opencode) may lose the bundled skills entirely. Do we need `README.codex.md` / `README.cursor.md` analogues?
3. **"30 minutes to a usable skeleton" is a hypothesis, not a measurement.** We have no baseline. The Survey stage should identify how other template repos measure onboarding time (GitHub insights? opt-in telemetry? surveys?).

## Next stage

Advance to `01-survey.md`: compare first-session onboarding of karpathy-skills, Multica, shadcn-ui, create-next-app. Focus on (a) time-to-first-working-output, (b) whether AI-assisted paths are primary or secondary, (c) how they handle the fallback for users who skip the AI path.
