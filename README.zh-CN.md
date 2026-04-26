<div align="center">

# claude-research-os

**为 AI agent 时代打造的科研操作系统。**

一份开源的 Claude Code 模板，让 PhD、科研工作者在多项目、多会话、多年的研究中沉淀知识、经验和决策——而不是把它们丢进聊天历史里。

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/powered%20by-Claude%20Code-8a63d2)](https://docs.anthropic.com/en/docs/claude-code)
[![Status](https://img.shields.io/badge/status-v1.4%20dogfooding-orange)](CLAUDE.md)

[架构细节](docs/architecture.md) · [设计哲学](docs/philosophy.md) · [ADR 目录](decisions/) · [Skill 目录](.claude/skills/_catalog.md) · [示范项目](projects/_example/)

**[English](README.md) | 简体中文**

</div>

---

## TL;DR（10 秒看懂）

1. Claude Code 会沿目录深度层叠加载多个 `CLAUDE.md` 文件。
2. 本仓库把它们组织成 **L1 全局 / L2 框架 / L3 单项目** 三层作用域，再加 wiki ⇄ threads 的知识拆分和五阶段流程。
3. `git clone` + 粘贴一句 prompt → Claude 在约 15 分钟内帮你搭好第一个项目。

> 一套给科研个人的操作系统——让你每一年的思考、决定、踩过的坑，都沉淀下来。

---

## Research OS 是什么？

Research OS 把"多项目科研"组织成一个跑在 Claude Code 之上的分层操作系统。

每天和 AI agent 一起工作，科研生涯的瓶颈变了。生成文字和代码是便宜的；**在几十个 session 之间组织"我已经决定了什么、学到了什么、排除了什么"才是真正的瓶颈**。同时跑多个项目的 PhD 和科研工作者总会撞到同一组墙——决策消失在聊天历史里，文献被第三次重读，想法散落在飞书 / Notion / GitHub issue，一旦第二个项目进来，单个 `CLAUDE.md` 直接崩塌。

`claude-research-os` 用四个分层机制（三层作用域、Dual-Primary 知识、五阶段流程、开箱即用的 skill）解决这个问题，还自带一个可跑的示范项目——一句话 prompt 给 Claude，~30 分钟内你就有了自己的第一个项目。

**开箱，和 Claude 说句话，跑你的研究。**

---

## 问题在哪

个人科研者用 Claude Code 几周后会撞到的四堵墙：

> *"我们不是已经决定不用这套架构了吗？找不到讨论在哪。算了重新推一遍。"*

> *"等等，'NT-Xent loss' 我之前做那个项目时不是总结过吗？算了把 GraphCL 那篇再读一遍吧。"*

> *"Idea 在飞书里。笔记在 Notion。被否决的假设在聊天记录里。没有一处是权威源。"*

> *"我需要 A 项目的 SSH 规范。但规范和 A 的 Wave 迁移状态混一起。复制粘贴然后祈祷？"*

根因：Claude Code 默认的单个 `CLAUDE.md` + 扁平 `.claude/` 撑不起多项目科研。**session 很便宜，跨 session 的连续性才是缺的东西。**

---

## 为什么用户会留下来

第一周内你就能感受到的五条具体收益：

### 1. 每次 session 只需一句话——Claude 自己找到要读的文件

你不用记"这次要先读哪个文件"。你说**"请读 `.claude/HANDOFF.md`"**，Claude 自己走 routing 表：它问你做哪个项目，加载那个项目的 `CLAUDE.md`，读项目的 `HANDOFF.md` 找当前活跃 thread，确认你在哪个阶段。Dispatcher 覆盖六种任务模式（科研 / 写作 / 文献学习 / 日程 / 代码讲解 / meta 自演化）。见 [`.claude/HANDOFF.md`](.claude/HANDOFF.md)。

### 2. `git clone` 下来就是可跑的骨架 + 工作示范

你不用盯着空 `projects/` 想"什么东西放哪"。[`projects/_example/`](projects/_example/) 是一个完整的 meta 项目，Brainstorm 和 Survey 阶段文档已填好——"Stage 00 / Stage 01 做完了长什么样"一目了然。告诉 Claude"参考 `_example/` 的形状"，它会按样本去搭你的项目，不靠幻觉。

### 3. 科研过程 vs 论文写作——物理分开，不再混为一谈

写论文的时候你**不想**让行文、活实验的决策、被否决的假设叙事挤在同一个页面。Research OS 把它们物理隔开：

- **`projects/<name>/tracks/<track>/<thread>/`** —— 你活的研究过程（五阶段：brainstorm、survey、proposal、implement、experiment）
- **`writing/<target>/`** —— 论文级素材：章节结构、Figure 目录、每个 Panel 的五层写作素材

一个 thread 的实验阶段结束后，你在合适时机把精选的 figure 和 metadata 复制到 `writing/<target>/`——thread 的 `results/` 保持"实验真相"，`writing/` 是"精修发表稿"。见 [`writing/_index.md`](writing/_index.md)。

### 4. "科研归档头疼"这个问题已经被解决了

做完一个研究后最痛的事情之一是"怎么把它放到飞书 / Notion / Confluence 上，让未来的我还能读懂？"Research OS 自带一整套外部平台镜像工作流 [`.claude/rules/writing-and-archival.md`](.claude/rules/writing-and-archival.md)：文档类型规范、Writing Material 五层结构、引用三步验证铁律；还有独立的图表风格规范 [`figure-style-guidelines.md`](.claude/rules/figure-style-guidelines.md)。告诉 Claude"把这个 thread 的结果推到飞书"，规则自动激活。飞书和 Notion 两套 playbook 都放在 [`.claude/rules/platforms/`](.claude/rules/platforms/)——含配置 checklist + 最小可验证命令。

### 5. 预装 skill 在正确时机自动触发

不需要 `/plugin install`。`git clone` 就得到五个 skill，它们在正确时刻自动加载：

| Skill | 来源 | 触发场景 |
|-------|------|---------|
| [code-walkthrough](.claude/skills/own/code-walkthrough/) | **own** · MIT | 讲解 diff / PR review / 追跨层调用链 |
| [karpathy-guidelines](.claude/skills/upstream/karpathy-guidelines/) | [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) · MIT | 写 / review / 重构任何代码——同时以压缩版写进 [CLAUDE.md §12](CLAUDE.md) 作为默认行为 |
| [superpowers-brainstorming](.claude/skills/upstream/superpowers-brainstorming/) | [obra/superpowers](https://github.com/obra/superpowers) · MIT | 任何创造性工作，实现之前——**包括帮你搭第一个项目** |
| [superpowers-systematic-debugging](.claude/skills/upstream/superpowers-systematic-debugging/) | [obra/superpowers](https://github.com/obra/superpowers) · MIT | 任何 bug / 测试失败 / 非预期行为 |
| [superpowers-test-driven-development](.claude/skills/upstream/superpowers-test-driven-development/) | [obra/superpowers](https://github.com/obra/superpowers) · MIT | 新功能 / bug 修复，先写测试 |

完整索引 + attribution：[`.claude/skills/_catalog.md`](.claude/skills/_catalog.md)。每个 `upstream/` skill 都附 `_UPSTREAM.md`，记录来源 URL、锁定 commit、license、作者 attribution。

### 6. 内置跨项目 feedback memory——不是规则，是踩过的坑

[`memory/`](memory/) 附带 ~20 条脱敏后的 feedback notes，来自维护者跨多个科研项目的真实经验：飞书/Notion markdown 坑、SSH heredoc 陷阱、图表 pipeline、Opus token 防护、session 边界纪律。**一位研究者的踩坑记，不是 prescriptive 规则**——采纳、删除、追加皆可。私有条目（`user_*.md` / `private_*.md`）通过 `.gitignore` 本地保留。

---

## 快速开始

### 推荐路径：让 Claude 帮你搭第一个项目

本仓库是个 Claude Code 模板——最快上手方式是让 Claude 读完模板 + 自带示范项目，直接生成你自己的项目。

**Step 1 — clone：**

```bash
git clone https://github.com/hauser-zhang/claude-research-os.git
cd claude-research-os
```

**Step 2 — 在这个目录开 Claude Code，粘贴这段 prompt：**

> Please read `.claude/HANDOFF.md`, `CLAUDE.md`, `projects/README.md`, and `projects/_example/` thoroughly. Then use the `superpowers-brainstorming` skill to help me create `projects/<my-project-slug>/` for my actual research project — explore the project goals, track partition, baseline, and remote environment before generating any files. Use `projects/_example/` as the shape reference.

Claude 会做这几件事：

1. `.claude/HANDOFF.md` 的 routing 表告诉 Claude 这是"新项目 bootstrap"任务
2. Claude 读 `_example/` 学习真实 L3 项目长什么样
3. brainstorming skill 因为你提到了它自动触发——Claude 带你走 5–10 个关于你研究的问题（研究问题、track 划分、baseline、远程环境、活假设）
4. Claude 生成 `projects/<your-slug>/`，里面 `CLAUDE.md`、`.claude/HANDOFF.md`、track `_index.md`、第一个 thread 的 Stage 00（来自刚才的 brainstorm 对话）全部填好

总耗时 **15–30 分钟**，而且 brainstorm 对话本身**就是**第一个 thread 的 Stage 00——零浪费。

**Step 3 — 日常使用。** 之后每次 session，流程都一样：

> 请读 `.claude/HANDOFF.md` 继续

HANDOFF dispatcher 问你做哪个项目，加载对应 L3 文件，把你放回活跃 thread 的当前阶段。

<details>
<summary><b>手动搭建</b> —— 离线、不用 AI</summary>

```bash
# git clone + cd 之后：
cp -r projects/_example projects/my-project
cd projects/my-project
rm HOW-TO-USE-THIS-EXAMPLE.md    # 删除只给示范用的说明文件
# 然后手工编辑每一个文件，把示范内容换成你自己的
```

离线可用，但慢——每个 section 的内容要你自己重新推一遍，而不是让 Claude 按你的项目去裁剪。完整新建项目指南：[`projects/README.md`](projects/README.md)。

</details>

---

## 第一周路线图

| 第几天 | 做什么 | 产出位置 |
|-------|-------|---------|
| Day 1 | clone、粘贴 HANDOFF prompt、从 `_example/` 出发 brainstorm 出你第一个项目 | 生成 `projects/<slug>/` |
| Day 2–3 | 按自己的节奏写第一个 thread 的 Stage 00 → 01 → 02 | `tracks/<t>/<thread>/{00,01,02}.md` |
| Day 4 | 撞到 friction？追加一行，不要纠结放哪 | `tracks/<t>/<thread>/frictions.md` |
| Day 5+ | 一篇 paper 只在你第二次重读它时才进 wiki | `wiki/papers/<slug>.md` |
| 第二周 | 从累积的 friction 做第一次 meta-review | `meta/reviews/YYYY-MM-DD.md` |

---

## 四个核心机制

| 机制 | 解决 | 在哪里 |
|------|------|--------|
| **三层作用域层叠加载** —— L1 全局 / L2 框架 / L3 项目 `CLAUDE.md` 自动叠加 | "复制粘贴然后祈祷" | 仓库根 + `projects/<name>/` |
| **Dual-Primary 知识架构** —— `wiki/` 放无时间事实，`tracks/<t>/<thread>/` 放时间序过程，双向链接 | "之前不是总结过吗" | `wiki/`（L2）+ `projects/<name>/tracks/`（L3） |
| **五阶段流程 + ADR + frictions backlog** —— 每个决策和被否决的想法都留痕 | "我们不是已经决定" | `decisions/` + `meta/` + thread 的 `00..04.md` |
| **科研过程 ⇄ 论文写作分离** —— 活过程在 `tracks/`，论文素材在 `writing/<target>/` | 实验决策和论文行文混在一起 | `projects/<name>/tracks/` + `writing/` |

详细图示和机制 → [docs/architecture.md](docs/architecture.md)。

---

## 30 秒看懂架构

```
~/.claude/                  (L1 · 全局)
  └─ 编码 / 测试 / git 规范

research-os/                (L2 · 本仓库 —— 框架层)
  ├─ CLAUDE.md              ← 框架宪法
  ├─ .claude/rules/         ← 归档工作流
  ├─ .claude/skills/        ← 预装 skill
  ├─ wiki/                  ← 跨项目长期知识
  ├─ raw/                   ← 原始源（只读）
  ├─ learning/              ← 阅读消化
  ├─ writing/               ← 论文素材
  ├─ journal/               ← 每日日记
  ├─ schedule/              ← ToDo 和长期目标
  ├─ meta/                  ← 自演化层
  ├─ memory/                ← 跨项目 feedback
  ├─ decisions/             ← ADR
  └─ projects/
      └─ <your-project>/    (L3 · 单项目)
          ├─ CLAUDE.md      ← 项目宗法 + 远程环境
          └─ tracks/<t>/<thread>/
              └─ {00..04}.md  ← 五阶段流程
```

Claude Code 自带的 `CLAUDE.md` 层叠加载机制会沿目录树自动把三层拼起来，不用写任何胶水代码。

完整图示和 Dual-Primary / 五阶段 / self-evolving 机制 → [docs/architecture.md](docs/architecture.md)。

### 仓库根下每个目录是干啥的

布局照 Dual-Primary 的顺序切（**源 → 知识 → 过程 → 产出**），再加一层"自演化"在上面：

| 目录 | 干啥的 |
|------|--------|
| `projects/<name>/` | 你的科研项目（L3）——项目宗法、tracks、threads、项目专属规则 |
| `wiki/` | 跨项目的**长期知识**——paper、concept、dataset、benchmark、synthesis；Transformer、GraphSAGE 这类多项目都会引用的东西放这里 |
| `raw/` | **原始源**（只读）——论文 PDF、剪藏的 blog / GitHub 笔记、`manifest.json` |
| `learning/` | 非任务驱动的**阅读消化笔记**——大神 blog / GitHub notes / 教程看完写的消化；攒够 3 篇同主题可升级为 `wiki/syntheses/` |
| `writing/<target>/` | 每个写作目标的**论文素材库**——章节结构 + 图表目录 + 每个 Panel 的五层素材（一句话结论 / 中文段落 / 英文 PPT / 子图图例 / 论文段落） |
| `journal/` | **每日 lab notebook**——跨 thread 的流程观察、当天踩的坑 |
| `schedule/` | 跨 thread 的 **ToDo 和长期目标**——投稿 deadline、每周固定 routine |
| `meta/` | **自演化层**——frictions backlog、每周 meta-review、改进计划 |
| `memory/` | 跨项目 feedback 笔记——维护者一路踩坑攒下来的 war stories |
| `decisions/` | **ADR**——架构决策 + 当时的理由，可追溯 |

---

## 怎么知道系统在起作用

- **决策不再反复出现.** 第 3 周的 Claude 不会再提出第 1 周 Claude 已经否决的方案——因为它被 ADR 记录了。
- **`wiki_touches:` 在增长.** 打开一个 paper 的 wiki 页，看到 3、5、7 个 thread 引用它。知识复利。
- **新项目 30 分钟内搭起来.** AI 辅助 brainstorm + 一个示范项目 = 你直接跳过"什么东西放哪"这个阶段。
- **Friction backlog 每周清零.** 2 分钟实时捕获，weekly `/meta-review` 批处理。
- **结果进飞书 / Notion 不用重新想结构.** 归档规范覆盖文档结构、图表风格、引用验证——每个项目不用重新发明流程。
- **每个 commit 追到一个逻辑功能.** session 结束 `git commit + push`。

如果看到反面——wiki 停滞、backlog 膨胀、ADR 没人看——去读 [`docs/philosophy.md`](docs/philosophy.md)，重新想想你真正在用哪几块。

---

## 深入阅读

| 主题 | 位置 |
|------|------|
| 完整架构（图示 + 机制） | [docs/architecture.md](docs/architecture.md) |
| 设计哲学（LLM bookkeeping / Dual-Primary / 五阶段 / Self-Evolving） | [docs/philosophy.md](docs/philosophy.md) |
| 仓库结构详图 | [docs/repo-layout.md](docs/repo-layout.md) |
| 示范项目（含已填写的阶段文档） | [projects/_example/](projects/_example/) |
| 三层作用域 ADR | [decisions/ADR-0001](decisions/ADR-0001-research-os-architecture.md) |
| Tracks + IDEAS inbox ADR | [decisions/ADR-0002](decisions/ADR-0002-tracks-and-ideas-inbox.md) |
| 开源拆分 L2/L3 ADR | [decisions/ADR-0003](decisions/ADR-0003-open-source-split.md) |
| 外部学习 + own/upstream skill 拆分 ADR | [decisions/ADR-0004](decisions/ADR-0004-learning-sources-and-skills-split.md) |
| 飞书归档 playbook | [.claude/rules/platforms/feishu.md](.claude/rules/platforms/feishu.md) |
| Notion 归档 playbook | [.claude/rules/platforms/notion.md](.claude/rules/platforms/notion.md) |
| 图表风格规范（发表级） | [.claude/rules/figure-style-guidelines.md](.claude/rules/figure-style-guidelines.md) |
| 引用三步验证铁律 | [.claude/rules/research-and-reporting.md](.claude/rules/research-and-reporting.md) |

---

## Inspired by

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

## 适合什么人

- **同时推进 2 个以上研究项目的 PhD / 博后**
- **既写论文 / 毕业论文又跑实验的科研工作者** —— 需要把"活的决策"和"论文行文"物理隔开
- **有飞书 / Notion / Confluence 归档习惯的研究者** —— 希望按需让 Claude 把精修后的更新推到共享平台
- **希望 Claude Code 记住跨越数月而不仅仅是跨 session 的决策的人** —— wiki ⇄ threads 架构就是答案

---

## 为什么不用全自动 AI-scientist？

**一句话：两个都用。** 把有边界的子任务交给自动化 agent，把项目外环的决策和沉淀留给人自己——Research OS 就是为这个外环设计的。

[SakanaAI/AI-Scientist](https://github.com/SakanaAI/AI-Scientist)（13.4k ★，"走向完全自动化的开放式科学发现"）、[stanford-oval/storm](https://github.com/stanford-oval/storm)（28.1k ★，"用 LLM 调研一个主题，生成带引用的完整报告"）、[Future-House/paper-qa](https://github.com/Future-House/paper-qa)（8.4k ★，"对科研文档做高精度带引用 RAG 问答"）这类项目，在**边界清晰的封闭子任务**上非常强：写一篇聚焦综述、端到端查询论文库、从假设跑到出图的 synthetic ML benchmark。**遇到能塞进这种边界的子任务，直接派给它们就好**。

Research OS 补的是另一块——一位 PhD **横跨三到五年**的整体工作，这部分 autonomous 系统目前并不覆盖：

- **要动手的自然科学**：生物、化学、物理、天文。实验发生在湿实验室、合成台、望远镜、田野里；autonomous 系统可以把文献、图表、初稿做得很快，但**那一刀、那一针、那一次观测，只能人来**。
- **跨项目复利积累**：三年的决策、被否决的假设、踩通的技术栈。把"一篇 paper 写得更好"当目标函数，和把"你自己越做越熟"当目标函数，是两种不同的优化问题。
- **中间步骤可追溯**：自动化 pipeline 里第 N 步的一次无声幻觉，会一路污染到最终论文。Research OS 把"引用三步验证"（搜索 → 读原文 → 留逐字支持句）和实时 friction 捕获写成铁律——每一步中段都留下可回查的痕迹。

**本质上：同一个工作流，两个不同的层。** 需要跑某个有边界的子任务（比如"综述 X 方向"、"批量查一组 Y benchmark"），就挂一个 autonomous agent 进来当 sub-task runner；thread 负责整体历史和关键决策，agent 干苦活。**不是非此即彼，而是各干各的强项。**

---

## 不适合的场景

- **一周做完的一次性项目**——没有跨 session 积累的空间，普通 Cursor / Copilot 就够了。
- **纯应用开发**——Research OS 服务"假设 → 验证 → 解释"这条研究链路，写 feature 用 wiki + threads 太重。
- **结构化数据流水线**——Snakemake / Airflow 各有各的哲学；Research OS 是研究**过程**的元层，不抢它们的活。

---

## 项目状态 & 贡献

**v1.4** · 自 2026-04 起在维护者自己的多月项目上 dogfooding。

- 架构模糊 / 缺例子 / 具体痛点 → Issue。
- 骨架改进 PR 请先开 issue 对齐方向（模板变更影响所有 fork 者）。
- 结构性变更 → propose 新 ADR（[模板](decisions/ADR-TEMPLATE.md)）。
- 社区 skill mirror 请遵守 [ADR-0004](decisions/ADR-0004-learning-sources-and-skills-split.md) 里的 license + `_UPSTREAM.md` 合同。

## License

[MIT](LICENSE) © 2026 [Hauser Zhang](https://github.com/hauser-zhang)。Upstream skill 保留各自原 license —— 见每个 skill 的 `_UPSTREAM.md`。
