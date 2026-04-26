---
adr_id: ADR-0001
title: Research OS architecture — three scopes + Dual-Primary + five stages + Self-Evolving + Skill three-layer spec
status: accepted
date: 2026-04-20
author: Hauser Zhang + Claude
supersedes: []
superseded_by: []
---

# ADR-0001 · Research OS architecture

> **TL;DR**: Promote the maintainer's existing single-project collaboration stack into a personal research operating system that covers multi-project research + paper writing + learning + scheduling. Adopt three-scope cascade (L1 global / L2 Research OS / L3 per-project) + Dual-Primary (threads for process, wiki for knowledge) + five-stage research flow + self-evolving friction mechanism + Anthropic's official skill three-layer spec.

## Context

The maintainer's single-project collaboration stack, iterated over several months, surfaced three pain points — and new requirements (thesis writing, cross-direction literature learning, schedule management) were starting to crush the existing structure:

1. **Knowledge does not compound**: literature buried in external-platform Survey documents cannot be reused across directions. Every new thread needs to re-look-up the same background concepts.
2. **Process knowledge is coupled with facts**: Brainstorm / Survey / Experimental Results / Writing Material all cram into one external document module; time-series history and timeless facts mix together.
3. **Skills and rules have no scope layering**: project-specific content (SSH server, external-platform tokens, a particular dataset format) and generic content (literature-survey rules, figure style) live in the same `.claude/`. Any new project will collide head-on.

External references considered:
- An earlier internal scaffold prototype offered a clean Dual-Primary + five-stage + Self-Evolving design, but it used a **flat `.claude/`** with no scope layering.
- **Anthropic skill-creator**'s official three-layer spec (metadata / SKILL.md / references) is more engineered than the original skill style — the existing skills had long ALWAYS/NEVER checklists with no "why" explanations.

A single architectural decision was needed to fix the workflow for the next few years.

## Options

### Option A: keep extending the single-project `.claude/`, add generic content in place

- **Pros**: zero migration cost; no new skeleton to build.
- **Cons**: amplifies coupling. When onboarding a new project, the old project's external-platform tokens and SSH commands pollute the shared collaboration layer. Knowledge (literature, concepts) still has no reuse; compounding stays at zero.

### Option B: build L2 only, skip the L3 project layer

- **Pros**: simplest structure; all skills/rules flat in one place.
- **Cons**: project-specific content (SSH, external tokens, data format) has nowhere to go. We would circle back to Option A.

### Option C: three-scope cascade (L1/L2/L3) + Dual-Primary + five stages + Self-Evolving + Skill three-layer spec (**this ADR's choice**)

- **Pros**:
  - Scopes are clean; every asset can be classified as "single-project" / "all research projects" / "cross-domain" and placed accordingly
  - Wiki shared across projects ("Transformer", "GraphSAGE", a specific paper referenced from multiple projects) → real knowledge compounding
  - Threads stay inside the L3 project (process narratives are inherently project-scoped)
  - Friction mechanism lets the system **continuously adapt to the maintainer's actual research habits** rather than freeze at v1
  - Skills decoupled per the official spec → `description` for LLM loading decisions, SKILL.md for narrative, `references/` absorbs volatile state
- **Cons**:
  - Build cost (Wave A) + migration cost (Wave B/C) + skill rewrite (Wave D)
  - Learning curve: deciding "what goes at which layer" takes training
  - Windows limitation: `mklink /J` does not support UNC paths — alternative junction mechanisms needed

### Option D: adopt the external scaffold prototype as-is (flat `.claude/`)

- **Pros**: a mature scaffold design; comes with a slash-command set.
- **Cons**: does not solve scope layering. The maintainer already has substantial feedback memory + several skills that need to be merged in, not thrown out.

## Decision

**Choose C**. Three-scope cascade + Dual-Primary + five stages + Self-Evolving + Skill three-layer spec.

## Rationale

1. **Scope layering is the core scalability lever**: the maintainer will onboard more projects over time; L1/L2/L3 gives each new project an isolated namespace while inheriting L2's shared assets, avoiding pollution.

2. **Dual-Primary solves compounding**: process (threads) and knowledge (wiki) separated. The scaffold prototype already proved this separation serves both "paper decision narrative" and "cross-direction fact reuse". **Wiki goes at L2, not L3**, because concepts and papers are inherently cross-project.

3. **Five stages enforce rhythm**: 00→04 each with a different Claude agency (pair / autonomous / critical reporter) prevents brainstorm from devolving into a chat transcript.

4. **Self-Evolving matches solo episodic workflow**: the maintainer cannot remember "the current rule is insufficient" every time; real-time friction capture + weekly batch review is the lowest-cost evolution mechanism.

5. **Official skill spec**: the maintainer already indicated a preference for "SKILL.md should explain why, not list MUSTs"; Anthropic's three-layer spec matches.

6. **Gradual migration, not big-bang**: Wave A builds the skeleton and migrates generic assets; Wave B pulls essentials from the external platform; Wave C incrementally splits the wiki from Survey docs; Wave D rewrites skills per the official spec. Every wave is independently verifiable.

## Consequences

### Positive

- New-project onboarding is just `mkdir projects/<name>/` + mount; all L2 assets inherit automatically
- A paper is read once into `wiki/papers/` and every thread can reference it
- `decisions/` ADRs + `meta/reviews/` preserve the "why we made this change" trail six months later
- Open-sourceable (after stripping project-specific content, the L1+L2 framework is a generic template)

### Negative

- Migration in three waves (B/C still take time); during the transition, knowledge lives partly on the external platform and partly locally — dual sources
- Windows limitation: `mklink /J` does not support UNC paths; project mounting may need to degrade to a `_LINK.md` placeholder
- Cost of deciding "what goes at which layer": default to L2; demote to L3 once you confirm only one project uses it

### Neutral / Things to Monitor

- Monitor the frequency of explicit empty `wiki_touches: []` declarations — high frequency suggests the dual-primary split is confusing
- Monitor the friction backlog growth rate — >15/week without review means the self-evolving mechanism is being ignored
- Monitor L2's genericness — if an L2 rule is repeatedly overridden by L3 projects, it should be demoted to L3

## Follow-ups

- [x] **Wave A**: build the skeleton + migrate generic assets (code-walkthrough, research-and-reporting, figure-style-guidelines) + migrate cross-project memory + write HANDOFF.md + write this ADR
- [x] **Wave B**: pull essentials from the external platform → build first batch of threads under `projects/<name>/tracks/<track>/<thread>/`
- [x] **Wave C**: incrementally split the wiki while reading Survey docs → `wiki/papers/` + `wiki/concepts/` (initial target: 10 core papers + 5 core concepts)
- [x] **Wave D**: rewrite existing skills per Anthropic's three-layer spec
- [ ] Implement `/wiki-lint` (bidirectional link sync, orphan check, stale check)
- [ ] Implement `/session-end` (grep frictions → append to backlog)
- [ ] Implement `/meta-review` (weekly batch process the backlog)

## References

- Inspiration for Dual-Primary + five stages + Self-Evolving: the maintainer's earlier internal scaffold prototype (private refs, unpublished)
- Inspiration for the skill three-layer spec: Anthropic skill-creator official documentation
- Layering decision driver: the maintainer's 30+ accumulated feedback memory entries, where session-boundary / collaboration-mode / documentation should rise to L2, while project-specific data formats / inference parameters should stay at L3
