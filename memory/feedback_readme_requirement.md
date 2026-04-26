---
name: README.md requirement for code directories
description: Every code working directory must have a human-readable README.md alongside CLAUDE.md, with usage examples and old-vs-new result mapping
type: feedback
---

代码工作目录（如 `<some-module>/`）必须同时维护 README.md 和 CLAUDE.md。

**Why:** 用户需要人类可读的使用指南，不只是给 Claude 看的上下文。特别需要新旧结果对照表，让用户知道重构前的哪个输出对应重构后的哪个路径。

**How to apply:** 每次新建或重构代码目录时：
- README.md：快速上手、输入输出说明、代码模块说明、新旧对照表、常见操作
- CLAUDE.md：模型细节、固定参数、调试日志等 Claude 专用上下文
- 两者各有侧重，不是同一内容的两个版本
- 这条规则已写入 skill SKILL.md 的「代码约定」section
