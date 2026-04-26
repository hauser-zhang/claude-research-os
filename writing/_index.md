# Writing — 论文 / 毕业论文 / 组会 素材入口

> 定位：跨 thread 组装的写作素材库。每个"写作目标"（如某篇毕业论文、某篇投稿）是一个独立 sub-directory。
> 素材源头是 thread 的 `04-experiment.md` 产出 + wiki 综合页，本目录负责**再加工**成可直接嵌入正文的段落。
>
> 开源模板发行版：`writing/<target>/` 具体子目录是作者的私人稿件，`.gitignore` 默认排除。开源用户按下面的规范自己建。

## 活跃写作目标

| Target | 路径 | Status | 截稿 |
|--------|------|--------|------|
| _(待填充)_ | `writing/<target>/` | — | — |

## 目录与命名规范（强制）

### 章节目录

```
writing/<target>/
├── _index.md                               ← 全书/全文 TOC
├── ch<N>-<chapter-slug>/                   ← 每章一目录，N=章号，slug 英文 lowercase-hyphen
│   ├── _index.md                           ← 本章 TOC（按节列出 Figure 和段落文件）
│   ├── s<N.M>-<section-slug>.md            ← 每节一个 md 文件
│   └── figures/
│       └── fig-<N>-<M>-<slug>/             ← 每个 Figure 一个子目录
│           ├── panel_a_<content-slug>.svg
│           ├── panel_a_<content-slug>.png
│           ├── panel_b_<content-slug>.svg
│           └── panel_b_<content-slug>.png
```

### 例：某毕业论文 Ch4 §4.3 "特征消融"

```
writing/<target>/
├── _index.md
├── ch4-model-architecture/
│   ├── _index.md
│   ├── s4-1-overview.md
│   ├── s4-3-feature-ablation.md                ← 本节五层素材
│   ├── s4-4-ssl-pretrain.md
│   └── figures/
│       ├── fig-4-1-overview/
│       │   ├── panel_a_architecture.svg
│       │   ├── panel_a_architecture.png
│       │   ├── panel_b_data_flow.svg
│       │   └── panel_b_data_flow.png
│       ├── fig-4-3-feature-ablation/
│       │   ├── panel_a_macro_f1_by_channels.svg
│       │   ├── panel_a_macro_f1_by_channels.png
│       │   ├── panel_b_per_class_breakdown.svg
│       │   ├── panel_b_per_class_breakdown.png
│       │   ├── panel_c_ablation_heatmap.svg
│       │   └── panel_c_ablation_heatmap.png
│       └── fig-4-4-ssl-pretrain/
│           └── ...
├── ch5-interpretability/
│   └── figures/
│       ├── fig-5-1-saliency-a/
│       └── fig-5-2-importance-b/
└── ch6-case-study/
    └── figures/
        ├── fig-6-1-case-a/
        └── fig-6-2-case-b/
```

### 命名规则

| 层级 | 格式 | 例子 |
|------|------|------|
| 章节目录 | `ch<N>-<topic-slug>/` | `ch4-model-architecture/` |
| 节文件 | `s<N.M>-<slug>.md` | `s4-3-feature-ablation.md` |
| Figure 目录 | `fig-<N>-<M>-<slug>/` | `fig-4-3-feature-ablation/` |
| Panel 文件 | `panel_<letter>_<content-slug>.<ext>` | `panel_a_macro_f1_by_channels.svg` |

**关键原则**：
- Figure 编号用 `-` 不用 `.`（文件系统友好）
- Panel 名称带**内容 slug**（`panel_a_macro_f1` 比 `panel_a` 可读得多，未来 reorder 章节时仍然自描述）
- **SVG + PNG 并列同目录**（按 `.claude/rules/figure-style-guidelines.md` 铁律，两种格式同时存在）
- **每个 Figure 一个目录**——即使只有 Panel A，也建 `fig-<N>-<M>-<slug>/` 目录。一致性优先于偷懒。
- 路径和文件名用英文 lowercase + hyphen；内容可用中文；专有名词保持英文

### 从 thread 复制图到 writing 的工作流

Thread 里实验跑完产出在 `projects/<name>/tracks/<track>/<thread>/results/<timestamp>_<desc>/`；整理到 writing 时**重命名 + 只拷贝最终版**：

```bash
mkdir -p writing/<target>/ch4-model-architecture/figures/fig-4-3-feature-ablation
cp projects/<name>/tracks/interpretability/<thread>/results/YYYYMMDD_final/panel_a.svg \
   writing/<target>/ch4-model-architecture/figures/fig-4-3-feature-ablation/panel_a_macro_f1_by_channels.svg
# 同步复制对应的 png
```

Thread 的 `results/` 是实验输出（随实验次数增长），writing 的 `figures/` 是精选发表稿（只放最终版）。两边严格分离。

## 写作模板（Writing Material 五层）

见 [memory/feedback_writing_material.md](../memory/feedback_writing_material.md)。每个 Panel 必须包含：
1. 一句话结论 + 图文件绝对路径
2. 详细中文结果段落（观察→比较→解释→边界）
3. 英文 PPT 文字（take-home title + 2-4 bullets）
4. 子图图例（中文，"（A）""（B）"格式）
5. 论文段落草稿（串联多 Panel 的连续论证）

文档末尾放：总图例 + Analysis metadata（model / eval mode / split / primary metric）。

## 学术措辞规范

- 用"提示""表明""与…一致"；避免"证明""必然""毫无疑问"
- 引用必须经过三步验证（见 [.claude/rules/research-and-reporting.md](../.claude/rules/research-and-reporting.md)）
