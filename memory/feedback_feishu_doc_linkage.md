---
name: External Platform Doc Update Linkage
description: 创建/更新外部协作平台（飞书/Notion/Confluence）的子页面时必须同步更新父页面状态和主文档更新日志（铁律）
type: feedback
---

**问题**：某次 session 中，创建了 Writing Material 和更新了 Experimental Results，但遗漏了更新父页面和主文档更新日志，用户发现后指出。

**规则**（完整版写入 `.claude/rules/feishu-mirror-workflow.md §11`）：

1. **子页面变更 → 必须向上传播**：
   - 更新直接父页面（状态表、子页面索引、摘要数字）
   - 更新项目主文档更新日志（追加一行）

2. **规范文件本身被修改 → 回查已有文档**：
   - 列出受影响文档 → 汇报用户 → 确认后修改

**检查清单**（每次外部平台写入操作后自检）：
- [ ] 父页面状态表是否已更新？
- [ ] 父页面子页面索引是否已包含新页面？
- [ ] 主文档更新日志是否已追加新行？

**How to apply:** 每次创建或实质性更新外部平台子页面后，立即检查并更新父页面和主文档，不要等到最后才补。
