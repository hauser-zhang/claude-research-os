---
name: Research Depth Requirements
description: Literature surveys and reports must meet implementation-reproducible level detail — see .claude/rules/research-and-reporting.md for full spec
type: feedback
---

文献调研和汇报必须达到"可复现"级别的信息量，不能停留在概要层面。

**Why:** 用户在多次模型改进 brainstorm 中指出调研不够详尽——缺少完整架构维度链、损失函数权重、消融具体数字、训练伪代码等。用户需要读完调研后能直接决策和复现。

**How to apply:**
- 完整规范已写入 `.claude/rules/research-and-reporting.md`（L2 跨项目规则）
- 核心要求：每篇文献的完整数据流、组件参数、损失公式+权重、消融 delta%、代码仓库、与当前项目方案的逐组件对比表
- 概念解释必须包含：一句话定义 + 直觉类比 + 伪代码 + 具体数字例子
- 缩写首次出现必须展开
- 实施方案必须分阶段（Phase 0/1/2），从最小改动开始
- **文献纳入三步验证（铁律）**：① WebSearch 确认 DOI → ② WebFetch 读原文找逐字支持句 → ③ 文档留痕（引用格式 + 原文句 + 支持哪个结论）。全文不可获取时摘要有支持句才可用（注明"引自摘要"），否则标 `[TODO: 全文待核实]`，不写入正文。
