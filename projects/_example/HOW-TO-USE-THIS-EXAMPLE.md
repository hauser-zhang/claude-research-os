# How to use this example

> **Read this file first.** It explains what `_example/` is and how to use it to bootstrap your own project.

---

## What `_example/` is

A **read-only reference project** shipped with `claude-research-os` so you can see what a real L3 project looks like. Every file here mirrors what you would write for your own project.

**Do not build on top of `_example/`.** Copy-paste from it into your own `projects/<your-name>/` directory. `_example/` should stay untouched so newcomers always see the canonical shape.

---

## What this example is about

The example is a **meta-project**: it uses Research OS to do research *about improving Research OS itself*. That choice is deliberate:

- **Zero domain assumptions.** You do not need to be a biologist / ML researcher / economist to read the example — everybody shares the subject matter
- **Each document is doubly useful.** It demonstrates what a phase document looks like *and* its content is genuine reflection on how this template can improve
- **No domain-lock-in risk.** If the example were "protein structure prediction", users would unconsciously copy tracks and thread names. A meta-project has no tempting content to copy

---

## What's inside

```
_example/
├── HOW-TO-USE-THIS-EXAMPLE.md         ← this file (NOT a template; delete it when you copy)
├── README.md                          ← project overview (TEMPLATE)
├── CLAUDE.md                          ← L3 charter (TEMPLATE)
├── IDEAS.md                           ← idea inbox (TEMPLATE)
├── .claude/
│   ├── HANDOFF.md                     ← session entry (TEMPLATE)
│   ├── rules/                         ← project-specific rules (empty in this example)
│   └── skills/                        ← project-specific skills (empty in this example)
└── tracks/
    ├── framework-design/
    │   ├── _index.md                  ← track: why + success criteria + sub-tasks
    │   └── reducing-rule-layer-ambiguity/
    │       ├── README.md              ← thread overview + wiki_touches frontmatter
    │       ├── 00-brainstorm.md       ← FILLED with real content (what "done" looks like)
    │       ├── 01-survey.md           ← FILLED
    │       ├── 02-proposal.md         ← placeholder (next stage)
    │       ├── 03-implement.md        ← placeholder
    │       ├── 04-experiment.md       ← placeholder
    │       ├── 05-writing-material.md ← placeholder
    │       └── frictions.md           ← real-time friction log
    └── user-experience/
        ├── _index.md
        └── first-session-bootstrap/
            ├── README.md
            ├── 00-brainstorm.md       ← FILLED
            └── ...                    (remaining phases as placeholders)
```

The filled-in 00 and 01 phase documents show **what "done" looks like** for those stages. Later stages contain `<!-- next stage: ... -->` placeholders.

---

## How to use this for your own project

### Recommended: AI-assisted (via the bundled brainstorming skill)

After `git clone` and reading `../../README.md`, tell Claude:

> Please read `CLAUDE.md`, `projects/README.md`, and `projects/_example/` thoroughly.
> Then use the `superpowers-brainstorming` skill to help me create `projects/<my-project-slug>/` for my actual research project — explore the project goals, track partition, baseline, and remote environment before generating any files.

Claude will:

1. Run a brainstorming session with you — research question, relevant tracks, baseline, remote env, etc.
2. Generate `projects/<my-project-slug>/` by cross-referencing `_example/` for shape and `projects/README.md` for conventions
3. Leave `_example/` untouched

Review the generated files and iterate. This is the recommended path because it scopes the skeleton to your actual project and engages the brainstorming discipline that comes bundled with this repo.

### Fallback: manual copy

```bash
cp -r projects/_example projects/<my-project-slug>
cd projects/<my-project-slug>
rm HOW-TO-USE-THIS-EXAMPLE.md          # delete this file — it's not part of a real project
# then hand-edit every file to replace example content with your own
```

Tedious but works offline.

---

## Reading order if you're new

20 minutes of reading in this order and you will have a clear mental model of what every file in your own project needs to contain:

1. **[`CLAUDE.md`](CLAUDE.md)** — how an L3 charter looks
2. **[`.claude/HANDOFF.md`](.claude/HANDOFF.md)** — how a session entry looks
3. **[`README.md`](README.md)** — how a project overview looks
4. **[`tracks/framework-design/_index.md`](tracks/framework-design/_index.md)** — how a track index looks
5. **[`tracks/framework-design/reducing-rule-layer-ambiguity/00-brainstorm.md`](tracks/framework-design/reducing-rule-layer-ambiguity/00-brainstorm.md)** — how a stage-00 document looks
6. **[`tracks/framework-design/reducing-rule-layer-ambiguity/01-survey.md`](tracks/framework-design/reducing-rule-layer-ambiguity/01-survey.md)** — how a stage-01 document looks
