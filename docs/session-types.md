# Session Types — Project / Writing / Meta

> **定位**：本 doc 显式定义 Research OS 中**三类 session 的责任边界**——输入、输出、红线（不允许触碰的目录 / 操作）、HANDOFF 启动入口。
> **为什么需要本 doc**（root cause）：现行规则鼓励"完成"（白名单）但没显式禁止"越界"（黑名单）。LLM 在"完成"惯性下倾向于把"顺手做的事"也做了，而每个 session 类型实际上应严格约束自己的产出范围。本 doc 把红线写明，让 LLM 在采取行动前能自检"我属于哪类 session、即将触碰的目录是否在我的允许列表内"。
> **引用**：本 doc 是 [`CLAUDE.md §3`](../CLAUDE.md) / [`.claude/HANDOFF.md §1`](../.claude/HANDOFF.md) / [`.claude/rules/writing-and-archival.md §3.0`](../.claude/rules/writing-and-archival.md) / [`writing/.claude/rules/chinese-phd-thesis.md §1.3`](../writing/.claude/rules/chinese-phd-thesis.md) 的下游引用对象。

---

## 0. 速查：三类 session 一览表

| 维度 | **Project session** | **Writing session** | **Meta session** |
|------|---------------------|---------------------|------------------|
| HANDOFF 模式 | 模式 A（科研项目） | 模式 B（写作） | 模式 F（Meta） |
| 触发关键词 | 文献调研 / Brainstorm / 实验 / 模型改进 / case study / 跑 pipeline | 写段落 / 撰写章节 / 整理 writing material / PPT 汇报 | meta-review / 整理 frictions / 加规则 / 改 skill / 写 ADR |
| 主战场目录 | `projects/<name>/tracks/<track>/<thread>/` | `writing/<target>/` | `.claude/rules/` / `.claude/skills/` / `meta/` / `docs/` / `decisions/` / 根 `CLAUDE.md` |
| 数据数字来源 | 跑实验 / 推理产生 | 引用自 thread/05（不引入新数字） | 引用自 frictions / 已有 rule（不动数据） |
| 可写到的目录（白名单） | `tracks/<track>/<thread>/00..05.md` + `tracks/<track>/<thread>/results/` + IDEAS.md / frictions.md | `writing/<target>/<section>.md` + `writing/<target>/figures/` + `writing/<target>/tables/` | rules / skills / docs / meta / decisions + 根 CLAUDE.md + HANDOFF.md |
| 严禁触碰的目录（红线） | `writing/**` | `tracks/**`（raw 素材） | `projects/<name>/tracks/**` + `writing/<target>/<section>.md` |

每类 session 的具体红线见下文 §1 / §2 / §3。

---

## 1. Project session（HANDOFF 模式 A）

### 1.1 目的

把研究方向的某个 thread 推进到下一阶段——00 brainstorm → 01 survey → 02 proposal → 03 implement → 04 experiment → 05 writing material。

### 1.2 输入（读什么）

- 项目级：`projects/<name>/CLAUDE.md` / `projects/<name>/README.md` / `projects/<name>/.claude/HANDOFF.md` / `projects/<name>/IDEAS.md`
- Track 级：`projects/<name>/tracks/<track>/_index.md`
- Thread 级：`tracks/<track>/<thread>/00..04.md`（已完成阶段是只读源；当前阶段可写）
- L2 / L3 rules 自动加载
- L2 wiki：`wiki/papers/**` / `wiki/concepts/**`（只读）作为知识参考
- L2 raw：`raw/papers/**` / `raw/clippings/**`（只读）作为原始 source

### 1.3 输出（写什么）

