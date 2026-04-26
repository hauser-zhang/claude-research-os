---
name: Experiment Tracking Style
description: Model architecture improvement experiments use table-driven Feishu docs, auto-training with monitoring, GPU3 A100 priority
type: feedback
---

模型架构改进实验的管理规则：

1. **飞书记录用表格驱动**：每个实验结果以表格行追加，不写长段落，省 tokens
2. **主动跑训练 + 轮询监控**：开 sub-agent 监控训练状态，出错及时修复
3. **GPU3 (A100) 优先**：冲突任务直接 kill（用户有 sudo 权限）
4. **失败实验也要记录**：备注失败原因，为排除方向留痕
5. **绝不覆盖 baseline 模型目录**：所有新实验输出到独立子目录
6. **Git 分支策略**：小改动直接改主代码，大改动用 `exp/<方向简称>` 分支隔离

**Why:** 用户处于模型架构探索期，需要高效对比多个方向的多组参数，表格形式最省 tokens 且便于横向对比。训练可能异常中断需要及时响应。

**How to apply:** 触发 `model-architecture-improvement` skill 时遵循这些规则。
