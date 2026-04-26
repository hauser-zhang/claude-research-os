---
upstream_url: https://github.com/obra/superpowers
upstream_path: skills/brainstorming
commit: b7a8f76985f1e93e75dd2f2a3b424dc731bd9d37
upstream_version: 5.0.7
fetched: 2026-04-25
license: MIT
license_compatible_with_mit: true
---

# Upstream: superpowers-brainstorming

## Source

- **Upstream repo**: <https://github.com/obra/superpowers>
- **Upstream path**: [`skills/brainstorming/`](https://github.com/obra/superpowers/tree/b7a8f76985f1e93e75dd2f2a3b424dc731bd9d37/skills/brainstorming)
- **Upstream plugin version**: v5.0.7
- **Author**: Jesse Vincent (<jesse@fsck.com>)
- **License**: MIT — see [upstream LICENSE](https://github.com/obra/superpowers/blob/main/LICENSE)
- **Fetched on**: 2026-04-25 (copied from local plugin cache pinned at commit above)

## Why we mirror

The five-stage research flow (ADR-0001) mandates **divergent brainstorming before convergent proposal**, but Claude's default behavior is to converge early. Superpowers' brainstorming skill enforces user-intent exploration, requirements discovery, and design debate **before** implementation — a direct fit for Research OS's Stage 00.

Shipping this in `upstream/` means `git clone` users get a battle-tested brainstorming flow without having to install the full superpowers plugin.

## Files

| File | Purpose |
|------|---------|
| `SKILL.md` | Main skill (loaded by Skill tool) |
| `visual-companion.md` | Reference images / diagrams cited by SKILL.md |
| `spec-document-reviewer-prompt.md` | Companion prompt for reviewing brainstorm outputs |
| `scripts/` | Automation scripts |

## Local modifications

- **none** — byte-for-byte copy of upstream at pinned commit.

## Attribution

Thanks to Jesse Vincent (@obra) and contributors for the superpowers skill library. Consider starring or sponsoring the upstream repo if this skill helps you.

Upgrading: to pull a newer upstream version, update the `commit` / `upstream_version` fields above, then `cp -r` the new files from a freshly cloned upstream. Record the change in this file's "Local modifications" section if any.
