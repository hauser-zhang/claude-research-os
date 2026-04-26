---
upstream_url: https://github.com/obra/superpowers
upstream_path: skills/test-driven-development
commit: b7a8f76985f1e93e75dd2f2a3b424dc731bd9d37
upstream_version: 5.0.7
fetched: 2026-04-25
license: MIT
license_compatible_with_mit: true
---

# Upstream: superpowers-test-driven-development

## Source

- **Upstream repo**: <https://github.com/obra/superpowers>
- **Upstream path**: [`skills/test-driven-development/`](https://github.com/obra/superpowers/tree/b7a8f76985f1e93e75dd2f2a3b424dc731bd9d37/skills/test-driven-development)
- **Upstream plugin version**: v5.0.7
- **Author**: Jesse Vincent (<jesse@fsck.com>)
- **License**: MIT — see [upstream LICENSE](https://github.com/obra/superpowers/blob/main/LICENSE)
- **Fetched on**: 2026-04-25

## Why we mirror

Research code is notoriously under-tested — the argument "this will only run once" is almost always wrong, and silent numerical bugs in ablation / evaluation pipelines are the worst kind of invisible failure. Pairing this TDD skill with Research OS's five-stage flow means Stage 03 (implement) lands on tests first, not "looks right to me."

The skill also includes the `testing-anti-patterns.md` companion which catches the common research-code sins (snapshot-only tests, `assert` in production, flaky seeds).

## Files

| File | Purpose |
|------|---------|
| `SKILL.md` | Main skill |
| `testing-anti-patterns.md` | Companion reference on what bad tests look like |

## Local modifications

- **none** — byte-for-byte copy of upstream at pinned commit.

## Attribution

Thanks to Jesse Vincent (@obra) and contributors.
