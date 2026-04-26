# wiki/datasets/

放**数据源元数据**（VFDB、STRING、HuggingFace Datasets 等）。

## 页面结构（两层：结构化 frontmatter + 可视化 Meta 块 + 正文）

### 1) YAML Frontmatter（机器读，工具/索引/lint 用）

```yaml
---
wiki_id: <slug>
title: <dataset name>
type: dataset
status: stub | draft | mature | stale
url: <official-url>
license: ...
version: ...
aliases: []
tags: [...]
touched_by: []
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
```

### 2) 正文首块：Meta 回销（GitHub Alerts `> [!NOTE]`，人读）

`# H1 标题` 紧跟一个 `> [!NOTE] Dataset Meta` 回销块。目的：VSCode / GitHub 原生 markdown preview 中可视化呈现元信息。

```markdown
# STRING — Protein-Protein Interaction Database

> [!NOTE] Dataset Meta
> - **Type**: dataset · **Status**: mature
> - **Official URL**: https://string-db.org/
> - **Current version**: v12.0 (2023)
> - **License**: CC BY 4.0
> - **Aliases**: STRING-DB
> - **Tags**: `ppi` · `edge-features` · `multi-evidence`
> - **Touched by**: `<project>/model-architecture/edge-feature-arch` · `<project>/novel-vf-validation`
```

**规则**：
- 选用 GitHub Alerts 官方保留的 5 标签（NOTE / TIP / IMPORTANT / WARNING / CAUTION）
- Dataset 页面关键字段：`Type / Status / Official URL / Current version / License / Aliases / Tags / Touched by`
- 不确定的版本号 / license 用 `*[TODO 待核实]*` 标记，与 frontmatter 的空字段对应
- URL 直接点击可跳转，不用额外加 markdown link 语法

### 3) 正文章节

1. **TL;DR**（数据集是什么，规模，版本）
2. **Schema**（字段名 / 类型 / 含义）
3. **Access**（下载路径、本地缓存位置、API 示例）
4. **基本统计**（节点数 / 样本数 / 类别数 —— 不确定就 `[TODO 待核实]`）
5. **在项目中的使用**（哪些 thread 用了、怎么用）
6. **Known Issues / Caveats**
7. **Referenced by**（保留——双向链接合同）