- **thread 阶段文档**：`tracks/<track>/<thread>/00..05.md` 的当前阶段
- **thread 产物镜像**：`tracks/<track>/<thread>/results/`（远程出图后 SCP / cp 的本地落点；spec-correct landing）
- **thread frictions**：`tracks/<track>/<thread>/frictions.md`（实时捕获）
- **IDEAS inbox**：`projects/<name>/IDEAS.md`（突发奇想 1 行）
- **thread/05 raw 素材**：journal-neutral 的五层结构（accurate + complete + 任何 journal 都能二次加工）
- **wiki 渐进拆**：`wiki/papers/<slug>.md` / `wiki/concepts/<slug>.md`（在调研过程中拆出来 stub / draft）
- **远程服务器**：业务代码 / 配置 / 数据
- **HANDOFF 同步**：项目 L3 `.claude/HANDOFF.md` 活跃 thread 状态更新

### 1.4 🔴 红线（严禁触碰）

| 红线 | 为什么 | 越界后果 |
|------|--------|---------|
| ❌ 写 / 改 `writing/<target>/**` 任何文件 | 那是模式 B 的责任；project session 提前 staging 会让 writing session 边界混乱 | 用户必须在 writing session 起笔前先验证 staging 是否对应当前节最新数据，验证成本上升 |
| ❌ SCP / cp 远程产出**直接到** `writing/<target>/figures/` 或 `writing/<target>/tables/` | 同上；正确流程是**先**落 thread `results/`，**再由 writing session** cp 到 writing/ | 跨 session 文件溯源混乱、出现"figures/ 已有但 thread/results/ 是空"的错位状态 |
| ❌ 在 thread/05-writing-material.md 中按某 journal / thesis 风格 framing | thread/05 是 **raw 素材层（journal-neutral）**——polished prose 是 writing session 的产出 | thread/05 锁死在某 voice 后，未来切到其他 target（英文 manuscript / 不同期刊）时要重写素材，违反"raw + 多目标二次加工"原则 |
| ❌ 改 `meta/**` / `.claude/rules/**` / `.claude/skills/**` / 根 CLAUDE.md | 那是模式 F 的责任 | 规则改动应批量 weekly meta-review，而非 project session 中临时见招拆招 |

### 1.5 越界自检（行动前）

发现自己即将做以下任一动作 → **立即停手 + 向用户报告**：

- 即将 Edit / Write / cp / SCP 到 `writing/**` 任何路径
- 即将在 thread/05 中加入"为投 Nature 改 voice""按学位论文风格调"等针对某 target 的 framing
- 即将改 `.claude/rules/**` 或根 CLAUDE.md

→ 报告内容：本 session 是 project session（模式 A），上述动作越界到 writing/ 或 meta/，请用户确认是否要切换 session 类型，否则改用合规替代方案（落 thread/results/ 等）。

### 1.6 HANDOFF 启动入口

1. 读 `.claude/HANDOFF.md` § 模式 A（确认本 session 是 project session）
2. `cd projects/<name>/`
3. 读项目 L3 `CLAUDE.md` + `.claude/HANDOFF.md`
4. 进 `tracks/<track>/<thread>/`，从已完成阶段文档拿上下文，推进当前阶段

---

## 2. Writing session（HANDOFF 模式 B）

### 2.1 目的

把 thread/05 raw 素材**收敛**到某个具体写作 target（中文学位论文 / 英文期刊 manuscript / 组会 PPT 等），输出按目标风格 framing 的 polished prose。

### 2.2 输入（读什么）

- writing target 入口：`writing/<target>/_index.md` / `writing/<target>/CLAUDE.md`（如有）
- writing target rules：`writing/<target>/.claude/rules/**`（如 `chinese-phd-thesis.md`）
- 各 thread/05-writing-material.md（**只读**——raw 素材源）
- 各 thread/04-experiment.md（**只读**——核对数字 / 完整原始结果）
- thread results/ 目录的 figures（**只读**——cp 到 writing 时用）
- 远程服务器原始 CSV（用 SCP 拉到 `writing/<target>/tables/`）

### 2.3 输出（写什么）

- **章节素材**：`writing/<target>/<chapter>/<section>.md`（按目标风格 framing 的 polished prose）
- **figures 目录**：`writing/<target>/figures/fig-{章}-{节}-<slug>/<panel>.svg+png` + `README.md`
- **tables 目录**：`writing/<target>/tables/tab-{章}-{节}-<slug>/<csv>` + `README.md`
- writing target index / TODO 更新

