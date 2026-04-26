# improving-research-os — Project Charter (L3)

> This is the L3 charter of the example meta-project: using Research OS to research *how to improve Research OS itself*. It is a read-only reference — do not build on it.

---

## 1. Project definition

- **Research question**: What prevents a first-time user from reaching "I can run my own research here" in under 30 minutes?
- **Scope**: L2 framework documents, bundled skills, the onboarding surface. Does **not** include individual research topics a user might run on top.
- **Baseline**: v1.3 of this repo (the skeleton you are currently reading).
- **Paper / write-up mapping**: not paper-bound; outputs go into `meta/improvements-backlog.md` and become ADR-0005, ADR-0006, etc.

---

## 2. Tracks

| Track | Current threads | Status |
|-------|----------------|--------|
| `framework-design/` | `reducing-rule-layer-ambiguity/` | 01 Survey complete, 02 Proposal pending |
| `user-experience/` | `first-session-bootstrap/` | 00 Brainstorm complete, 01 Survey pending |

See each track's `_index.md` for the "why this direction" rationale and success criteria.

---

## 3. Remote environment

This is a **documentation-only project** — no remote servers, no GPU runs, no conda environment. Everything happens in this repo's markdown.

For your real project, this section typically contains:

```yaml
# Example (for a real project, not this one)
server:        <host>:<port>
ssh_host:      <alias>
code_dir:      /path/to/repo
conda_env:     <env-name>
gpu:           <GPU model or shared pool>
required_env:  WANDB_API_KEY, HF_TOKEN
```

---

## 4. External platforms

No external mirror for this example. For a real project, this section typically lists:

- Main Feishu / Notion doc ID and URL
- Tag convention for mirror push (see [`.claude/rules/writing-and-archival.md`](../../.claude/rules/writing-and-archival.md); platform-specific setup in [`platforms/feishu.md`](../../.claude/rules/platforms/feishu.md) / [`platforms/notion.md`](../../.claude/rules/platforms/notion.md))

---

## 5. L3 project-specific rules

None for this example. Real projects usually have:

- `remote-server-operations.md` — SSH conventions, paths
- `<data-format>.md` — how to parse / validate your project's data

---

## 6. L3 project-specific skills

None for this example. Real projects might have:

- A pipeline skill that wraps your training / evaluation scripts
- A case-study analysis skill

---

## 7. Project-specific reminders (iron rules)

None beyond the L2 rules. A real project's reminders are the small things that trip you up repeatedly — e.g., "always pass `--seed` to eval scripts", "never write to `/data/raw/`".

---

## 8. Migration progress

Not applicable for this example. A real project after a few weeks might have:

```
Wave A (skeleton):   ✅ 2026-MM-DD
Wave B (migrate):    ✅ 2026-MM-DD
Wave C (wiki stubs): 🚧 in progress
```
