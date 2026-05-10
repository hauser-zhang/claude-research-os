# Contributing to claude-research-os

Thanks for your interest! This template is dogfooded daily on a real PhD workflow,
so contributions that come from real research pain are especially welcome.

## TL;DR

- **Open an issue *before* a non-trivial PR.** Template changes affect every fork — we'd rather discuss direction before you write code.
- **Structural changes need an ADR** (see [`decisions/ADR-TEMPLATE.md`](decisions/ADR-TEMPLATE.md)).
- **Commit messages: [Conventional Commits](https://www.conventionalcommits.org/), English only.**
- **Usage questions → [Discussions](https://github.com/hauser-zhang/claude-research-os/discussions),** not Issues.

---

## How to contribute

### 🐛 Reporting bugs

Use the **Bug report** issue template. The more specific your repro (which `CLAUDE.md`,
which skill, which Claude Code version), the faster it gets fixed.

### ✨ Suggesting features / template improvements

Use the **Feature request** issue template. If your suggestion changes the
shape of the template (e.g. new top-level folder, new mandatory rule), say so
explicitly — those need an ADR before implementation.

### ❓ Usage questions / sharing workflows / open-ended ideas

→ [GitHub Discussions](https://github.com/hauser-zhang/claude-research-os/discussions).
Issues are reserved for actionable bugs and concrete feature requests; Discussions
is the right place for "how do I…", "I built X on top of this", or "what do you think about Y".

### 🔧 Pull requests

1. **Open or find an issue first** for anything beyond a typo fix.
2. Fork → branch from `main` (e.g. `feat/<short-slug>` or `fix/<short-slug>`) → small focused commits.
3. Match the existing style; **don't reformat unrelated code** (see "Surgical Changes" in [CLAUDE.md §12](CLAUDE.md)).
4. Open a PR → fill out the PR template → wait for review.
5. If your change touches the three-scope cascade, dual-primary knowledge model,
   five-stage flow, or skill curation policy → propose an ADR first (see below).

---

## Commit message convention

We follow [Conventional Commits](https://www.conventionalcommits.org/), **in English**:

```
<type>(<scope>): <short description>

<optional body explaining the why, not the what>
```

### Types

| Type | Meaning | Example |
|------|---------|---------|
| `feat` | New feature, new module, new rule, new skill | `feat(skills): add own/code-walkthrough skill` |
| `fix` | Bug fix | `fix(hooks): handle missing HANDOFF.md gracefully` |
| `docs` | Documentation-only change | `docs(rules): clarify writing-and-archival §3` |
| `refactor` | Restructure without behavior change | `refactor(rules): split feishu rules from generic` |
| `test` | Test additions / changes | `test(hooks): add unit test for staleness check` |
| `chore` | Maintenance: gitignore, version bumps, repo config | `chore(gitignore): exclude private memory entries` |
| `perf` | Performance improvement | `perf(hooks): cache HANDOFF parse result` |
| `ci` | CI / GitHub Actions config | `ci: add markdown lint workflow` |

> **`chore` boundary**: if a change affects runtime behavior (new field, new flow), use `feat`/`fix`, not `chore`.

### Scope examples for this repo

`rules` · `skills` · `handoff` · `docs` · `decisions` · `projects` · `wiki` · `meta` · `hooks` · `gitignore`

### Granularity

- **One logical change = one commit.** Don't accumulate a session's work into a single mega-commit.
- Stage specific files (`git add <file>`), not `git add .`.

---

## ADR-driven structural changes

Anything that changes the **shape** of the template — not just content — needs
an Architecture Decision Record before implementation. This includes:

- Three-scope cascade (L1 / L2 / L3) — what lives where
- Dual-primary knowledge model — wiki ⇄ threads contract
- Five-stage thread flow (`00-brainstorm` → `04-experiment`)
- Skill curation policy (own/ vs upstream/, attribution, license handling)
- Self-evolving layer (frictions / meta-reviews / improvements backlog)
- Top-level folder additions or renames

**Process**:

1. Open an issue with the `feature` template, mark it `needs-adr` in the title.
2. Copy [`decisions/ADR-TEMPLATE.md`](decisions/ADR-TEMPLATE.md) to `decisions/ADR-NNNN-<slug>.md`.
3. Fill in Context / Options / Decision / Rationale / Consequences.
4. Open a PR with **just the ADR** first; once it's `accepted`, follow up with the implementation PR.

This keeps the decision trail readable for forks and future contributors.

---

## What to expect from review

- **Bug fixes**: usually merged within a few days.
- **Skeleton / template changes**: discussed in the issue first; PR review may take longer because it affects every fork.
- **New skills**: must follow the `_UPSTREAM.md` attribution contract from
  [ADR-0004](decisions/ADR-0004-learning-sources-and-skills-split.md) if mirrored from upstream.
- **Documentation**: small clarifications welcome; large rewrites should land via an issue first.

If a PR sits without response for >2 weeks, please ping in the PR thread.

---

## License

[MIT](LICENSE) © 2026 Hauser Zhang. By contributing, you agree that your contribution
is licensed under MIT and that you have the right to submit it. Upstream skills retain
their original licenses — see each skill's `_UPSTREAM.md`.
