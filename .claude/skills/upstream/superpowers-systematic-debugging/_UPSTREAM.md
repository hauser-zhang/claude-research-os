---
upstream_url: https://github.com/obra/superpowers
upstream_path: skills/systematic-debugging
commit: b7a8f76985f1e93e75dd2f2a3b424dc731bd9d37
upstream_version: 5.0.7
fetched: 2026-04-25
license: MIT
license_compatible_with_mit: true
---

# Upstream: superpowers-systematic-debugging

## Source

- **Upstream repo**: <https://github.com/obra/superpowers>
- **Upstream path**: [`skills/systematic-debugging/`](https://github.com/obra/superpowers/tree/b7a8f76985f1e93e75dd2f2a3b424dc731bd9d37/skills/systematic-debugging)
- **Upstream plugin version**: v5.0.7
- **Author**: Jesse Vincent (<jesse@fsck.com>)
- **License**: MIT — see [upstream LICENSE](https://github.com/obra/superpowers/blob/main/LICENSE)
- **Fetched on**: 2026-04-25

## Why we mirror

Research pipelines fail in ways that look random but aren't — a flaky test, a subtle race, a silently mis-shaped tensor. Claude's default is to "try a fix and see"; this skill forces hypothesis → minimal reproduction → root-cause trace before proposing any change. That matches Research OS's Stage 03 (implement) and Stage 04 (experiment) discipline: distinguish observation from explanation.

## Files

| File | Purpose |
|------|---------|
| `SKILL.md` | Main skill |
| `CREATION-LOG.md` | Upstream author's design notes for this skill |
| `root-cause-tracing.md` | Companion reference for tracing failure modes |
| `defense-in-depth.md` | Companion reference for layered test defenses |
| `condition-based-waiting.md` + `.ts` | Pattern for replacing `sleep()` in flaky tests |
| `find-polluter.sh` | Helper script for test-pollution bisection |
| `test-academic.md` · `test-pressure-*.md` | Scenario references |

## Local modifications

- **none** — byte-for-byte copy of upstream at pinned commit.

## Attribution

Thanks to Jesse Vincent (@obra) and contributors.
