# projects/ — project mount point

> Every research project lives in a subdirectory here. Per the three-scope architecture (see the repo-root `CLAUDE.md` §1), project-specific charter / remote environment / active threads / wave migration state all live **inside the project subdirectory**, never polluting the L2 skeleton.

---

## Mounted projects

| Name | Type | Tracked in git? |
|------|------|-----------------|
| [`_example/`](_example/) | **Reference project** (meta — research about Research OS itself) | ✅ Yes — shipped for every user |

The open-source template ships with `_example/` as a read-only reference you can point Claude at when bootstrapping your own project. Do not build on top of `_example/`; copy from it into your own `projects/<your-name>/`. See [`_example/HOW-TO-USE-THIS-EXAMPLE.md`](_example/HOW-TO-USE-THIS-EXAMPLE.md).

> **Naming convention**: project directories starting with an underscore (`_example/`, `_template-*/`) are treated as **read-only reference skeletons** — the HANDOFF staleness hooks ([`.claude/hooks/handoff-staleness-check.py`](../.claude/hooks/handoff-staleness-check.py), [`handoff-stop-reminder.py`](../.claude/hooks/handoff-stop-reminder.py)) skip them so they don't generate false-positive "thread inventory stale" warnings. Use a normal name (no leading `_`) for your own active projects.

The maintainer also mounts a private first-class project here; that directory is gitignored and never reaches the open-source repo.

---

## AI-assisted bootstrap (recommended)

After `git clone`, open Claude Code in the repo root and paste:

> Please read `.claude/HANDOFF.md`, `CLAUDE.md`, this `projects/README.md`, and `projects/_example/` thoroughly. Then use the `superpowers-brainstorming` skill to help me create `projects/<my-project-slug>/` for my actual research project — explore the project goals, track partition, baseline, and remote environment before generating any files. Use `projects/_example/` as the shape reference.

Claude will run through brainstorming with you (research question → tracks → baseline → remote environment), then generate the skeleton under `projects/<my-project-slug>/` by cross-referencing `_example/` for shape and the conventions below for naming / frontmatter / structure.

The manual path is documented below for offline use.

---

## New-project guide

### 1. Minimum skeleton

```bash
cd projects/
mkdir -p <name>/{.claude/rules,.claude/skills,tracks}
cd <name>

# required files
touch CLAUDE.md           # L3 project charter (static)
touch README.md           # project overview (TL;DR + tracks + key numbers)
touch IDEAS.md            # idea inbox
touch .claude/HANDOFF.md  # session entry (dynamic active threads)
```

### 2. L3 `<name>/CLAUDE.md` template (charter)

Recommended sections:

- `## 1. Project definition`: current baseline, ongoing training runs, paper-chapter mapping
- `## 2. Track navigation`: list of tracks + sub-task counts + status
- `## 3. Remote servers`: host / code directory / conda env / GPU / required env vars
- `## 4. External platforms`: main doc IDs and links for Feishu / Notion / Confluence
- `## 5. L3 project-specific rules`: list rule files under `.claude/rules/`
- `## 6. L3 project-specific skills`: list skills under `.claude/skills/`
- `## 7. Quick-reference rules`: project-specific reminders arranged by trigger scenario
- `## 8. Migration progress`: wave status table + historical context

### 3. L3 `.claude/HANDOFF.md` template (session entry)

- `## 1. Active threads` (updated every session)
- `## 2. Next-step candidates` (added / dropped during discussion)
- `## 3. Task-mode dispatcher` (per-project A/B/C/... task dispatch)

### 4. Mounting tracks

Per [ADR-0002 · Tracks and IDEAS Inbox](../decisions/ADR-0002-tracks-and-ideas-inbox.md):

```bash
mkdir -p tracks/<track-name>/
touch tracks/<track-name>/_index.md  # this track's why + success criteria + sub-task table
```

Each track contains one or more threads; each thread runs through the [five-stage flow](../CLAUDE.md#3-五阶段研究流程).

### 5. Naming conventions

- **File / directory names**: lowercase + hyphen (`edge-feature-arch/`, `01-survey.md`, `author-year-keyword.md`)
- **Proper nouns keep original casing**: project names use whatever case the author prefers
- **Thread phase files**: `00-brainstorm.md` / `01-survey.md` / `02-proposal.md` / `03-implement.md` / `04-experiment.md` / `05-writing-material.md`
- **Frictions**: every thread has its own `frictions.md`
- **Results**: every thread has a `results/` subdirectory (**always `.gitignore`d**, for experiment outputs)

### 6. Cascading-load mechanism

Claude Code walks upward from cwd looking for `CLAUDE.md`. When you `cd projects/<name>/`:

1. L2 repo-root `CLAUDE.md` loads first (skeleton)
2. L3 `projects/<name>/CLAUDE.md` loads next (project charter)
3. `.claude/HANDOFF.md` tells Claude how to start a new session
4. `.claude/rules/` and `.claude/skills/` load on demand

If you want a project-level `CLAUDE.md` to load, place it at `projects/<name>/CLAUDE.md` (**not** `.claude/CLAUDE.md` — the latter is not auto-loaded).

---

## Project vs L2 vs L1 — where does content belong?

| Content | Lives at |
|---------|----------|
| Project definition / baseline / paper-chapter mapping | L3 `CLAUDE.md` |
| Project remote servers / conda / GPU | L3 `CLAUDE.md` §3 + `.claude/rules/remote-server-operations.md` |
| External-platform (Feishu etc.) main doc tokens | L3 `CLAUDE.md` §4 |
| Project tracks / threads directory structure | L3 `tracks/<track>/<thread>/` |
| Project-specific data-format usage notes | L3 `.claude/rules/<data-format>.md` |
| Project-specific skills (pipeline / case-study analysis etc.) | L3 `.claude/skills/<skill>/` |
| **Cross-project** academic writing / citation verification / figure style | L2 `.claude/rules/` |
| **Cross-project** code walkthrough / generic workflow skills | L2 `.claude/skills/` |
| **Cross-domain** Python style / git / testing | L1 `~/.claude/` |

**Rule of thumb**: unsure? Put it at L2. If you later find only one project uses it, demote to L3.

---

## Open-source users: first-time setup

1. `git clone` this repo
2. Read `CLAUDE.md` (L2 skeleton) + `.claude/HANDOFF.md` (universal dispatcher) + `decisions/ADR-000{1,2,3,4}.md` (architectural decisions)
3. Create your first project under `projects/` using the new-project guide above
4. Tell Claude: **"Please start by reading `projects/<your-project>/.claude/HANDOFF.md`."**

A future `_example/` demo skeleton (planned) will ship anonymised reference content here.
