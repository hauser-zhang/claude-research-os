# Wiki Operations Log

> Append-only 操作日志。每次 wiki-ingest / wiki-query / wiki-lint 追加一行。
> 格式：`## [YYYY-MM-DD HH:MM] <event> | <subject> | <details>`
> 查最近 20 条：`grep "^## \[" wiki/log.md | tail -20`

## [2026-04-20] wiki-init | — | Wave A 创建 wiki 骨架（index + log + 5 个子目录 _README）
