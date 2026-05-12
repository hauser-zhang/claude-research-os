---
name: feishu-mirror-sync
description: Stable Research OS workflow for syncing local Markdown/repo sources to Feishu Wiki/Doc/Base mirrors while preserving page structure, titles/icons, readable tables, cross-links, media, and existing user comments. Use when updating Feishu pages from local repo files, rebuilding project dashboards, reference indexes, database-backed views, or phase/thread docs.
---

# Feishu Mirror Sync

Use this skill whenever a local Research OS source (`projects/**`, `wiki/**`, `writing/**`, or other repo-owned Markdown) needs to be reflected into Feishu Wiki / Docs / Base.

This is a **global workflow skill**. It must stay project-neutral: no hard-coded project names, Feishu tokens, page titles, paper routes, or domain-specific assumptions belong here. Concrete mappings live in project L3 rules.

## Required References

Read these before touching Feishu:

- `.claude/rules/writing-and-archival.md` for source-of-truth and archival rules.
- `.claude/rules/platforms/feishu.md` for L2 Feishu rules, especially comment preservation.
- `projects/<name>/.claude/rules/feishu-doc-structure.md` when the task is project-bound; this is the project adapter for node tree, titles, icons, source mapping, and token mapping.
- `references/generic-doc-structure.md` when creating or normalizing a project L3 Feishu structure rule.
- Relevant lark skills: `lark-shared`, `lark-doc`, `lark-drive`, `lark-wiki`; add `lark-base` when a Feishu Base / database-backed index is involved.

## Layering Contract

- **L1 / L2 rules** define durable Research OS principles: local source of truth, archival behavior, Feishu safety rules, and comment protection.
- **This skill** defines the reusable execution workflow: preflight, comment snapshot, safe update method, rendering conventions, title/icon verification, and postflight checks.
- **Project L3 rules** define concrete Feishu topology: wiki node tokens, doc/base tokens, parent-child structure, page type labels, project-specific icon choices, and local-source mapping.
- If an L3 rule exists, follow it for all concrete decisions. If it is missing, create or update it before doing broad sync work.
- Do not copy project-specific tokens or page lists into this skill. When a lesson is project-specific, write it to the project L3 rule; when it generalizes across projects, write it to `.claude/rules/platforms/feishu.md` or this skill.
- Project L3 rules should follow the generic section contract in `references/generic-doc-structure.md`, then specialize names, icons, routes, tokens, and local-source mappings.

## Workflow

1. **Classify the mirror target.**
   - Local Markdown remains authoritative; Feishu is the readable/collaborative mirror.
   - Identify page type from the project L3 rule, for example Project root, Track, Thread, Phase, Ideas, Plan, Reference, Route, Item page, or Base.
   - Use the L3 token map; if a token is missing, resolve wiki node first and update the L3 rule after creation.

2. **Preflight current Feishu state.**
   - Fetch outline or relevant sections with `docs +fetch --api-version v2`; avoid full fetch unless needed.
   - List child nodes with `wiki nodes list` when page structure or title might change.
   - For every docx that may be rewritten or structurally replaced, snapshot comments before updating:
     `drive file.comments list --params '{"file_token":"<doc_token>","file_type":"docx"}'`.
   - Store snapshots in `/tmp/research-os-feishu-comments/<timestamp>/`; do not commit raw comment JSON.

3. **Choose the safest update method.**
   - Prefer `str_replace`, `block_insert_after`, `block_replace`, or compact section replacement.
   - Use `overwrite` only when the user explicitly asks for a full rewrite or the page must be rebuilt into the current mainline.
   - Never run multiple write operations against the same document in parallel.

4. **Render for humans, not raw Markdown storage.**
   - Convert YAML frontmatter into a `Metadata` table.
   - Keep page H1 as the local file title, but keep Feishu sidebar title short and structural.
   - Put linked evidence, local/Feishu dual paths, and mirror audit tables at the end as `Appendix`, unless the page itself is a Reference / Index page.
   - Keep ordinary Doc tables to 2-3 columns with short link labels; put large indexes in Base.

5. **Apply titles and icons.**
   - Use project L3 title/icon patterns.
   - After `overwrite`, patch title with `drive files patch` because Feishu may reset the sidebar title to the first H1.
   - Verify with `wiki nodes list`.

6. **Restore and verify comments.**
   - After updating, list comments again.
   - If a preflight comment is still present, do nothing.
   - If a comment disappeared and its quote still exists, recreate it at the quote or block. Prefix restored text with original author/time metadata.
   - If the quoted content was intentionally removed, do not restore; report it as dropped because its anchor no longer exists.
   - Do not duplicate comments that already survived the update.

7. **Postflight checks.**
   - Fetch the edited sections and inspect titles, duplicate tables, broken links, raw URLs, and appendix placement.
   - For Base-backed indexes, verify records and Feishu page links.
   - Update the L3 rule file when new nodes, tokens, title rules, or workflow lessons are discovered.

## Hard Stops

- Do not overwrite a Feishu doc without a comment snapshot.
- Do not treat Feishu as source of truth over local Markdown unless the user explicitly says the Feishu edits are newer.
- Do not paste local YAML frontmatter as plain text into Feishu.
- Do not create duplicate paper/page tables when replacing dashboard sections.
