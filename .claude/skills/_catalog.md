# `.claude/skills/` Catalog

> Skills that ship with Research OS. Split into **`own/`** (skills written for this repo) and **`upstream/`** (skills mirrored from the community, each with a `_UPSTREAM.md` recording origin + commit + license).
>
> See [ADR-0004](../../decisions/ADR-0004-learning-sources-and-skills-split.md) for the policy.

---

## Own — written for Research OS

| Skill | What it does | When to trigger |
|-------|--------------|-----------------|
| [code-walkthrough](own/code-walkthrough/SKILL.md) | 5-layer structured explanation of code changes | Explaining diffs / PR review / tracing cross-layer calls |
| [guided-setup](own/guided-setup/SKILL.md) | Step-by-step tool/account/token setup with lightweight conceptual teaching and verification | Configuring CLIs, OAuth, external platforms, MCP, tokens, SSH, or dev environments |

---

## Upstream — mirrored with attribution

Each upstream skill ships a `_UPSTREAM.md` recording the source URL, pinned commit, license, and local modifications (if any). License is verified MIT-compatible before mirroring.

| Skill | Source | What it does | When to trigger |
|-------|--------|--------------|-----------------|
| [karpathy-guidelines](upstream/karpathy-guidelines/SKILL.md) | [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) · MIT · [_UPSTREAM.md](upstream/karpathy-guidelines/_UPSTREAM.md) | Four anti-LLM-pitfall principles: Think Before Coding · Simplicity First · Surgical Changes · Goal-Driven Execution | Writing / reviewing / refactoring any code |
| [superpowers-brainstorming](upstream/superpowers-brainstorming/SKILL.md) | [obra/superpowers](https://github.com/obra/superpowers) v5.0.7 · MIT · [_UPSTREAM.md](upstream/superpowers-brainstorming/_UPSTREAM.md) | Forces divergent exploration of user intent + requirements + design **before** any implementation | Any creative work — a new feature, a new pipeline, a new analysis |
| [superpowers-systematic-debugging](upstream/superpowers-systematic-debugging/SKILL.md) | [obra/superpowers](https://github.com/obra/superpowers) v5.0.7 · MIT · [_UPSTREAM.md](upstream/superpowers-systematic-debugging/_UPSTREAM.md) | Hypothesis → minimal reproduction → root-cause trace, **before** any fix | Any bug / test failure / unexpected behavior |
| [superpowers-test-driven-development](upstream/superpowers-test-driven-development/SKILL.md) | [obra/superpowers](https://github.com/obra/superpowers) v5.0.7 · MIT · [_UPSTREAM.md](upstream/superpowers-test-driven-development/_UPSTREAM.md) | Write tests first — fail, then make them pass. Covers testing anti-patterns. | Any new feature or bugfix, before writing implementation code |

---

## Adding a new skill

### Own skill

1. `mkdir -p .claude/skills/own/<slug>/` (+ `references/` / `scripts/` as needed)
2. Write `SKILL.md` following the [Anthropic skill-creator three-layer spec](https://docs.anthropic.com/en/docs/claude-code) — trigger description in frontmatter, narrative < 500 lines in body, volatile detail in `references/`
3. Add a row to the "Own" table above

### Upstream mirror

1. Verify upstream license is MIT-compatible (MIT / Apache-2.0 / BSD / ISC). If not, **do not mirror** — link to upstream from `learning/_index.md` instead.
2. `mkdir -p .claude/skills/upstream/<slug>/`
3. Copy the skill files byte-for-byte from the upstream commit
4. Write `_UPSTREAM.md` per the template in [ADR-0004](../../decisions/ADR-0004-learning-sources-and-skills-split.md#_upstreammd-contract)
5. Add a row to the "Upstream" table above

### Principle

- **Don't vendor code you don't credit.** Every `upstream/` skill must have `_UPSTREAM.md`.
- **Don't modify upstream skills in place.** If you need local changes, record them in `_UPSTREAM.md`'s "Local modifications" section; prefer forking to `own/` and rewriting if the change is substantial.
- **Community skills matter.** If an `upstream/` skill proves useful long-term, star / sponsor / contribute back to the original repo.
