# wiki/benchmarks/

放**具体 benchmark / baseline**（如 `imagenet.md`、`mmlu.md`、VF prediction benchmarks）。

## 页面结构（两层：结构化 frontmatter + 可视化 Meta 块 + 正文）

### 1) YAML Frontmatter（机器读，工具/索引/lint 用）

```yaml
---
wiki_id: <slug>
title: <benchmark name>
type: benchmark
status: stub | draft | mature | stale
sources: []
url: <official-url>
primary_metric: <e.g. ROC-AUC / F1 / micro-F1>
aliases: []
tags: [...]
touched_by: []
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
```

### 2) 正文首块：Meta 回销（GitHub Alerts `> [!NOTE]`，人读）

```markdown
# ogbn-proteins — OGB Node Classification on Protein-Protein Network

> [!NOTE] Benchmark Meta
> - **Type**: benchmark · **Status**: mature
> - **Official URL**: https://ogb.stanford.edu/docs/nodeprop/#ogbn-proteins
> - **Primary metric**: ROC-AUC (multi-label, 112 tasks)
> - **Task**: protein function prediction on PPI graph (species, multi-label)
> - **Aliases**: OGB-proteins
> - **Tags**: `ogb` · `ppi` · `multi-label` · `node-classification`
> - **Touched by**: `<project>/model-architecture/contrastive-learning` · `<project>/model-architecture/edge-feature-arch`
```

**规则**：
- 选用 GitHub Alerts 官方保留的 5 标签（NOTE / TIP / IMPORTANT / WARNING / CAUTION）
- Benchmark 页面关键字段：`Type / Status / Official URL / Primary metric / Task / Aliases / Tags / Touched by`
- `Primary metric` 一行点出主指标（与次要指标区分）

### 3) 正文章节

1. **TL;DR**（任务定义 + 当前 SOTA）
2. **Task & Metric**（输入输出 / 主指标 / 次要指标）
3. **Leaderboard Snapshot**（主要方法 + 数字 + 时间戳）
4. **Train/Val/Test Split**
5. **Known Pitfalls**
6. **在项目中的使用**（哪些 thread 用来对比 / 借鉴评价协议）
7. **Referenced by**（保留——双向链接合同）
