# improving-research-os — Project Overview

> Using Research OS to research how to improve Research OS itself. A **meta-project** — reference only.

## TL;DR

- Two research directions: framework design + user experience
- Three active threads as of this snapshot
- All outputs land in `meta/improvements-backlog.md` or propose new ADRs

## Tracks & threads

| Track | Thread | Phase | Key insight so far |
|-------|--------|-------|---------------------|
| [framework-design](tracks/framework-design/) | [reducing-rule-layer-ambiguity](tracks/framework-design/reducing-rule-layer-ambiguity/) | 01 Survey done | L2/L3 ambiguity mostly comes from rules that "mostly apply everywhere but have a project-specific edge case" |
| [user-experience](tracks/user-experience/) | [first-session-bootstrap](tracks/user-experience/first-session-bootstrap/) | 00 Brainstorm done | First-session success depends on (a) finding a concrete example within 5 min, (b) not needing to read ADRs, (c) bundled skills triggering at the right moment |

## Key numbers

- **2** tracks, **2** threads
- **Zero** external dependencies (no data, no GPU)
- **0%** remote — everything is in-repo markdown

## Next steps (session handoff)

See [`.claude/HANDOFF.md`](.claude/HANDOFF.md) for the current active-thread table and next-step candidates.

## How this example relates to you

This project is bundled in `projects/_example/` as a **shape reference**. You should not edit it; you should use it to understand what the files in your own `projects/<your-project>/` will look like. See [`_example/README.md`](README.md) for how to use it with AI assistance.
