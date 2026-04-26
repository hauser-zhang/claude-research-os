---
thread: reducing-rule-layer-ambiguity
track: framework-design
wiki_touches: []
status:
  00-brainstorm: done
  01-survey: accepted
  02-proposal: pending
  03-implement: pending
  04-experiment: pending
started: 2026-04-26
---

# Thread: reducing-rule-layer-ambiguity

**Lead question:** How should rules that "mostly apply to every project but have a project-specific edge case" be organised so users don't have to reverse-engineer where they belong?

## Current status

- **00 Brainstorm**: `done` — five candidates evaluated; decision recorded in the Brainstorm doc
- **01 Survey**: `accepted` — comparative survey of three existing rule-layering patterns in related tools
- **02 Proposal**: not yet started — pending user instruction

## Why this matters

Rule layering is the user-facing manifestation of the L2/L3 cascade. If a user can't decide at a glance "where does this rule go?", they either duplicate or omit, and both paths leak into cross-project noise within a few weeks.

## Wiki touches

`wiki_touches: []` is currently empty — this thread has not cited any wiki entities yet. If the Proposal stage references specific concepts (e.g. "Pareto front", "rule hoisting"), add slugs here and create the corresponding `wiki/concepts/` pages.
