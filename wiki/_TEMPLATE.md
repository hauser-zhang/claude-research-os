---
wiki_id: <slug>                    # 文件名去 .md, 如 vaswani-2017-attention
title: <title>                     # 展示名
type: paper                         # 必改: paper | concept | dataset | benchmark | synthesis
status: stub                        # stub(占位) | draft(写作中) | mature(稳定) | stale(过时待修)
sources: []                         # raw/papers/<slug>.pdf 等原始源; 非论文可空
aliases: []                         # 别名/缩写, 如 [GraphSAGE, SAGEConv]
tags: []                            # 小写短词, 如 [gnn, inductive-learning]
touched_by: []                      # 由 lint 自动同步, 新建留空
created: YYYY-MM-DD
updated: YYYY-MM-DD
# --- 以下按 type 选择性补充 (删掉不适用的块) ---
# paper:
#   authors: []
#   year: YYYY
#   venue: <journal/conf>
#   doi: ""
# dataset:
#   url: <official-url>
#   version: ""
#   license: ""
# benchmark:
#   url: <official-url>
#   task: <一句话任务定义>
#   primary_metric: <ROC-AUC / F1 / ...>
# synthesis:
#   depends_on: []                  # 本综合引用的其他 wiki 页 slug 列表
# concept: (无额外字段)
---

# <Title>

> [!NOTE] <Type> Meta
<!-- 选 NOTE / TIP / IMPORTANT / WARNING / CAUTION 之一 (GitHub Alerts 官方 5 标签) -->
<!-- 下面字段与 frontmatter 保持一致, 未核实项标 *[TODO 待核实]* -->
> - **Type**: <type> · **Status**: <status>
> - **Aliases**: <list or "-">
> - **Tags**: `tag1` · `tag2`
> - **Touched by**: `<project>/<track>/<thread>` · ...
<!-- 按 type 追加关键字段: paper 加 Authors/Venue/DOI/Source; dataset 加 URL/Version/License; benchmark 加 URL/Task/Primary metric; synthesis 加 Depends on -->

## TL;DR

<!-- 一段 <100 字: 这是什么 / 为什么重要 / 对本 OS 用户的使用建议 -->

## Key Points

<!-- 3-5 条 bullet, 每条一句话, 面向"未来再查一次"的用户 -->
- ...
- ...
- ...

## Details

<!-- 充分展开, 可分多个 subsection -->
<!-- paper: Data Flow / Key Numbers / Limitations -->
<!-- concept: 伪代码或公式 / 直觉类比 / 典型实例 / Variants -->
<!-- dataset: Schema / Access / 统计 / Known Issues -->
<!-- benchmark: Task & Metric / Leaderboard / Split / Pitfalls -->
<!-- synthesis: Evidence Table / Synthesis / Open Contradictions -->

## Touched By

<!-- 双向链接合同: thread 的 wiki_touches: ← → 本处反向列出 -->
<!-- 由 lint 自动同步, 新建时留空 -->

## References

<!-- 格式: Author et al., Year, Venue. DOI: xxx -->
<!-- 引用铁律见 .claude/rules/research-and-reporting.md §"引用铁律" -->
- ...

---

## 使用说明

1. **复制此模板** → `wiki/<type>/<slug>.md` → 改 frontmatter `type` / `wiki_id` / `title`
2. **Status 语义**:
   - `stub` = 刚建, 只有 TL;DR 一句话
   - `draft` = 正在写, 多数 section 有内容但未定稿
   - `mature` = 稳定可引用, 被 ≥1 个 thread 正式引用
   - `stale` = 内容过时或被新 synthesis 替代, 待修或降级
3. **Type 差异** (subtype 专属字段见 `wiki/<type>/_README.md`):
   - `paper` — 原始论文 · 有 authors/year/venue/doi
   - `concept` — 跨 thread 的术语/方法 · 无额外字段, 但强调 See also 交叉引用
   - `dataset` — 数据源 · url/version/license
   - `benchmark` — 评测任务 · url/task/primary_metric
   - `synthesis` — 跨多页综合论点 · depends_on 列引用源
4. **Touched By 同步**: 在 thread 的 phase doc frontmatter 写 `wiki_touches: [<slug>]`, lint 会反向填充本页 `touched_by` + `## Touched By` 章节
5. **引用**: 生物学/实验结论必须配文献, 三步验证 (搜索 → 读原文 → 留原文支持句), 见 `.claude/rules/research-and-reporting.md`
