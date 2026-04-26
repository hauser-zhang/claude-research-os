# Repo Layout

Annotated directory tree for `claude-research-os`. Also see [architecture.md](architecture.md).

```text
claude-research-os/
├── CLAUDE.md                       # L2 skeleton constitution (loaded first by Claude Code)
├── README.md                       # English entry page
├── README.zh-CN.md                 # Simplified Chinese entry
├── LICENSE                         # MIT
│
├── .claude/                        # L2 cross-project Claude config
│   ├── HANDOFF.md                  # universal task dispatcher
│   ├── rules/                      # academic writing / figure style / citation rules
│   └── skills/
│       ├── _catalog.md             # index of every shipped skill
│       ├── own/                    # skills written for Research OS
│       │   └── code-walkthrough/
│       └── upstream/               # skills mirrored from community (+ _UPSTREAM.md)
│           ├── karpathy-guidelines/
│           ├── superpowers-brainstorming/
│           ├── superpowers-systematic-debugging/
│           └── superpowers-test-driven-development/
│
├── projects/                       # each subdirectory = one research project
│   ├── README.md                   # new-project guide
│   └── <name>/                     # (gitignored by default — author's own projects)
│       ├── CLAUDE.md               # L3 charter (static)
│       ├── .claude/
│       │   ├── HANDOFF.md          # session entry (dynamic — active threads)
│       │   ├── rules/              # project-specific rules
│       │   └── skills/             # project-specific skills
│       ├── IDEAS.md                # low-cost idea inbox
│       └── tracks/
│           └── <track>/
│               ├── _index.md       # track why + success criteria
│               └── <thread>/       # five-stage thread
│                   ├── README.md
│                   ├── 00-brainstorm.md
│                   ├── 01-survey.md
│                   ├── 02-proposal.md
│                   ├── 03-implement.md
│                   ├── 04-experiment.md
│                   ├── 05-writing-material.md
│                   ├── frictions.md
│                   └── results/    # experiment output (gitignored)
│
├── wiki/                           # L2 cross-project knowledge (Dual-Primary)
│   ├── index.md                    # catalog of wiki pages
│   ├── papers/                     # academic papers (DOI / venue)
│   ├── concepts/                   # technical concepts / methods
│   ├── datasets/                   # data sources
│   ├── benchmarks/                 # benchmarks / leaderboards
│   └── syntheses/                  # cross-source thesis pages
│
├── raw/                            # immutable source material
│   ├── papers/                     # PDFs
│   └── clippings/                  # blog / GitHub / X archives
│
├── learning/                       # non-task-driven reading workflow
│   └── _index.md
│
├── writing/                        # paper / thesis material
│   └── _index.md
│
├── schedule/                       # ToDo / calendar entry
│   └── _index.md
│
├── decisions/                      # L2 architectural ADRs
│   ├── ADR-TEMPLATE.md
│   ├── ADR-0001-research-os-architecture.md
│   ├── ADR-0002-tracks-and-ideas-inbox.md
│   ├── ADR-0003-open-source-split.md
│   └── ADR-0004-learning-sources-and-skills-split.md
│
├── meta/                           # self-evolving state
│   ├── frictions-backlog.md        # (gitignored — author's real log)
│   ├── improvements-backlog.md     # (gitignored)
│   └── reviews/                    # weekly meta-reviews (gitignored)
│
├── journal/                        # daily lab notebook
│   ├── _index.md                   # template
│   └── YYYY-MM-DD.md               # (gitignored — author's real entries)
│
├── memory/                         # L2 cross-project memory
│   ├── MEMORY.md                   # index
│   ├── feedback_*.md               # cross-project collaboration rules
│   └── user_*.md                   # (gitignored — personal profile)
│
└── docs/                           # architecture deep dive / philosophy
    ├── philosophy.md
    ├── architecture.md
    └── repo-layout.md              # this file
```

## What's gitignored in the open-source template

The repo is structured so maintainer's private content stays private but the **skeleton** is shared:

| Path | Tracked? | Why |
|------|----------|-----|
| `projects/<author-main-project>/` | No | Author's actual research data |
| `wiki/{papers,concepts,...}/*.md` | No (skeletons yes) | Author's actual knowledge base |
| `journal/YYYY-MM-DD.md` | No (template yes) | Author's lab notebook |
| `meta/*-backlog.md` | No (template yes) | Author's frictions log |
| `memory/user_*.md` | No | Personal profile |
| `writing/<target>/` | No (`_index.md` yes) | Author's paper drafts |
| `.claude/skills/upstream/*` | **Yes** | Batteries-included with attribution |

See [`.gitignore`](../.gitignore) for the full ruleset and [ADR-0003](../decisions/ADR-0003-open-source-split.md) for the reasoning.
