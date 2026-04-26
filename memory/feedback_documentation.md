---
name: Documentation Writing Standards
description: Absolute paths in docs, human-readable conventions, Chinese for skills, Feishu sub-page judgment
type: feedback
---

Rules for all documentation output (Feishu, CLAUDE.md, skill files):

1. **Absolute paths required** — always use full absolute paths in documentation; relative paths cannot be tracked or located by humans
2. **Human reading conventions** — organize by what a human reader needs, not by what's technically logical; judge what's a sub-page vs. what should be appended to the main doc
3. **Skills in Chinese** — skill content (SKILL.md, references) should use Chinese for easy user review
4. **Feishu sub-page judgment** — detailed content (refactoring records, analysis results) → create sub-page; brief updates (status changes, new links) → append to main doc's update log table
5. **Four-path sync** — architecture/paths/pipeline → remote CLAUDE.md; human-readable summaries → Feishu; project rules → .claude/rules/ + memory; user preferences → memory

6. **Visual-first layout** — all Feishu docs must start with an overview area (table or figure) so readers get the whole picture in 30 seconds; text details go after
7. **Brainstorm structure** — fixed order: mindmap → 讨论演进表（iterative derivation as table rows）→ 决策表 → 行动计划 → 文字细节. Mind maps are mandatory for Brainstorm; overview tables for all other doc types
8. **Feishu docs = distilled decisions, not conversation logs** — Brainstorm must NOT contain raw discussion prose; reduce to table rows. Numerical experiment tables → [Experimental Results]; literature → [Survey] sub-page; code snippets → [Implementation]

**Why:** User corrected that Feishu docs without absolute paths are useless for tracking; also that information-overloaded Brainstorm docs (dumping entire conversation) are unreadable. User explicitly wants: iterative reasoning preserved as table rows (not paragraphs), visual-first structure, text details after.

**How to apply:** Before writing any Feishu doc, ask: (1) Does it have an overview at the top? (2) For Brainstorm: is there a mindmap? Is the derivation process in table rows, not paragraphs? (3) Can a human reader locate every file/path? Always include absolute paths.
