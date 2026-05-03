# Research OS — Session Handoff（L2 · 通用任务分流）

> **本文件职责**：新 session 启动时**通用的任务模式分流 + 规则/skill 索引**。项目专属的活跃 thread / 当前 baseline / Wave 迁移状态等**不进本文件**——它们在 L3 `projects/<name>/CLAUDE.md` 和 `projects/<name>/.claude/HANDOFF.md`。
> **上位骨架**：仓库根 `CLAUDE.md`（架构规范）会自动加载。
>
> 新 session 开始时，告诉 Claude：**"请读 `.claude/HANDOFF.md` 开始"**。

---

## 0. 启动顺序

0. **Template bootstrap 检查**（见 `CLAUDE.md §13`）：扫描 7 对 `template` / `local` 文件（`wiki/index` · `wiki/log` · `writing/_index` · `learning/_index` · `schedule/_index` · `journal/_index` · `raw/manifest`）。对只有 `.template` 缺本地文件的，询问用户是否 `cp` 初始化。首次 clone 仓库的用户会在这一步把框架骨架变成自己的工作空间。
1. 本文件（任务分流 + 规则/skill 索引）
2. 仓库根 `CLAUDE.md`（L2 骨架，三层作用域、五阶段流程、sub-agent 规则）
3. 如果任务绑定某个项目 → `cd projects/<name>/`
   - Claude Code 自动层叠加载 L3 `projects/<name>/CLAUDE.md`（项目宗法）
   - 再读 `projects/<name>/.claude/HANDOFF.md`（当前活跃 thread + 下一步候选）
4. 询问用户本次要做什么任务

---

## 1. 任务模式分流

> **🔴 模式互斥（铁律）**：每个 session 只属于**一种模式**。模式 A / B / F 互不越界——模式 A 不写 `writing/**`；模式 B 不改 `tracks/**` raw 素材；模式 F 不动 `projects/**` / `writing/**` 内容。完整责任矩阵 + 红线清单见 [`docs/session-types.md`](../docs/session-types.md)。
> **如何识别本 session 是哪种模式**：看用户首句任务在哪个目录树下落地。`projects/<name>/tracks/**` → A；`writing/**` → B；`.claude/rules/**` / `meta/**` / `docs/**` / 根 `CLAUDE.md` → F。
> **模式越界自检**：发现自己即将 Edit / Write / SCP 到本模式红线目录 → 立即停手 + 向用户报告"我快越界"，等用户授权切换 session 类型才继续。

### 模式 A — 科研项目（走 track → 五阶段 thread）

**触发关键词**：Brainstorm、文献调研、实验、模型改进、case study……

**步骤**：

1. 确认属于哪个项目 → `cd projects/<name>/` 让 Claude Code 自动加载 L3 CLAUDE.md + `.claude/`
2. 读项目 `README.md`（总览 + track 列表 + 状态表）获取全局地图
3. 读 L3 `CLAUDE.md`（项目宗法：远程环境、track 盘点、Wave 终态、铁律速查）
4. 读 L3 `.claude/HANDOFF.md`（当前活跃 thread + 下一步候选，动态）
5. 确认属于哪个 **track** → 读 `tracks/<track>/_index.md` 获取本方向 why + 成功判据 + 子任务
6. 确认属于哪个 **thread** → 进入 `tracks/<track>/<thread>/`
7. 确认所在阶段（00-brainstorm / 01-survey / 02-proposal / 03-implement / 04-experiment / 05-writing-material）

**新方向（新 track）**：先在 `projects/<name>/README.md` 总览表加行 → 建 `tracks/<new-track>/_index.md`（填 why + 判据）→ 再建具体 thread 目录。

**新任务（已有 track 下）**：直接 `tracks/<existing-track>/<new-thread>/`，走五阶段。

**突发奇想快速落下来**：写一行到 `projects/<name>/IDEAS.md` inbox（成本 2 分钟），不立即建 thread；weekly meta-review 时 triage。

**🔴 模式 A 红线**：

