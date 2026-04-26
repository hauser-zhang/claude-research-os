---
name: Git Commit Conventions
description: Git commit 规范 — 每 session 结束必须 commit+push，按功能分 commit，chore 仅限无业务逻辑维护
type: feedback
---

每个 session 结束前必须 commit + push，不允许跨 session 积累未提交改动。

**Why:** 历史上多次出现跨 session 积累大量改动后一次性混提交，导致 commit message 无法准确描述改动内容，且难以追溯。

**How to apply:**
- 完成一个逻辑功能后立即 commit（不等 session 结束）
- `git add <specific files>`，绝不用 `git add .`
- commit 前 `git status --short` 确认 staged 文件无误
- Commit message 格式：`<type>(<scope>): <description>`
  - type: `feat`/`fix`/`refactor`/`docs`/`chore`/`perf`
  - scope: 项目/模块名（如 `model`/`eval`/`dataloader`/`config`/`docs`）
  - `chore` 仅用于无业务逻辑的维护（删 pycache、改 .gitignore），有新函数/新字段用 `feat`
- 多个独立功能拆成多个 commit（如 loss 迁移单独、可解释性模块单独）
- push: `git push origin main`
