# wiki/syntheses/

放**跨多个 wiki 页面的综合论点 / 对比 / 矛盾标记**（如 `scaling-laws-vs-data-quality.md`、`ppi-edge-weight-strategies.md`）。

Syntheses 是 wiki 的二阶产物——综合事实页 → 得出论点。这是 dual-primary 架构里知识 compounding 的主要收获。

## Page 模板（frontmatter）

```yaml
---
wiki_id: <slug>
title: <synthesis title>
type: synthesis
status: stub | draft | mature | stale
depends_on: [paper-1, concept-1, ...]  # 引用的其他 wiki 页
tags: [...]
touched_by: []
---
```

## 页面结构建议

1. **TL;DR**（综合论点一句话）
2. **The Question**（为什么要做这个综合）
3. **Evidence Table**（每行一个引用源 + claim + counter）
4. **Synthesis**（主论点，含可证伪条件）
5. **Open Contradictions**（未解决的矛盾）
6. **Thread 应用**（哪些 thread 的决策依赖本综合）
