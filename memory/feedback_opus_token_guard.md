---
name: 飞书文档操作保护规则
description: 飞书文档操作的两条核心规则：1) Opus 下大规模写入要先暂停报告；2) 任何情况下都不要全文 overwrite，除非用户明确说了
type: feedback
---

## 规则 1：Opus 模型下大规模写入先暂停

使用 Opus 等高级模型时，不要直接执行大规模飞书文档写入（overwrite、大段 append、批量插图）。

**Why:** 飞书文档操作（尤其是分步 append + media-insert 的图文交织）会消耗大量 tokens，Opus 模型成本是 Sonnet 的数倍，浪费严重。

**How to apply:**
1. 暂停，不执行飞书写入
2. 向用户列出待更新清单（哪些 section、几段文字、几张图）
3. 建议切换到 Sonnet 再执行
4. 例外：单行替换（修路径、改错别字）、本地文件编辑、SSH 操作不受限

## 规则 2：禁止自主 overwrite 整篇飞书文档

**任何情况下，不得自主对飞书文档执行 overwrite 重写**，除非用户明确说了"全部重写"/"删掉重新生成"等指令。

**Why:** overwrite 会清空所有已有图片 token、评论、格式，重建成本高（多次 append + media-insert），且 token 消耗极大。局部替换（replace_range / insert_after）几乎总能解决问题，成本只有 overwrite 的 1/10。

**How to apply:**
- 遇到文档结构混乱 → 先 fetch 文档，分析混乱位置，用 replace_range 精确修复
- 遇到表格嵌套崩坏 → 用 replace_range 定位表格外围，只重写那一段
- 只有在用户明确说"删了重写"时，才执行 overwrite，并提前告知会丢失图片
