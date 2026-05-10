# Research OS — Agent 入口（Codex / 通用）

> **定位**：本仓库的主规范仍是 [`CLAUDE.md`](CLAUDE.md) 与 [`.claude/HANDOFF.md`](.claude/HANDOFF.md)。本文件只做一层薄桥接，让 Codex 或其他支持 `AGENTS.md` 的 agent 能快速进入 Research OS 的工作流。

---

## 0. 启动顺序

1. 先读 [`CLAUDE.md`](CLAUDE.md)：理解 L1 / L2 / L3 三层作用域、Dual-Primary 知识架构、五阶段研究流程。
2. 再读 [`.claude/HANDOFF.md`](.claude/HANDOFF.md)：按任务类型分流到科研项目、写作、学习、日程、代码讲解或 Meta 维护。
3. 如果任务绑定具体项目，进入 `projects/<name>/`，读取该项目的 `CLAUDE.md`；若存在 `projects/<name>/.claude/HANDOFF.md`，也一并读取。
4. 需要使用 skill 时，先查 [`.claude/skills/_catalog.md`](.claude/skills/_catalog.md)，再读取对应 `SKILL.md`。

---

## 1. 与 Claude 规范的关系

`CLAUDE.md` / `.claude/` 是本仓库的权威规范来源。不要把它们当作 Claude 专属文本；其中的规则、skills、platform playbook 都是 Markdown 形式的工作协议，Codex 可以读取并执行。

当 `CLAUDE.md` 与本文件不一致时，以 `CLAUDE.md` 为准；当 `.claude/HANDOFF.md` 给出更具体的 session 分流时，以 HANDOFF 为准。

---

## 2. Skills 使用

本仓库 skills 位于：

```text
.claude/skills/
  own/        # Research OS 自写 skills
  upstream/   # 上游镜像 skills，来源与许可证见 _UPSTREAM.md
```

常用入口：

| 场景 | 先读 |
|------|------|
| 代码变更讲解 / review | `.claude/skills/own/code-walkthrough/SKILL.md` |
| 工具 / token / OAuth / 外部平台配置，并希望边做边学 | `.claude/skills/own/guided-setup/SKILL.md` |
| 新 feature / 新分析 / 创造性方案 | `.claude/skills/upstream/superpowers-brainstorming/SKILL.md` |
| bug / 测试失败 / 异常行为 | `.claude/skills/upstream/superpowers-systematic-debugging/SKILL.md` |
| 新功能或 bugfix 需要测试驱动 | `.claude/skills/upstream/superpowers-test-driven-development/SKILL.md` |
| 写代码 / review / refactor | `.claude/skills/upstream/karpathy-guidelines/SKILL.md` |

使用上游 skill 时，尊重对应 `_UPSTREAM.md` 的来源与本地修改记录。

---

## 3. 外部平台

飞书 / Notion / Confluence 等外部协作平台只是镜像视图，不是权威来源。任何推送外部平台前，先读：

- [`.claude/rules/writing-and-archival.md`](.claude/rules/writing-and-archival.md)
- [`.claude/rules/platforms/feishu.md`](.claude/rules/platforms/feishu.md)（飞书任务）
- [`.claude/rules/platforms/notion.md`](.claude/rules/platforms/notion.md)（Notion 任务）

飞书操作优先使用 `lark-cli`。禁止自主 overwrite 整篇飞书文档，除非用户明确要求全部重写。

---

## 4. 工作边界

遵守 `.claude/HANDOFF.md` 的 session 模式边界：

| 模式 | 主要落点 | 红线 |
|------|----------|------|
| A 科研项目 | `projects/<name>/tracks/**` | 不写 `writing/**` |
| B 写作 | `writing/**` | 不改 `tracks/**` raw 素材 |
| C 文献学习 | `raw/**`、`learning/**`、`wiki/**` | 不伪造引用；重要事实需可追溯 |
| F Meta 维护 | `.claude/**`、`docs/**`、`meta/**`、`decisions/**` | 不改项目 thread / writing 产物 |

不确定当前任务属于哪种模式时，先读 `.claude/HANDOFF.md` 的任务模式分流，再行动。
