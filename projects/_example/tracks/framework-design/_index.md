# Track: framework-design

> Research direction: **how should the L2 framework skeleton itself be shaped so it remains useful as the number of projects grows?**

---

## Why this direction

The L2 skeleton (CLAUDE.md + rules + skills + decisions/) is the part users inherit on every new project. Its design choices propagate multiplicatively: one small ambiguity in how L2 rules interact with L3 rules becomes N frictions once N projects exist. This track investigates those framework-level design questions.

---

## Success criteria

- Every framework-level design decision is captured in an ADR under `decisions/`
- No L2 rule is ambiguous enough to require a separate "when to follow me" doc
- First-time users bootstrap a new project in < 30 minutes (measured informally via friction logs)

---

## Threads

| Thread | Status | Started | Lead question |
|--------|--------|---------|---------------|
| [reducing-rule-layer-ambiguity](reducing-rule-layer-ambiguity/) | 01 Survey done | 2026-04-26 | How should rules that "mostly apply everywhere but have edge cases" be organised? |

---

## Cross-links

- Related ADRs: [ADR-0001](../../../../decisions/ADR-0001-research-os-architecture.md) (three-scope cascade), [ADR-0003](../../../../decisions/ADR-0003-open-source-split.md) (L2 vs L3 split)
- Related L2 rules: [`.claude/rules/research-and-reporting.md`](../../../../.claude/rules/research-and-reporting.md)