- ❌ **禁止**写 / 改 `writing/**` 任何文件（包括 `writing/<target>/figures/` / `writing/<target>/tables/` / `writing/<target>/<section>.md`）——这是模式 B 的责任
- ❌ **禁止** SCP / cp 远程产出直接到 `writing/<target>/figures/`——只能落 thread `tracks/<track>/<thread>/results/`
- ❌ thread/05-writing-material.md 是 **raw 素材层（journal-neutral）**——不写按某 journal / thesis 风格 framing 的 polished prose（那是 `writing/<target>/<section>.md` 的事）
- ✅ 所有 figures / tables / writing material **仅落 thread/**；用户起 writing session 时 cp 出去
- 详见 [`docs/session-types.md`](../docs/session-types.md) §"模式 A 红线"

---

### 模式 B — 写作（论文 / 毕业论文 / 组会）

**触发关键词**：写段落、撰写章节、整理 writing material、PPT 汇报……

**入口**：[`writing/_index.md`](../writing/_index.md)

**关键规则**：

- Writing Material 五层结构：一句话结论 + 中文结果段落 + 英文 PPT 文字 + 子图图例 + 论文段落草稿 + 总图例。文档开头必须有 Analysis metadata。
- 先做 panel-level audit（提取一句话结论、检查编号/路径一致性、列 TODO），再输出。
- 学术措辞用"提示""表明""与…一致"，避免"证明""必然"。

**🔴 模式 B 红线**：

- ❌ **禁止**改 `tracks/**` raw 素材（包括 thread/05-writing-material.md / 04-experiment.md / `tracks/<track>/<thread>/results/`）——它们是模式 A 的产出
- ❌ **禁止**在 `writing/<target>/<section>.md` 中**引入新数字 / 新结论**（必须从 thread/05 引用 + 改 voice；发现需要新数字 → 标 `[TODO]` + 通知用户回模式 A 重跑）
- ✅ 只 cp 现有 thread `results/` figures + 引用 thread/05 数字 → 写**新** prose（按目标 journal / thesis 风格 framing）
- ✅ 发现 thread/05 raw 素材有错误 → 在 writing 文档标 `[TODO 待项目 session 修]`，**不就地改 thread**
- 详见 [`docs/session-types.md`](../docs/session-types.md) §"模式 B 红线"

---

### 模式 C — 文献学习（非任务驱动）

**触发关键词**：读这篇论文、学习某个概念、了解领域……

**入口**：[`learning/_index.md`](../learning/_index.md)

**落盘去向**：

- 原始 PDF → `raw/papers/<slug>.pdf`（跨项目共享）
- 网页 clipping → `raw/clippings/<slug>.md`
- 读后产出 → `wiki/papers/<slug>.md` 或 `wiki/concepts/<slug>.md`（渐进拆）

---

### 模式 D — 日程 / ToDo

**入口**：[`schedule/_index.md`](../schedule/_index.md)

---

### 模式 E — 代码变更讲解

**触发关键词**：讲解代码、解释改动、理解某次重构……

**必读 skill**：[`.claude/skills/own/code-walkthrough/SKILL.md`](skills/own/code-walkthrough/SKILL.md)

---

### 模式 F — Meta（系统自我演化）

**触发关键词**：meta-review、整理 frictions、加规则、改 skill……

**入口**：

- [`meta/frictions-backlog.md`](../meta/frictions-backlog.md)
- [`meta/improvements-backlog.md`](../meta/improvements-backlog.md)
- [`decisions/`](../decisions/) — 架构决策 ADR

**🔴 模式 F 红线**：

- ❌ **禁止**修改 `projects/<name>/tracks/**` 或 `writing/<target>/**` 的内容（thread / writing 是 A / B 的产出，meta 只观察）
- ❌ **禁止**触发实验、SCP 远程产出、修改业务代码——那是模式 A 的职责
- ✅ 只动**规则 / skill / docs / meta backlog / ADR**：`.claude/rules/**` / `.claude/skills/**` / `docs/**` / `meta/**` / `decisions/**` / 根 `CLAUDE.md` / `.claude/HANDOFF.md`
- ✅ 引用 thread / writing 的 frictions 时**只读**（路径 + 行号）；不修改这些文件
- 详见 [`docs/session-types.md`](../docs/session-types.md) §"模式 F 红线"

---

## 2. L2 资源索引

### Skill（`.claude/skills/`）

| Skill | 做什么 | 何时触发 |
|-------|--------|---------|
| [code-walkthrough](skills/own/code-walkthrough/SKILL.md) | 代码变更 5 层结构化讲解 | 讲解 diff / review / 解释跨层调用链 |

### Rules（`.claude/rules/`）

| Rule | 做什么 | 何时触发 |
|------|--------|---------|
| [research-and-reporting.md](rules/research-and-reporting.md) | 文献调研必须到可复现级，引用三步验证（搜索→读原文→留痕） | 任何文献调研 / 汇报 / 讨论输出 |
| [figure-style-guidelines.md](rules/figure-style-guidelines.md) | 期刊级图表规范（SVG+PNG、字体、色板、尺寸） | 生成任何放入论文/PPT/外部平台的图 |
| [writing-and-archival.md](rules/writing-and-archival.md) | 通用写作/存档总则：文档结构、Writing Material 五层、联动规则（平台无关） | 写 Writing Material、更新主文档、推任何外部平台 |
| [platforms/feishu.md](rules/platforms/feishu.md) | 飞书专属：Setup、lark-cli 命令、markdown 坑点 | 推飞书时 |
| [platforms/notion.md](rules/platforms/notion.md) | Notion 专属：MCP 配置、integration share、markdown 差异 | 推 Notion 时 |
| [rerun-vs-archive.md](rules/rerun-vs-archive.md) | 修 bug/改风格后清旧重跑 vs 保留旧版（判据=运行时间） | 实验产出更新 |

---

## 3. 项目入口

当前挂载的项目见 [`projects/README.md`](../projects/README.md)。每个项目自己的 L3 CLAUDE.md 承接：定位、远程环境、track 盘点、Wave 迁移状态、铁律速查。

**新项目接入流程**：见 `projects/README.md`"新建项目指南"。

---

## 4. Memory 入口

- [memory/MEMORY.md](../memory/MEMORY.md) — L2 跨项目 memory 索引（user + 跨项目 feedback）
- 项目专属 memory：各项目 L3 CLAUDE.md 标明位置

---

## 5. 通用铁律（高频提醒）

| 规则 | 展开位置 |
|------|---------|
| Session 边界：旧 plan 不自动执行，等用户显式授权 | memory/feedback_session_boundary.md |
| 长任务后台 sub-agent 轮询，主 agent 保持空闲 | memory/feedback_long_task_monitoring.md |
| 每 session 结束 git commit + push，按功能分 commit | memory/feedback_git_commit.md |
| 引用三步验证（搜索→读原文→留痕） | `.claude/rules/research-and-reporting.md` |
| 外部协作平台 = 镜像视图，不是权威来源 | 根 `CLAUDE.md` §7 |
| Opus 下大规模外部写入先暂停报告 | memory/feedback_opus_token_guard.md |
| sub-agent 编排 + staging pattern | 根 `CLAUDE.md` §11 |

---

## 6. 维护本文件

- **L2 HANDOFF 只放通用分流 + L2 资源索引**——不写具体项目的活跃 thread / 下一步候选（那是 L3 HANDOFF 的事）
- 新增 L2 skill/rule → 更新 §2 表格
- 新增任务模式 → 添加模式 G/H
