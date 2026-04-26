---
name: Session Boundary Rule
description: 每个session只负责自己的任务，绝不跨session自动执行来自其他session的计划或任务
type: feedback
---

每个 Session 只负责自己那块的事情，绝不跨 session 自动完成其他任务。

**Why:** 用户明确强调（2026-04-12）：session自主执行旧plan是越权行为，用户必须每次显式授权。

**How to apply:**
- 新session启动：不论plans/目录有多少"未完成"任务，一律不主动执行，等用户指示
- 看到旧patch脚本/implementation_plan.md：只汇报"发现了什么"，不自动开始
- "计划已写好" ≠ "被授权执行"，必须等用户说"继续""执行""开始"才算授权
- 后台agent/cron只做监控汇报，不替主agent做决策或执行新步骤
- 典型错误：新session读到implementation_plan.md后自动开始执行代码patch
