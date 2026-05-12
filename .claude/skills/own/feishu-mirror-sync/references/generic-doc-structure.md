# Generic Feishu Mirror Structure

Use this reference when creating or normalizing `projects/<name>/.claude/rules/feishu-doc-structure.md`.

The goal is to make every project Feishu mirror predictable without leaking one project's domain, tokens, or naming assumptions into the global skill.

## Required Sections

Each project L3 Feishu rule should contain these sections:

1. `Root`
   - Feishu project root URL / wiki token.
   - One sentence describing the root page's job.

2. `Required Tree`
   - Canonical wiki hierarchy.
   - Short sidebar labels with optional type icons.
   - Explicit rule that full document titles live inside page H1, not necessarily in sidebar labels.

3. `Current Node Tokens`
   - Table with `role`, `title`, `wiki node token`, and object token (`doc token`, `base token`, etc.).
   - Include every stable node that future sync tasks may touch.

4. `Local Source Mapping`
   - Table mapping local authoritative files to Feishu targets.
   - Make it clear whether a target is a wiki doc, Base, Sheet, or other object.

5. `Update Rules`
   - Project-specific update requirements that supplement L2 Feishu rules.
   - Must include comment snapshot / restore requirement for structural updates.

6. `Page Type Icons`
   - Project-specific icon table based on the default icon contract below.
   - If the CLI cannot set native page icons, use title prefix icons as the automated fallback.

7. `Layout Rules`
   - Project-specific decisions about where dashboards, references, appendices, and large tables belong.

8. `Lessons`
   - Date-stamped pitfalls discovered during real sync work.
   - Only project-specific lessons go here; cross-project lessons belong in `.claude/rules/platforms/feishu.md` or this skill.

## Required Tree Pattern

Default Research OS project mirrors should use this shape unless the project has a clear reason to diverge:

```text
<Project Root>
├── <Track Page>
│   └── <Thread Page>
│       ├── <Phase Page>
│       ├── <Phase Page>
│       └── <Phase Page>
├── <Project-Level Page>
├── <Project-Level Page>
└── <Reference Index>
    ├── <Database / Structured Index>
    ├── <Route / Category Page>
    ├── <Route / Category Page>
    └── <Item Page or nested item pages>
```

Rules:

- Root is a dashboard, not a dumping ground.
- Track pages group long-running research/work areas.
- Thread pages group one coherent line of work under a track.
- Phase pages mirror phase files such as brainstorm, survey, proposal, implementation, experiments, or writeup.
- Project-level pages hold cross-thread material such as ideas, plans, meeting notes, or decisions.
- Reference indexes organize reusable sources; large reference tables should live in Base or another structured object.
- Historical routes may be retained, but they should be clearly marked as historical/parked and moved below the current mainline.

## Sidebar Title vs Page H1

Use a two-layer naming convention:

- Sidebar title: short, stable, navigational label.
- Page H1: full human-readable title from the local source.

Examples:

| Page role | Sidebar title pattern | Page H1 pattern |
|---|---|---|
| Track | `<icon> [Track] <slug>` | Full track name |
| Thread | `<icon> [Thread] <slug>` | Full thread name |
| Phase | `<icon> [NN-Phase]` | Full local Markdown H1 |
| Project page | `<icon> [Ideas] Inbox` / `<icon> [Plan] Project Plan` | Full page title |
| Reference | `<icon> [Reference] <name>` | Full reference index title |
| Database | `<icon> [Database] <name>` | Usually Feishu object title |
| Route / Category | `<icon> [Route] <name>` | Full route/category title |
| Item page | `<icon> <short item title>` | Full item title |

## Default Page Type Icons

Projects may override these, but should keep the same role semantics:

| Page type | Default icon | Pattern |
|---|---:|---|
| Project root | `🧠` | `<icon> <Project Name>` |
| Track | `🧭` | `<icon> [Track] <track>` |
| Thread | `🧵` | `<icon> [Thread] <thread>` |
| Brainstorm phase | `💭` | `<icon> [00-Brainstorm]` |
| Survey phase | `🔎` | `<icon> [01-Survey]` |
| Proposal phase | `📝` | `<icon> [02-Proposal]` |
| Implementation phase | `🛠️` | `<icon> [03-Implementation]` |
| Experiment phase | `🧪` | `<icon> [04-Experiments]` |
| Results / writeup phase | `📈` | `<icon> [05-Results]` or `<icon> [Writeup]` |
| Ideas | `💡` | `<icon> [Ideas] Inbox` |
| Plan | `📅` | `<icon> [Plan] Project Plan` |
| Decision log | `⚖️` | `<icon> [Decisions]` |
| Meeting notes | `🗣️` | `<icon> [Meetings]` |
| Reference index | `📚` | `<icon> [Reference] <name>` |
| Database / Base | `🗂️` | `<icon> [Database] <name>` |
| Route / Category | `🛣️` | `<icon> [Route] <route>` |
| Item page | `📄` | `<icon> <short item title>` |

## Layout Contract

- First screen should show current status, current mainline, and next actions.
- Metadata should be a human-readable table, not raw YAML frontmatter.
- Linked evidence, mirror audit details, local/Feishu dual paths, and long provenance tables should go at the end as `Appendix`.
- Ordinary Doc tables should be 2-3 columns where possible. Use short link labels instead of naked URLs.
- Large indexes, paper/source catalogs, task matrices, and status tables should use Base or Sheets rather than wide Doc tables.
- After any overwrite, patch the sidebar title and verify child-node titles because Feishu may reset the title from the first H1.
- Never run multiple write operations against the same document in parallel.

## Comment Preservation Contract

Project L3 rules should restate this in their own `Update Rules`:

- Before structural edits, snapshot all comments for each affected docx.
- After editing, list comments again and compare.
- Restore missing comments only when the old quote or a clear new block still exists.
- Do not restore comments whose anchored content was intentionally removed.
- Do not duplicate comments that survived the update.

## L3 Rule Skeleton

````markdown
# <project-name> — Feishu Mirror Structure

> This is the project L3 Feishu mirror rule. L2 rules live in `.claude/rules/platforms/feishu.md`; the reusable workflow lives in `.claude/skills/own/feishu-mirror-sync/SKILL.md`.

## Root

<root wiki URL>
<root title>

Root page role:
- Project overview
- Current status
- Key pages
- Next actions
- Update log

## Required Tree

```text
<tree>
```

## Current Node Tokens

| Role | Title | Wiki node token | Object token |
|---|---|---|---|
| project root | `<title>` | `<wiki_token>` | `<doc_or_object_token>` |

## Local Source Mapping

| Local path | Feishu target |
|---|---|
| `<path>` | `<target>` |

## Update Rules

- Read this file plus L2 Feishu rules before syncing.
- Use `feishu-mirror-sync` for project mirror work.
- Snapshot comments before structural updates.

## Page Type Icons

| Page type | Title icon | Pattern |
|---|---:|---|

## Layout Rules

- Current mainline first; provenance later.
- Long indexes go to Base / Sheets.

## Lessons

### <YYYY-MM-DD>

- <lesson>
````
