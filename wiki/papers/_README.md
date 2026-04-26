# wiki/papers/

放**被多个 thread 引用的关键论文**。每篇一页，slug 形如 `<first-author>-<year>-<keyword>.md`（如 `vaswani-2017-attention.md`）。

## 页面结构（两层：结构化 frontmatter + 可视化 Meta 块 + 正文）

### 1) YAML Frontmatter（机器读，工具/索引/lint 用）

```yaml
---
wiki_id: <slug>
title: <paper title>
type: paper
status: stub | draft | mature | stale
sources: [raw/papers/<slug>.pdf]
authors: [...]
year: YYYY
venue: <journal/conf>
doi: ...
aliases: []
tags: [...]
touched_by: []  # auto-synced by lint
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
```

### 2) 正文首块：Meta 回销（GitHub Alerts `> [!NOTE]`，人读）

`# H1 标题` 紧跟一个 `> [!NOTE] Paper Meta` 回销块，把 frontmatter 中**最常被查阅的字段**人肉展开。目的：VSCode / GitHub 原生 markdown preview 中可视化呈现元信息（frontmatter 在这些 preview 中是裸文本），一眼看到作者/venue/DOI/code/被谁引用。

```markdown
# <Paper Short Name> (Author et al. YYYY)

> [!NOTE] Paper Meta
> - **Type**: paper · **Status**: mature
> - **Authors**: Hamilton, Ying, Leskovec
> - **Venue**: NeurIPS 2017
> - **DOI**: 10.xxxx/xxxxx
> - **Source**: https://arxiv.org/abs/xxxx.xxxxx
> - **Code**: https://github.com/... （若有）
> - **Aliases**: GraphSAGE
> - **Tags**: `gnn` · `inductive-learning` · `neighbor-sampling`
> - **Touched by**: `<project>/model-architecture/edge-feature-arch` · `<project>/model-architecture/contrastive-learning`
```

**规则**：
- `> [!NOTE]` 选用 GitHub Alerts 官方保留的 5 标签之一（NOTE / TIP / IMPORTANT / WARNING / CAUTION）——不用 Obsidian 独有的 `[!info]` / `[!abstract]` 等，兼容性更广
- 字段内容与 frontmatter **保持一致**（不要让两处 drift），但格式为给人看（链接可点击 / tags 前加反引号变 inline code / `·` 分隔并列项）
- 未核实字段用 `*[TODO 待核实]*` 标记，与 frontmatter 的 `doi: ""` 空字段对应

### 3) 正文章节（markdown 标题层级）

1. **TL;DR**（可证伪命题 / 核心一句话）
2. **Core Contribution**（方法一句话）
3. **Data Flow**（完整输入→输出维度链，引用 `research-and-reporting.md` 标准）
4. **Key Numbers**（主结果表）
5. **Limitations / Open Questions**
6. **How it connects to our work**（哪些 thread 引用、如何引用）
7. **Referenced by**（保留——双向链接合同；lint 会同步 frontmatter `touched_by` 与本章节）
