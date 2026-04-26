---
adr_id: ADR-0004
title: External learning sources (blogs / GitHub notes) + skills/own vs upstream split
status: accepted
date: 2026-04-25
author: Hauser Zhang + Claude
supersedes: []
superseded_by: []
---

# ADR-0004 · External learning sources + skills own/upstream split

> **TL;DR**: External blog / GitHub notes do not get a new subdirectory under `wiki/`. They flow through the existing `raw/clippings/` → `learning/<slug>.md` → (optional) `wiki/syntheses/<theme>.md` pipeline. Meanwhile `.claude/skills/` is split into `own/` (originals) vs `upstream/` (mirrored from external sources). Every mirrored skill carries a required `_UPSTREAM.md` recording source, commit, and license.

## Context

After v1.1 closed out + first pass of open-source polishing, the user asked two adjacent but independent questions:

1. **"I regularly read blogs and GitHub notes from top researchers (e.g. Karpathy). Where do these go in our architecture? Should we add `wiki/blogs/`?"**
2. **"Third-party skills like `superpowers` and `forrestchang/andrej-karpathy-skills` — I want to bundle them into our repo so `git clone` users can use them immediately. How should `.claude/skills/` be organised?"**

Both questions concern "when external content enters our OS, how do we classify it, preserve attribution, and keep it from polluting originals?" They fold into one ADR.

### On question 1

The current Dual-Primary architecture has:
- `raw/` for immutable external sources (PDF / HTML clippings)
- `wiki/papers/` for **academic papers** (author / year / venue / DOI)
- `wiki/concepts/` for cross-thread **technical concepts**
- `wiki/syntheses/` for **arguments synthesised across multiple sources**
- `learning/` for **non-task-driven reading**

Blogs / GitHub notes like karpathy's share these features:
- No venue / DOI / peer review (≠ paper)
- Content is often **a guideline / an opinion / a curated experience** (possibly combining multiple concepts)
- Cross-project reference is useful, but author authority and citability are weaker than a paper

### On question 2

