# Session Handoff (L3) — improving-research-os

> Dynamic document. Update every session. Tells the next Claude session what is active and what to pick up.

---

## 1. Active threads

| Track | Thread | Phase | Status | Updated |
|-------|--------|-------|--------|---------|
| framework-design | [reducing-rule-layer-ambiguity](../tracks/framework-design/reducing-rule-layer-ambiguity/) | 01 Survey | `status: accepted` — ready for Proposal | 2026-04-26 |
| user-experience | [first-session-bootstrap](../tracks/user-experience/first-session-bootstrap/) | 00 Brainstorm | `status: done` — ready for Survey | 2026-04-26 |

---

## 2. Next-step candidates

- Advance `reducing-rule-layer-ambiguity` into Stage 02 (Proposal): pick the best candidate from the Brainstorm and write a falsifiable proposal with ≥3 self-pokes
- Start Stage 01 (Survey) on `first-session-bootstrap`: survey the onboarding patterns of karpathy-skills / Multica / shadcn/ui / Cursor templates
- Promote the "quick-win friction" ideas from `IDEAS.md` into full threads if the pattern is worth a proper five-stage investigation

Pick one and tell Claude explicitly — this template does not auto-advance between sessions.

---

## 3. Task-mode dispatch

| Trigger | Mode |
|---------|------|
| "Let's brainstorm <new direction>" | Open a new thread under the matching track, go to Stage 00 |
| "Continue <thread-slug>" | Open the thread's current stage doc, continue inside it |
| "Quick idea: ..." | Append one line to [`../IDEAS.md`](../IDEAS.md), do not open a thread |
| "Weekly review" | Read [`../../../meta/frictions-backlog.md`](../../../meta/frictions-backlog.md) + run triage |

---

## 4. Reading order for a fresh Claude session

1. Repo-root `CLAUDE.md` (auto-loaded by Claude Code — gives the three-scope skeleton and default behaviour)
2. This project's `CLAUDE.md` (auto-loaded when you `cd` here — gives this project's charter)
3. This HANDOFF.md (you are here — tells you what to pick up)
4. The active-thread phase doc you decide to work on