### 2.4 🔴 红线（严禁触碰）

| 红线 | 为什么 | 越界后果 |
|------|--------|---------|
| ❌ 改 `tracks/<track>/<thread>/05-writing-material.md` 等 raw 素材 | thread/05 是 project session 的产出；writing session 改了会让 raw 与 polished 双向混淆 | 后续切到其他 target（英文 manuscript）时 thread/05 已被某 target voice 污染，丧失 journal-neutral 性 |
| ❌ 改 `tracks/<track>/<thread>/04-experiment.md` / 03-implement.md / etc. | 同上；writing session 不应反向写 thread | 实验 / 实现 / brainstorm 历史叙事被 writing 视角扭曲 |
| ❌ 改 `tracks/<track>/<thread>/results/` 中的 figures / 数据 | 那是 thread 的本地 mirror | thread 与 writing 出现"同名不同内容"的不一致 |
| ❌ 在 `writing/<target>/<section>.md` 中**引入新数字 / 新结论**（thread/05 没有的） | 数字 source-of-truth 必须唯一 | reviewer 找不到溯源；下次 thread 重跑数字变了 writing/ 不知道要更新 |
| ❌ 触发新实验 / 跑远程 pipeline | 那是模式 A 的责任 | 实验产物落点错位（thread vs writing） |

### 2.5 发现 raw 素材有错误时怎么办

写作过程中发现 thread/05 / 04 数字 / 描述有错 → **不就地改 thread**，改为：

1. 在当前 `writing/<target>/<section>.md` 里相应位置加 `[TODO 待项目 session 修：<具体问题描述>]` 标记
2. 通知用户："发现 thread X 的 N 处疑问，建议下次切到 project session 处理"
3. 当前 writing session 继续——其他 panel / 段落仍可推进，错误段落保留 [TODO]
4. 用户起 project session 修完 thread 后，再起 writing session 继续

### 2.6 HANDOFF 启动入口

1. 读 `.claude/HANDOFF.md` § 模式 B
2. 读 `writing/<target>/_index.md`（target 章节目录 + 写作进度）
3. 读 `writing/<target>/.claude/rules/**`（target 专属风格规则）
4. 起笔某节前，先 panel-level audit（提取一句话结论 + 检查编号 / 路径 + 列 [TODO]），再 cp figures + 起笔正文

---

## 3. Meta session（HANDOFF 模式 F）

### 3.1 目的

让 Research OS 自演化——把项目 / 写作过程中暴露的 friction 升级为规则改进、补 ADR、改 skill、整理 backlog。

### 3.2 输入（读什么）

- `meta/frictions-backlog.md` / `meta/improvements-backlog.md`
- 各 thread / writing 中的 `frictions.md`（**只读引用**——拿路径 + 行号即可，不重写它们）
- 已有 `.claude/rules/**` / `.claude/skills/**` / `docs/**` / `decisions/**`
- 根 `CLAUDE.md` / `.claude/HANDOFF.md`
- L2 wiki / memory（只读，作为决策参考）

### 3.3 输出（写什么）

- **rules**：`.claude/rules/**`（新增 / 修改）
- **skills**：`.claude/skills/**`
- **docs**：`docs/**`（如本 doc 就是 meta session 产出）
- **ADR**：`decisions/ADR-NNNN-<title>.md`
- **meta backlog**：`meta/frictions-backlog.md` / `meta/improvements-backlog.md` 状态更新
- **meta review**：`meta/reviews/YYYY-MM-DD.md` weekly / 单次 meta-review 记录
- **根 CLAUDE.md**：仅当本次 meta-review 涉及到骨架宪法层面变更
- **HANDOFF.md**：仅当涉及到模式分流 / 资源索引变更

### 3.4 🔴 红线（严禁触碰）