Reference repositories observed:
- [`forrestchang/andrej-karpathy-skills`](https://github.com/forrestchang/andrej-karpathy-skills) turns Karpathy's X-post observations into a Claude Code skill (MIT license)
- [`obra/superpowers`](https://github.com/obra/superpowers) is a mature skill library (MIT) by Jesse Vincent, including brainstorming / systematic-debugging / test-driven-development
- [`multica-ai/multica`](https://github.com/multica-ai/multica) uses a `skills-lock.json` mechanism to reference external skills (analogous to `package-lock.json`)

If we just drop external skills into `.claude/skills/`:
- Attribution gets lost (is open-sourcing compliant? how does a fork know whom to thank?)
- Originals and mirrored content get mixed, blurring the maintenance boundary
- No mechanism to sync with upstream updates

## Options

### On question 1

**Q1-A**: add a new `wiki/blogs/` subdirectory
- Pros: direct path
- Cons: blogs and papers differ by an order of magnitude in authority; putting them in the same layer mis-guides Claude's citation judgement. `learning/` already exists for non-task-driven reading; adding another layer is redundant.

**Q1-B**: reuse the existing `raw/clippings/` + `learning/` + `wiki/syntheses/` three-stage pipeline (**this ADR's choice**)
- Pros: zero new directories; each content type has a natural home; if a blog leads to a cross-thread thesis it naturally lands in `wiki/syntheses/`
- Cons: first-time users need to understand the three-stage pipeline (but 5 minutes with `learning/_index.md` makes it clear)

**Q1-C**: blogs go directly into `wiki/papers/` with `type: blog-post` in the frontmatter
- Pros: unified index
- Cons: confuses academic and blog citations; violates `papers/`'s semantic boundary

### On question 2

**Q2-A**: flat `.claude/skills/`, distinguish by filename prefix (`ours-code-walkthrough/` / `upstream-karpathy-guidelines/`)
- Pros: no extra directory nesting
- Cons: source not visible at a glance; newcomers can't tell which are "mine to modify" vs "mirror, do not touch"

**Q2-B**: `.claude/skills/{own, upstream}/` two subdirectories (**this ADR's choice**)
- Pros: source obvious at a glance; `own/` is freely modifiable, `upstream/` has a mirror contract; open-source license obligations are clear
- Cons: one extra directory layer (but only two fixed subdirs, not N)

**Q2-C**: `skills-lock.json` mechanism like Multica (no full mirror, just URL + commit hash, fetched on demand)
- Pros: small repo footprint; upstream update = change the hash
- Cons: requires a `/update-skills` command; `git clone` users need a sync step before using; violates the "git clone and go" promise
- **Decision**: short term (upstream skills < 10), use B (physical mirror); long term, upgrade to C when needed

**Q2-D**: git submodule for upstream skill repos
- Pros: native git mechanism
- Cons: submodules are `git clone`-unfriendly, easy to forget; >2 becomes painful

## Decision

- **Q1 → choose B**: blogs / GitHub notes flow through `raw/clippings/` → `learning/<slug>.md` → (optional) `wiki/syntheses/<theme>.md`. Do not add `wiki/blogs/`.
- **Q2 → choose B**: `.claude/skills/{own, upstream}/`. Every upstream skill carries a required `_UPSTREAM.md`.

## Rationale

### Q1: why no `wiki/blogs/`

1. **Authority gap**: papers have peer review, DOIs, traceable publication dates. Blogs are one person's opinion; Claude citing a blog as "factual basis" will be challenged by any serious reviewer. Placing them in the same layer (`wiki/papers/` alongside `wiki/blogs/`) would cause Claude to treat the two as equally weighted during a survey — that's wrong.
2. **`learning/` already covers this**: ADR-0001 defined `learning/` as the "non-task-driven reading" entry point; blogs land there perfectly. They are not a wiki sub-direction but a wiki upstream — first digested in `learning/`, then (only if cross-source theses emerge) upgraded to `wiki/syntheses/`.
3. **`wiki/syntheses/` is the correct exit**: Karpathy's "LLM coding pitfalls" observation, in its truly reusable form, is "systemic biases of LLMs in coding tasks" — an argument synthesised across multiple sources (Karpathy X post + analogous Simon Willison / Sourcegraph blogs + your own scars). That's classic `wiki/syntheses/` material.

### Q2: why `own/` vs `upstream/` + required `_UPSTREAM.md`

1. **License compliance**: open-sourcing third-party content must preserve license / attribution. `_UPSTREAM.md` recording source URL / commit hash / license is a prerequisite for MIT-compatible distribution.
2. **Clean maintenance boundary**: `own/` is modifiable at will; `upstream/`'s SKILL.md stays as-is (except for necessary path fixes), with local changes logged in `_UPSTREAM.md`'s "Local modifications" section so future upstream pulls don't produce merge chaos.
3. **Batteries-included promise**: `git clone` immediately yields a ready-to-use skill set, honouring the "Batteries Included" promise in [README.md]; no `/update-skills` prerequisite.
4. **Future-proof**: when upstream skills exceed 10, upgrade to `skills-lock.json` — at that point only the `upstream/` directory changes, `own/` stays untouched.

## Consequences

### Positive

- External blogs / GitHub notes have a clear home (`raw/clippings/` + `learning/`) without polluting the wiki
- The skill directory makes "originals vs community" obvious at first glance
- Every upstream skill ships with compliance metadata; open-source license obligations are explicit
- Extension points reserved (`skills-lock.json` / more upstream)

### Negative

- Mirroring each upstream skill requires an additional `_UPSTREAM.md` (~10 lines)
- `_catalog.md` needs manual maintenance (until a lint tool auto-generates it)

### Neutral / Things to Monitor

- When `upstream/` content exceeds 10 skills: consider upgrading to `skills-lock.json`
- If an upstream skill has had no updates for 3 months and the upstream is archived: mark `status: archived` in its `_UPSTREAM.md`

## `_UPSTREAM.md` contract

Every `upstream/<skill>/_UPSTREAM.md` must contain:

```markdown
---
upstream_url: <https://github.com/owner/repo>
upstream_path: <path/in/repo/to/skill>   # e.g. skills/karpathy-guidelines
commit: <git-sha>
fetched: YYYY-MM-DD
license: MIT | Apache-2.0 | ...
license_compatible_with_mit: true | false
---

# Upstream: <skill-name>

## Source
- Upstream: <repo URL + link to the exact path/SKILL.md at commit>
- Author(s): <authors>
- License: <e.g. MIT>
- Fetched on: <date>

## Why we mirror
<1–3 sentences on why we pull this skill in>

## Local modifications
- none  # or a diff summary

## Attribution
<original copyright notice + thanks to authors>
```

A skill with `license_compatible_with_mit: false` **must not** be mirrored (this repo's LICENSE is MIT).

## Follow-ups

- [x] Move `.claude/skills/code-walkthrough/` → `.claude/skills/own/code-walkthrough/`
- [x] Mirror the first batch of 4 upstream skills (karpathy-guidelines + superpowers brainstorming / systematic-debugging / test-driven-development)
- [x] Build `.claude/skills/_catalog.md` index
- [x] Tweak `CLAUDE.md` §2 (clarify the learning / raw / syntheses split)
- [x] Expand `learning/_index.md` with the "external blog / GitHub notes workflow" section
- [x] Link README's "Batteries Included" section to `_catalog.md`
- [ ] (Long term) implement `/update-upstream-skill <name>`: pull the latest upstream per `_UPSTREAM.md`'s URL + commit and show a diff
- [ ] (Long term) implement the `skills-lock.json` approach (when upstream > 10)

## References

- ADR-0001 — defines the `learning/` / `raw/` / `wiki/{papers,concepts,syntheses}` division of labour
- ADR-0003 — open-source split (this ADR continues the "batteries included, skeleton tracked" spirit)
- [`forrestchang/andrej-karpathy-skills`](https://github.com/forrestchang/andrej-karpathy-skills) — first upstream sample
- [`obra/superpowers`](https://github.com/obra/superpowers) v5.0.7 — second upstream source
- [`multica-ai/multica`](https://github.com/multica-ai/multica) — reference for the `skills-lock.json` approach
