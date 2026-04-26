---
stage: 00-brainstorm
thread: reducing-rule-layer-ambiguity
track: framework-design
agency: pair-divergent
status: done
started: 2026-04-26
decided: 2026-04-26
---

# 00 · Brainstorm

## Lead question

How should rules that **mostly apply to every project but have a project-specific edge case** be organised, so users don't have to reverse-engineer where they belong?

Concrete example: "SSH conventions" — 90% applies to every project (agent forwarding, known hosts, key types), but the specific server name, port, and paths are project-specific. Does this go at L2, L3, or both?

## Candidates (≥5)

> **Agency note.** In Stage 00 we stay **divergent**. Do not pick a winner yet. Every candidate gets pros and cons recorded, even the ones we already suspect won't work.

### Candidate A: strict binary cut — every rule lives at exactly one layer

- **Shape**: a rule is either L2 (applies to every project verbatim) or L3 (project-specific). No rule fragments.
- **Pros**: easiest to explain; zero ambiguity about where to look
- **Cons**: rules that are 90% shared get duplicated at every L3; cross-project updates require N edits

### Candidate B: L2 skeleton + L3 overrides

- **Shape**: generic shape at L2, project overrides values at L3 (like CSS cascade)
- **Pros**: DRY for the shared body; L3 only holds the delta
- **Cons**: user has to read two files to understand one rule; "which field came from where" requires tooling

### Candidate C: L2 template variables — single file, placeholders filled at L3

- **Shape**: L2 file uses `{{server}}`, `{{port}}`; L3 provides a YAML with values
- **Pros**: single source of truth for the shape; values trivially interpolated
- **Cons**: needs a templating runtime; Claude Code doesn't natively understand this

### Candidate D: rule partitioning — split any mixed rule into an L2 generic half and an L3 project half

- **Shape**: a rule about "SSH" becomes two files — `.claude/rules/ssh-general.md` (L2) + `projects/<name>/.claude/rules/ssh-servers.md` (L3)
- **Pros**: each file has a single responsibility; Claude Code's cascading load picks up both automatically
- **Cons**: requires discipline to notice mixed rules and split them; some topics don't partition cleanly

### Candidate E: leave it ambiguous, trust the friction log

- **Shape**: no formal rule; trust that ambiguity surfaces as frictions and meta-review resolves case-by-case
- **Pros**: zero upfront design cost; adapts to real usage
- **Cons**: users hit the ambiguity repeatedly before meta-review catches up; bad first-session experience

## Decision

**Chosen: Candidate D (rule partitioning)**, with a lightweight rule from Candidate A as the default when a rule is uniformly shared or uniformly project-specific.

## Rationale

1. **Matches Claude Code's mechanism.** The cascading `CLAUDE.md` / `.claude/` loader already concatenates L2 and L3 — partitioning aligns with the tool rather than fighting it
2. **No runtime dependencies.** Unlike C, no templating engine needed
3. **Single responsibility per file.** Unlike B, every file is self-contained and readable on its own
4. **Discoverable.** Unlike E, users have an explicit rule for where to put things; ambiguity only arises in the rare mixed case, and the partitioning rule tells them what to do

## Self-pokes (≥3 holes I can see in this choice)

1. **"Some topics don't partition cleanly" is not hand-waved.** The Survey stage needs to find at least 3 concrete topics and check whether partitioning works for all of them.
2. **File proliferation risk.** If every mixed topic becomes two files, a project's `.claude/rules/` directory could balloon. Is there a threshold beyond which partitioning backfires?
3. **Discoverability of L2 half when reading L3 half.** A user opening `projects/my-project/.claude/rules/ssh-servers.md` may not realise there is an L2 counterpart at `.claude/rules/ssh-general.md`. Do we need a convention like naming suffix (`-general` / `-project`) or an explicit cross-link in the frontmatter?

Hole 1 → test in Survey stage. Hole 2 → defer to Proposal. Hole 3 → partially addressable with a naming convention; add to Proposal.

## Next stage

Advance to `01-survey.md`: compare three existing tools that face the same problem — shadcn/ui config layering, ESLint shared-configs, and Anthropic skill-creator's `references/` pattern.
