---
name: Code Refactoring Preferences
description: Preserve originals, discuss-first workflow, .sh scripts for reproducibility, never overwrite results
type: feedback
---

When refactoring user's research code:

1. **Always create new files** — never modify original notebooks/scripts
2. **Discuss plan first** — propose refactoring structure and discuss with user before writing code; user may have specific source→target path preferences
3. **Modular package structure** — clear separation of concerns, cross-file module reorganization encouraged
4. **Style consistency** — reference existing refactored modules to maintain project-level uniformity
5. **Bash scripts mandatory** — every .py entry point needs a companion .sh script recording the full run command (conda activate, args, etc.) for reproducibility (留痕)
6. **Never overwrite original results** — refactored code outputs to new paths, preserving original result files
7. **Entry points with --skip flags** — CLI args for resumable pipelines
8. **Archive, never delete** — old code moves to `outdate/` directory for traceability, never deleted
9. **YAML config preferred** — user prefers YAML over JSON for config files (more readable, supports comments)

**Why:** User explicitly requires 留痕 (audit trail) — original code, original results, and run commands must all be traceable. User's background is research notebooks (ipynb) and values being able to trace what changed.

**How to apply:** Before any refactoring, read existing refactored modules for style reference. Propose plan in findings.md, get user confirmation, then execute. Always create .sh alongside .py.
