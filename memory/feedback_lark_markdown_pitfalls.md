---
name: Lark-cli Markdown Pitfalls
description: lark-cli docs +update 写入飞书时英文双引号和多行blockquote会导致内容截断，需规避
type: feedback
originSessionId: 70bc8d3e-4eb3-426d-ab00-88bab6e83834
---
lark-cli 通过 `--markdown` 写入飞书文档时，有两类已确认的内容截断 bug。

**规则：写入前必须检查并消除以下格式。**

**Why:** 2026-04-11 session 中，文献留痕段落中的英文双引号导致引用原文句全部丢失，blockquote 的换行内容也同样消失，需要多次修复才写入成功。

**How to apply:**

1. **英文双引号 `"` → 截断内容**：直接去掉外层引号，或改用中文引号 `「」`。
   - 错误：`原文支持句："These pathogens target..."`
   - 正确：`原文支持句：These pathogens target...`

2. **多行 blockquote `>` → 只保留第一行**：改用普通段落 + 加粗标题（如 `**📌 文献留痕：**`）。

3. **`replace_range` 定位串含双引号 → MCP 参数报错**：定位锚点要选不含双引号的文字段落。

完整规范见：`.claude/rules/feishu-doc-organization.md` → lark-cli Markdown 写入坑点章节。

4. **lark-table 内 `replace_range` 无法跨 cell 分割**：在 lark-table 的单元格内容做 `replace_range` 替换时，写入的 markdown 中的 `|` 会被当作 literal 文本，**不会**拆分成两个单元格。若需修改不同单元格，必须分别对每个单元格的内容做独立替换，不能在一次替换中跨两个格写入。