| 红线 | 为什么 | 越界后果 |
|------|--------|---------|
| ❌ 改 `projects/<name>/tracks/**` 的内容 | thread 是 project session 的产出；meta session 只观察 friction，不就地改 thread | 项目工作流被 meta session 偷偷改写，用户失去对项目状态的掌控 |
| ❌ 改 `writing/<target>/**` 的内容 | 同上 | 同上 |
| ❌ 触发实验 / SCP 远程产出 / 修改业务代码 | 那是模式 A 的责任 | 数据数字层面变化只能在 project session 中可追溯地发生 |
| ❌ 在 backlog 里写"已修"但实际没改对应规则文件 | meta-review 必须有可验证产出 | backlog 状态与规则文件脱节，下次 meta-review 找不到证据 |

### 3.5 越界自检

发现自己即将做以下任一动作 → **立即停手**：

- Edit / Write 到 `projects/<name>/tracks/<track>/<thread>/` 任何文件（除非纯纠正 typo 且用户授权）
- Edit / Write 到 `writing/<target>/<section>.md`
- 起 SSH / SCP 到远程服务器执行实验

→ 报告："本 session 是 meta session（模式 F），上述动作越界到 thread / writing / 远程实验。请确认是否要切换 session 类型。"

### 3.6 HANDOFF 启动入口

1. 读 `.claude/HANDOFF.md` § 模式 F
2. 读 `meta/frictions-backlog.md`（看待 triage 条目）
3. 读 `meta/improvements-backlog.md`（看待执行条目）
4. 决定本 session 处理范围（单条 / 一批 / 一次 weekly review）
5. 改对应规则 / docs / ADR；产出 `meta/reviews/YYYY-MM-DD.md` 留痕

---

## 4. 跨 session 协作：典型场景

### 4.1 实验跑出图 → 写作

```
[Project session A] 跑 pipeline → 远程出 figures
                  ↓ SCP
                  tracks/<track>/<thread>/results/<panel>.svg+png
                  ↓ 更新 04-experiment.md / 05-writing-material.md (raw 素材)
                  ↓ git commit + push
                  ↓ session 结束（不进 writing/）

[Writing session B] 起笔某节
                  ↓ cp tracks/.../results/<panel>.* → writing/<target>/figures/fig-X-Y/
                  ↓ 引用 thread/05 raw 素材 + 改 voice → writing/<target>/<section>.md
                  ↓ git commit + push
```

### 4.2 写作中发现 raw 素材有错

```
[Writing session B] 发现 thread/04 数字疑似有误
                  ↓ writing/<section>.md 相应处加 [TODO 待项目 session 修]
                  ↓ 通知用户
                  ↓ 当前 session 继续其他段落，session 结束

[Project session A] 用户启动新 session 处理 [TODO]
                  ↓ 跑 pipeline 重核 / 修代码 → 更新 04 + 05 raw
                  ↓ session 结束

[Writing session B 第二轮] 重新起 writing session
                       ↓ cp 新 figures → 重写相关段落
```

### 4.3 Friction 升级为规则

```
[任意 session] 实时捕获 friction → 追加到 thread frictions.md / meta/frictions-backlog.md

[Meta session F]（weekly 或单次） 批 triage frictions
              ↓ 改对应规则 / 补模板 / 写 ADR
              ↓ frictions-backlog 标 resolved
              ↓ 写 meta/reviews/YYYY-MM-DD.md
              ↓ git commit + push
```

---

## 5. 维护本 doc

- v1（2026-05-03）：从 vfformer/_meta-figure-terminology-standards thread §4.3 + §4.4 暴露的 4 处 ambiguity 提炼，与 [`.claude/rules/writing-and-archival.md §3.0`](../.claude/rules/writing-and-archival.md) / [`writing/.claude/rules/chinese-phd-thesis.md §1.3`](../writing/.claude/rules/chinese-phd-thesis.md) / [`.claude/HANDOFF.md §1`](../.claude/HANDOFF.md) 同步落地
- 新增 session 类型（如 D：日程；E：代码讲解）→ 在本 doc §1-§3 模板下增段
- 红线修改 → 同步到对应 L2 / L3 rules（保持单点更新 + 多处 cross-ref 不脱节）
