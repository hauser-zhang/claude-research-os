<div align="center">

# claude-research-os

**你的科研，值得一个操作系统。**

一份 Claude Code 模板，写给同时跑多个项目的科研人。
三层作用域、一个跨项目 wiki、跨 session 不丢失的决策、开箱即用的 skill。

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/powered%20by-Claude%20Code-8a63d2)](https://docs.anthropic.com/en/docs/claude-code)
[![Status](https://img.shields.io/badge/status-v1.2%20dogfooding-orange)](CLAUDE.md)

[架构细节](docs/architecture.md) · [设计哲学](docs/philosophy.md) · [ADR 目录](decisions/) · [Skill 目录](.claude/skills/_catalog.md)

**[English](README.md) | 简体中文**

</div>

---

## Research OS 是什么？

Research OS 把"多项目科研"当作一个分层操作系统来组织，跑在 Claude Code 之上。它把规则**物理拆成三层作用域**（全局 → 框架 → 单项目），让跨项目的知识在 wiki 中**复利累积**而不是散落，并把每个架构决策都写成 ADR —— 让下一个 session、甚至下个月回来都能接上。

它是**开箱即用**的：自带一批精选 skill（部分原创、部分从社区 mirror 并完整标注来源），`git clone` 即用。

---

## 问题在哪

个人科研者用 Claude Code 几周后会撞到的四件事：

> *"我们不是已经决定不用这套架构了吗？找不到讨论在哪。算了重新推一遍。"*

> *"等等，'NT-Xent loss' 我之前做那个项目时不是总结过吗？算了把 GraphCL 那篇再读一遍吧。"*

> *"Idea 在飞书里。笔记在 Notion。被否决的假设在聊天记录里。没有一处是权威源。"*

> *"我需要 A 项目的 SSH 规范。但规范和 A 的 Wave 迁移状态混一起。复制粘贴然后祈祷？"*

根因：Claude Code 默认的单个 `CLAUDE.md` + 扁平 `.claude/` 撑不起多项目科研。

---

## 解药

四个设计决策，每一条对应上面的一个问题：

| 决策 | 解决 | 在哪里 |
|------|------|--------|
| **三层作用域层叠加载** —— L1 全局 / L2 框架 / L3 项目 `CLAUDE.md` 自动叠加 | "复制粘贴然后祈祷" | 仓库根 + `projects/<name>/` |
| **Dual-Primary 知识架构** —— `wiki/` 放无时间事实，`tracks/<t>/<thread>/` 放时间序过程，双向链接 | "之前不是总结过吗" | `wiki/`（L2）+ `projects/<name>/tracks/`（L3） |
| **五阶段流程 + ADR + frictions backlog** —— 每个决策和被否决的想法都留痕 | "我们不是已经决定" | `decisions/` + `meta/` + thread 的 `00..04.md` |
| **开箱即用的 skill 集合** —— `git clone` 自带 `own/` + `upstream/`（Karpathy、superpowers 的 brainstorming / TDD / debugging） | "想法散在各处" | `.claude/skills/` |

**详细架构（图示、Dual-Primary 合同、五阶段机制、self-evolving 流程）见 [docs/architecture.md](docs/architecture.md)。**

---

## 快速开始

```bash
# 1. Clone
git clone https://github.com/hauser-zhang/claude-research-os.git
cd claude-research-os

# 2. 在 L3 建你的第一个项目（自动继承 L2 骨架）
mkdir -p projects/my-paper/{.claude,tracks}
echo "# My Paper — 项目宗法 (L3)" > projects/my-paper/CLAUDE.md
echo "# Session Handoff (L3)" > projects/my-paper/.claude/HANDOFF.md

# 3. 告诉 Claude
#    "请读 projects/my-paper/.claude/HANDOFF.md 开始"
```

完整新建项目指南：[`projects/README.md`](projects/README.md)。

---

## 仓库自带什么

Skill 在 `.claude/skills/` 下，物理拆分让 license 和作者归属一目了然。完整索引：[`.claude/skills/_catalog.md`](.claude/skills/_catalog.md)。

| Skill | 来源 | 触发场景 |
|-------|------|---------|
| [code-walkthrough](.claude/skills/own/code-walkthrough/) | **own** · MIT | 讲解 diff / PR review / 追跨层调用链 |
| [karpathy-guidelines](.claude/skills/upstream/karpathy-guidelines/) | **upstream** — [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) · MIT | 写 / review / 重构任何代码 |
| [superpowers-brainstorming](.claude/skills/upstream/superpowers-brainstorming/) | **upstream** — [obra/superpowers](https://github.com/obra/superpowers) · MIT | 任何创造性工作，实现之前 |
| [superpowers-systematic-debugging](.claude/skills/upstream/superpowers-systematic-debugging/) | **upstream** — [obra/superpowers](https://github.com/obra/superpowers) · MIT | 任何 bug / 测试失败 / 非预期行为 |
| [superpowers-test-driven-development](.claude/skills/upstream/superpowers-test-driven-development/) | **upstream** — [obra/superpowers](https://github.com/obra/superpowers) · MIT | 新功能 / bug 修复，先写测试 |

**每个 `upstream/` skill 都附 `_UPSTREAM.md`**，记录来源 URL、锁定 commit、license、作者 attribution。欢迎 PR mirror 新的高质量社区 skill —— 合同见 [ADR-0004](decisions/ADR-0004-learning-sources-and-skills-split.md)。

---

## 30 秒看懂架构

| 作用域 | 位置 | 放什么 |
|--------|------|-------|
| **L1 · 全局** | `~/.claude/` | Python / git / 测试规范 |
| **L2 · Research OS** | 本仓库 | 骨架、跨项目 wiki、skill、ADR |
| **L3 · 单项目** | `projects/<name>/` | 项目宗法、tracks、活跃 thread |

Claude Code 自带的 `CLAUDE.md` 层叠加载机制会沿目录树自动把三层拼起来，不用写任何胶水代码。

**完整图示和 Dual-Primary / 五阶段 / self-evolving 机制 → [docs/architecture.md](docs/architecture.md)。**

---

## 怎么知道系统在起作用

- **决策不再反复出现.** 第 3 周的 Claude 不会再提出第 1 周 Claude 已经否决的方案 —— 因为它被 ADR 记录了。
- **`wiki_touches:` 在增长.** 打开一个 paper 的 wiki 页，看到 3、5、7 个 thread 引用它。知识复利。
- **新项目 10 分钟内搭起来.** 两个样板文件，L2 骨架自动继承。
- **Friction backlog 每周清零.** 2 分钟实时捕获，weekly `/meta-review` 批处理。
- **每个 commit 追到一个逻辑功能.** session 结束 `git commit + push`。

如果看到反面——wiki 停滞、backlog 膨胀、ADR 没人看——去读 [`docs/philosophy.md`](docs/philosophy.md)，重新想想你真正在用哪几块。

---

## 深入阅读

| 主题 | 位置 |
|------|------|
| 完整架构（图示 + 机制） | [docs/architecture.md](docs/architecture.md) |
| 设计哲学（LLM bookkeeping / Dual-Primary / 五阶段 / Self-Evolving） | [docs/philosophy.md](docs/philosophy.md) |
| 仓库结构详图 | [docs/repo-layout.md](docs/repo-layout.md) |
| 三层作用域 ADR | [decisions/ADR-0001](decisions/ADR-0001-research-os-architecture.md) |
| Tracks + IDEAS inbox ADR | [decisions/ADR-0002](decisions/ADR-0002-tracks-and-ideas-inbox.md) |
| 开源拆分 L2/L3 ADR | [decisions/ADR-0003](decisions/ADR-0003-open-source-split.md) |
| 外部学习 + own/upstream skill 拆分 ADR | [decisions/ADR-0004](decisions/ADR-0004-learning-sources-and-skills-split.md) |
| Skill 规范（Anthropic 三层） | [CLAUDE.md §5](CLAUDE.md) |
| 引用三步验证铁律 | [.claude/rules/research-and-reporting.md](.claude/rules/research-and-reporting.md) |

---

## Inspired by

Research OS 站在下面这些项目的肩膀上。每一条都在本仓库里有**具体可验证的体现**，不是口号。

### [![](https://img.shields.io/github/stars/forrestchang/andrej-karpathy-skills?style=social&label=Star)](https://github.com/forrestchang/andrej-karpathy-skills) &nbsp; [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) · MIT

> *A single `CLAUDE.md` file to improve Claude Code behavior, derived from Andrej Karpathy's observations on LLM coding pitfalls.*

四条行为准则（Think Before Coding · Simplicity First · Surgical Changes · Goal-Driven Execution）已写进 [CLAUDE.md §12](CLAUDE.md) 作为每个 session 的默认行为，完整版 mirror 在 [`.claude/skills/upstream/karpathy-guidelines/`](.claude/skills/upstream/karpathy-guidelines/) 并锁定 commit。

### [![](https://img.shields.io/github/stars/obra/superpowers?style=social&label=Star)](https://github.com/obra/superpowers) &nbsp; [obra/superpowers](https://github.com/obra/superpowers) · MIT · by [Jesse Vincent](https://github.com/obra)

> *An agentic skills framework & software development methodology that works.*

其中三个 skill（`brainstorming`、`systematic-debugging`、`test-driven-development`）以锁定 commit + `_UPSTREAM.md` attribution 文件的方式 mirror 在 [`.claude/skills/upstream/`](.claude/skills/upstream/)。

### [![](https://img.shields.io/badge/ADR-adr.github.io-blue)](https://adr.github.io/) &nbsp; [Architecture Decision Records](https://adr.github.io/)

> *Lightweight, text-based decision records for software architecture.*

`decisions/ADR-NNNN-<slug>.md` 的格式直接来自 ADR 官方模板（frontmatter + Context / Options / Decision / Rationale / Consequences）。

### [![](https://img.shields.io/badge/Anthropic-skill--creator-8a63d2)](https://docs.anthropic.com/en/docs/claude-code) &nbsp; [Anthropic skill-creator convention](https://docs.anthropic.com/en/docs/claude-code)

> *Skills extend Claude with reusable capabilities — packaged as metadata + a SKILL.md narrative + supporting references.*

Skill 三层规范（触发描述 → SKILL.md narrative → `references/` 吸收易变细节）是 Anthropic 官方的。

---

其余设计 —— 三层作用域、Dual-Primary、五阶段、self-evolving frictions、own/upstream skill 拆分 —— 是本仓库自己的选择。

---

## 不适合的场景

- **一周做完的一次性项目.** 用不到跨 session 积累，普通 Cursor / Copilot 就够。
- **纯应用工程.** Research OS 针对假设 → 验证 → 解释的研究型工作；wiki + threads 对 feature dev 是 overkill。
- **团队协作为主.** 设计上是**单人 + Claude**。外部平台（飞书 / Notion）只是镜像不是权威源。
- **结构化数据流水线.** Snakemake / Airflow 有自己的哲学；Research OS 是研究**过程**的元层。

---

## 项目状态 & 贡献

**v1.2** · 自 2026-04 起在维护者自己的多月项目上 dogfooding。

- 架构模糊 / 缺例子 / 具体痛点 → Issue。
- 骨架改进 PR 请先开 issue 对齐方向（模板变更影响所有 fork 者）。
- 结构性变更 → propose 新 ADR（[模板](decisions/ADR-TEMPLATE.md)）。
- 社区 skill mirror 请遵守 [ADR-0004](decisions/ADR-0004-learning-sources-and-skills-split.md) 里的 license + `_UPSTREAM.md` 合同。

## License

[MIT](LICENSE) © 2026 [Hauser Zhang](https://github.com/hauser-zhang)。Upstream skill 保留各自原 license —— 见每个 skill 的 `_UPSTREAM.md`。
