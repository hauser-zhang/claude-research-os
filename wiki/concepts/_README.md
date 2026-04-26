# wiki/concepts/

放**跨 thread 的概念 / 术语 / 方法**（如 `transformer.md`、`graphsage.md`、`rlhf.md`、`self-supervised-learning.md`）。

## 页面结构（两层：结构化 frontmatter + 可视化 Meta 块 + 正文）

### 1) YAML Frontmatter（机器读，工具/索引/lint 用）

```yaml
---
wiki_id: <slug>
title: <concept name>
type: concept
status: stub | draft | mature | stale
sources: []
aliases: []
tags: [...]
touched_by: []
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
```

### 2) 正文首块：Meta 回销（GitHub Alerts `> [!NOTE]`，人读）

`# H1 标题` 紧跟一个 `> [!NOTE] Concept Meta` 回销块，把 frontmatter 的关键字段人肉展开。目的：VSCode / GitHub 原生 markdown preview 中可视化呈现元信息。

```markdown
# GraphSAGE / SAGEConv

> [!NOTE] Concept Meta
> - **Type**: concept · **Status**: mature
> - **Aliases**: SAGEConv, GraphSAGE, Hamilton-2017
> - **Tags**: `gnn` · `inductive-learning` · `neighbor-sampling`
> - **See also**: [hamilton-2017-graphsage](../papers/hamilton-2017-graphsage.md) · [transformer](transformer.md)
> - **Touched by**: `<project>/model-architecture/edge-feature-arch` · `<project>/model-architecture/contrastive-learning` · `<project>/model-architecture/backbone-tuning`
```

**规则**：
- 选用 GitHub Alerts 官方保留的 5 标签（NOTE / TIP / IMPORTANT / WARNING / CAUTION）
- Concept 页面的 meta 块关键字段：`Type / Status / Aliases / Tags / See also（高频关联的其他 wiki 页）/ Touched by`
- `See also` 是 concept 特有——用来列**语义最相关的其他 wiki 页**（原始论文、相似 concept、反面对比 concept），做第二层"小图谱"。比正文末尾的 Referenced by 更显眼、更早暴露
- 与 frontmatter 保持一致（不要 drift）

### 3) 正文章节

1. **一句话定义**
2. **直觉类比**
3. **伪代码 / 公式**（具体到算法步骤）
4. **典型实例**（含具体数字）
5. **Variants / Related Concepts**（交叉引用其他 wiki 页）
6. **Pitfalls / Common Misunderstandings**
7. **Referenced by**（保留——双向链接合同）
