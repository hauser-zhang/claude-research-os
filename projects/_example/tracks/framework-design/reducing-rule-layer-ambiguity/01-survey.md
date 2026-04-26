---
stage: 01-survey
thread: reducing-rule-layer-ambiguity
track: framework-design
agency: autonomous
status: accepted
started: 2026-04-26
accepted: 2026-04-26
---

# 01 · Survey

## Scope

Three tools that face an analogous "shared-default + project-override" problem. Each gets a short entry with the mechanism, the trade-off, and a verdict on whether the pattern transfers to Research OS.

## Comparison table

| Tool | Mechanism | User friction | Transfers to Research OS? |
|------|-----------|---------------|--------------------------|
| shadcn/ui | `components.json` at repo root + component files copied into `src/` | Low. Components live in one place; config in another. No layering confusion. | ⚠️ Partial — works because components are unambiguously "project-owned". Our rules are not. |
| ESLint shared-configs | `extends:` chain from a shared package, local rules override by name | Medium. Debugging "why is this rule active" requires walking the extends chain. | ❌ No — relies on a named-rule system we don't have. |
| Anthropic skill-creator's `references/` | `SKILL.md` for narrative, `references/*.md` for volatile detail loaded on-demand | Low. Clear responsibility per file. | ✅ Yes — matches the "partition by stability" logic we want. |

## Detailed entries

### shadcn/ui config layering

**Mechanism.** `components.json` sits at the repo root and captures project-wide choices (Tailwind path, aliases, style). Individual component files are copied into the project's `src/components/ui/` on demand via the CLI. There is no "shared shadcn" package imported from node_modules — each project owns its copy.

**Relevance.** The pattern is "one config at the root + per-item files in a known place". In Research OS terms this is "one `CLAUDE.md` at L2 + one `CLAUDE.md` per project at L3" — which is already what we do. shadcn's choice to **not** share component code across projects was deliberate; they accept duplication to kill ambiguity.

**Verdict.** Validates our three-scope decision. Does not tell us how to handle *mixed* rules.

### ESLint shared-configs

**Mechanism.** A parent config (e.g. `eslint-config-next`) is imported via `extends:`. Local rules in the project config override by name. The effective rule set is the cascade of all configs in the chain.

**Relevance.** Closest analogue to our L2/L3 cascade. Rule overrides work because every rule has a stable unique name and a known shape (`{level, options}`).

**Why it does **not** transfer.** Our rules are prose markdown, not named config entries. There is no `override` semantics — a project-level `.claude/rules/ssh-servers.md` is just a separate file that loads alongside `.claude/rules/ssh-general.md`. Attempting to build a named-override layer on top of markdown would require a custom loader that Claude Code does not have.

**Verdict.** Informs the downside of Candidate B from Brainstorm (the "override" pattern): its ergonomics depend on tooling we lack.

### Anthropic skill-creator's `references/`

**Mechanism.** Each skill has a single `SKILL.md` with the narrative (stable, < 500 lines) and a `references/` subdirectory with fast-changing operational details (paths, known issues, parameter tables). SKILL.md loads always; references load on demand via the Skill tool.

**Relevance.** Perfect analogy for **stable vs volatile** content partitioning. "General SSH conventions" are stable and go in the main rule file; "this project's specific server + paths" are volatile and go in a separate file.

**Verdict.** Strongest transfer. The Skill three-layer spec's partitioning rule (`description` / `SKILL.md` / `references`) is exactly the discipline we need for rules: **one narrative file + one detail file, split by volatility**.

## Citations

None of the above required three-step citation verification since they are all tool documentation that this survey reads directly:

- shadcn/ui: <https://ui.shadcn.com/docs/installation>
- ESLint shared-configs: <https://eslint.org/docs/latest/use/configure/configuration-files#extending-configuration-files>
- Anthropic skill-creator: <https://docs.anthropic.com/en/docs/claude-code>

## Conclusion

The pattern we want is **partition by volatility**, the same logic Anthropic already used for Skills. Stable generic shape goes in an L2 rule file; project-specific volatile detail goes in an L3 rule file. The two files are discovered by Claude Code's cascading load automatically.

This validates Candidate D from Brainstorm. Candidate B (override-style) is rejected because our substrate is prose, not named config entries.

**Open question for Proposal stage**: what naming convention makes the two halves obviously related? (See Brainstorm self-poke hole 3.)

## Next stage

`02-proposal.md`: define the concrete naming convention + frontmatter cross-link + when this partitioning is **not** worth doing (small projects with only 1–2 rules).
