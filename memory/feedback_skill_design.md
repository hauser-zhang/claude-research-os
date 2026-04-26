---
name: Skill Design Preferences
description: User preferences for skill structure — plans in skill folder, references for volatile state, scripts only for automation, keep server info despite CLAUDE.md duplication
type: feedback
---

用户在 2026-04-08 讨论 `model-architecture-improvement` skill 重构时明确的 skill 设计偏好：

1. **Plan 文件放 skill 文件夹下**：实验计划/TODO 跟踪放在 `<skill>/plans/` 而非全局 `.claude/plans/`，与 skill 生命周期绑定
2. **Baseline 等易变状态放 references/**：模型路径、权重路径、训练状态等频繁变化的信息放 `references/baselines.md`，SKILL.md 只引用
3. **SSH/GPU 信息保留副本**：虽然 CLAUDE.md 已有完整定义，用户认为 skill 内保留一份简表更实用（"不会特别占空间"）
4. **scripts/ 仅用于 skill 自动化**：`scripts/` 放 skill 本身的自动化脚本（如 `init_plan.sh`），**不放训练代码包装器**。训练代码是 vformer 仓库的职责，skill 只在 references 里记录 SSH wrapper pattern
5. **已知坑点提取到 references/known-issues.md**：持续增长的内容不应膨胀 SKILL.md

**Why:** 用户追问了 `scripts/launch_train.sh` 的必要性——"我的 vformer 代码仓库不是本身就有训练用的代码？" 这说明用户重视 skill 与代码仓库的职责边界，不希望 skill 越俎代庖。

**How to apply:** 创建或重构 skill 时，区分三类内容：(1) 稳定的工作流指令 → SKILL.md；(2) 易变的项目状态/参考材料 → references/；(3) skill 自身的自动化 → scripts/。训练代码、数据处理脚本等属于代码仓库，不属于 skill。
