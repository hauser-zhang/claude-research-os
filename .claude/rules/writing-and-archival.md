# 写作与存档规范（L2 · 跨项目通用 · 平台无关）

> **定位**：本地 md 是**权威源**，外部协作平台（飞书 / Notion / Confluence / ...）是**镜像视图**（分享给导师、合作者）。本规则定义镜像的结构、同步时机、内容组织原则，不绑定具体平台。
> **适用**：所有科研项目。
> **平台专属接入**（MCP/CLI/API、markdown 坑点、上传流程）：见 `platforms/feishu.md`、`platforms/notion.md`。
> **项目专属的文档树结构**（tag 规范、父子关系）：见 `projects/<name>/.claude/rules/<platform>-doc-structure.md`（如 `feishu-doc-structure.md`）。

---

## 1. 核心原则

- **本地 md 是源**：每个 thread 的五阶段文档、writing 素材、ADR 只在本地产出
- **外部平台是镜像**：从本地 md 按需 push 到平台，共享给导师 / 合作者
- **单向推送**：平台 UI 上的修改不驱动本地；若用户在平台手改了，Claude 在下次 pull 时会指出 diff 并询问如何 merge
- **触发即推送**：用户显式说"更新到 <平台>"/"推到 <平台>"时 Claude 才 push，不自动同步

---

## 2. 本地 → 镜像页面的映射

| 本地路径 | 镜像页面类型（Tag） | 同步方式 |
|---------|-------------|---------|
| `tracks/<track>/<thread>/00-brainstorm.md` | `[Brainstorm]` 子页 | 结构化精简（讨论演进表 + 决策表）|
| `tracks/<track>/<thread>/01-survey.md` | `[Survey]` 子页 | 文献 + 对比表精简推送 |
| `tracks/<track>/<thread>/02-proposal.md` | `[Ideas]` 子页 | 方案设计推送 |
| `tracks/<track>/<thread>/03-implement.md` | `[Implementation]` 子页 | Changelog 摘要表 + 详细变更记录 |
| `tracks/<track>/<thread>/04-experiment.md` | `[Experimental Results]` 子页 | 数据表 + 图片清单 |
| `writing/<target>/<chapter>/<section>.md` | `[Writing Material]` 子页 | 五层内容 + Analysis metadata |
| `projects/<name>/README.md` | 项目主文档（索引 + 更新日志） | 追加一行更新日志 |

Tag 体系（`[Brainstorm]` / `[Survey]` / `[Ideas]` / `[Implementation]` / `[Experimental Results]` / `[Writing Material]` / `[Report]`）为**跨平台统一约定**。不同平台可能把"页面"具象为不同对象（飞书文档子页、Notion database page），但 Tag 一致。

**具体父子结构**（哪些子页归属哪个模块）见对应 L3 rule：`projects/<name>/.claude/rules/<platform>-doc-structure.md`。

---

## 3. Writing Material 五层内容结构（生成本地 md 时必须遵循）

### 3.0 两类宿主、两种语义（消除 ambiguity）

"五层结构"在 Research OS 中**有两个不同宿主**，语义不同——历史上两处 rule 都说"必须遵循五层结构"导致 LLM 混淆（2026-05-02 vfformer/_meta-figure-terminology-standards thread §4.4 暴露）。明确区分：

| 宿主 | 性质 | 写什么 | 何时写 |
|------|------|--------|--------|
| **`tracks/<track>/<thread>/05-writing-material.md`**（thread 五阶段终点）| **Raw 素材层 / data-grounded**（accurate + complete + journal-neutral，任何目标 journal 都能二次加工）| 一句话结论 + 中文段落（含完整数字 / 比较 / 解释 / 边界）+ PPT 英文 + 子图图例 + 论文段落草稿 + 总图例 + Analysis metadata | thread 进入 04 后，外部协作前必经一步 |
| **`writing/<target>/<chapter>/<section>.md`**（写作 target 章节素材）| **Polished prose 层**（按目标 journal / thesis / 组会风格 framing；不引入 thread/05 之外的新数字）| 同样字段，但已按目标风格收敛措辞（学位论文 vs Nature 投稿 voice 不同）+ 三层溯源路径块（远程 / thread / writing）+ inline 图表渲染 | writing session 起笔时从 thread/05 cp 后改写 |

**关键 invariant**：

- **数据数字只在 thread/05 第一次落地**。`writing/<target>/<section>.md` 只允许从 thread/05 *引用 + 改 voice*，不允许 *引入新数字*。若发现某结论需要新数字 → 回 thread 04 重跑实验补 → 回流到 thread/05 → 再 cp 到 writing/。
- **thread/05 → writing/<section> 是单向的**：writing session 改 prose **不污染** thread/05；thread 重跑后回流走"writing/<section> 显式重 cp"流程，不自动同步。

**🔴 红线（黑名单）—— Session 边界**：

| Session 类型 | 允许写 | 严禁写 |
|-------------|--------|--------|
| **Project session**（任务在 `tracks/<track>/<thread>/`）| ✅ 写 / 改 `tracks/<track>/<thread>/05-writing-material.md`（raw 素材层） | ❌ **禁止**写 / 改 `writing/<target>/**`（polished 是 writing session 的责任） |
| **Writing session**（任务在 `writing/<target>/`）| ✅ 写 / 改 `writing/<target>/<section>.md`（polished prose 层） | ❌ **禁止**改 `tracks/<track>/<thread>/05-writing-material.md` 等 raw 素材（只读引用 + cp）。发现 raw 错误 → 标 `[TODO]` + 通知用户回 project session 修 |

下面 §3.1–§3.3 描述的是**两类宿主共同的字段骨架**；具体 voice / framing 差异由各自的上位规则覆盖（thread/05 voice 见 L2 `research-and-reporting.md`；`writing/<target>/<section>.md` voice 见对应 `writing/<target>/.claude/rules/<target-style>.md`，例如 `writing/.claude/rules/chinese-phd-thesis.md`）。

### 3.1 字段骨架（thread/05 与 writing/<section> 共同）

每个 Panel / 结果模块必须包含：

1. **详细中文结果段落**
   - 引用具体数字、比较对象、统计口径
   - 观察 → 比较 → 解释 → 边界（按此顺序）
   - 允许充分展开，但避免空泛
   - 例：`Sample class X occupancy 51.9%`、`Top 10 中 8 个属于 Pathway Y`

2. **PPT 页内文字（标准英文）**
   - 一句 take-home title + 2–4 bullets
   - 面向答辩 / 组会页面本身
   - 只保留该页最重要的信息

3. **子图图例（中文）**
   - "（A）（B）（C）" 格式
   - 说明：展示什么 / 颜色 / 横纵轴 / 分组
   - 不写长篇解释（解释在正文）

4. **论文段落草稿（全文级，文档末尾）**
   - 英文学术论文 Results 段落的中文压缩版
   - 更紧凑、更偏学术表述
   - 串联多个 Panel 成连续论证，而非逐图复述

5. **整张 Figure 总图例（中文）**
   - Figure 总标题 + 按 (A)(B)(C) 依次概括
   - 用于翻译为英文学术论文图例

### 每 Panel 固定槽位（按此顺序）

- **一句话结论**：这张图唯一最重要的发现
- **图文件路径**：服务器名 + 绝对路径（如 `<server>:/data/<lab>/<project>/...`）
- 详细中文结果段落 / PPT 英文 / 子图图例
- **补充备注 / TODO**（可选）

### Analysis metadata（文档开头必填）

```yaml
model:
evaluation mode:
dataset split / sample size:
task granularity / number of classes:
ablation protocol:
primary metric:
baseline definition:
source result table:
figure path:
script path:
prerequisite docs:
```

缺项必须标 `[TODO] 待补充`，不可省略字段。

---

## 4. 各类文档的概览区（视觉先行原则）

**核心：读者 30 秒扫完概览区应该 get 到全貌，再决定是否深入。**

| 文档类型 | 概览区形式 |
|---------|-----------|
| Brainstorm | 思维导图（平台画板 / whiteboard，必须） |
| Survey | 对比表格（方法 / 论文横向对比，必须） |
| Ideas / Proposal | 实施路线总览表（Phase × 工作量 × 收益） |
| Implementation | Changelog 摘要表（必须）+ 数据流图 / 目录结构 |
| Experimental Results | 核心指标摘要表（精选关键数字） |
| Writing Material | Analysis metadata 表 |
| Report | 关键发现 bullet list（3–5 条） |

**排版优先级：图表 > 表格 > 文字。** 能用表格的不用段落，能用图的不用表格。

---

## 5. Brainstorm 内容结构（决策记录 ≠ 对话记录）

固定顺序：

1. **思维导图**：中心问题 → 子问题 → 结论/决策；用 ❓问题 / ✅结论 / ❌排除 三色节点
2. **讨论演进表**：

   | 轮次 | 问题 / 假设 | 验证 / 发现 | 结论 |
   |------|------------|------------|------|
   | 1 | xxx | xxx | ✅ / ❌ xxx |

   每行 = 一次认知迭代（包括被推翻的假设，标 ❌ 即可），一行 1-2 句话
3. **关键决策表**：

   | 决策点 | 选择 | 理由（1句） | 排除方案（1句） |

4. **行动计划表**（只保留最终版，旧版直接删除）：

   | 优先级 | 行动 | 状态 | 工作量 |

5. **文字细节（可选，后置）**：需要完整推导 / 代码分析时放在这里，不重复前面表格

### Brainstorm 排除规则

| 禁止内容 | 应放哪里 |
|---------|---------|
| 数值实验完整表格 | [Experimental Results] |
| 文献综述 | [Survey] 子页 |
| 代码片段（> 5 行） | [Implementation] |
| 旧版本行动计划 | 直接删除 |
| 被推翻假设的完整论证 | 演进表里一行 ❌ 即可 |

---

## 6. Implementation 文档结构（持续演进，只加不改）

### 固定结构（顺序不可变）

```
[顶部] Changelog 摘要表   ← 唯一需要随每次修改同步更新
[中部] 静态概览区         ← 目录结构、数据流、运行方式（稳定后少改）
[底部] 详细变更记录       ← 每次修改追加一节，只加不改
```

### Changelog 摘要表

| 日期 | 触发问题/Bug | 变更内容（做了什么） | 涉及模块/文件 |
|------|------------|-------------------|-------------|

**规则**：
- 每次追加内容 → 同步加一行
- **触发问题/Bug 不可省略**（这是变更的"因"）
- 变更内容 ≤ 20 字
- 涉及模块/文件只写核心文件名（逗号分隔，不加路径前缀）
- 只加行，不删除历史行

### 详细变更记录区

- 每次变更新增 `## YYYY-MM-DD 标题` 二级节
- 包含：背景（1 句）、改动清单表格、关键设计决策
- 节标题与摘要表变更主题一致
- **只追加，不修改已有节**（历史记录不可变）

---

## 7. Experimental Results vs Writing Material 的界限

| | Experimental Results | Writing Material |
|---|---|---|
| **面向** | 存档溯源 | 论文写作 |
| **数据** | 完整原始表格（所有类别、所有指标） | 精选关键数据（Top 5/10 + 故事线相关） |
| **文字** | 简短统计结论 + 一句话解读 | 五层结构（见 §3） |
| **文件路径** | 完整输出清单 + 脚本路径 | 仅 Figure 图文件路径 |
| **文献** | 不需要 | 每个生物学结论必须配文献（三步验证） |

### Experimental Results 禁止内容

| 禁止内容 | 应放哪里 |
|---------|---------|
| 代码变更列表 | [Implementation] |
| 数据生成 / PKL 说明 | [Implementation] |
| 训练 bug + 代码 diff | [Implementation] |
| 训练启动时间 / GPU / config（独立 section） | 实验对比表的**备注列**，一句话 |
| 训练进度快照（"当前 epoch X, AUPR=Y"） | 完成后直接更新对比表；训练中不记录快照 |
| "当前活跃 run: ..." 临时路径（独立 section） | 对比表备注列 |

**核心**：Experimental Results = Analysis Metadata + 实验设计摘要 + 对比表格。其他都去 Implementation 或备注列。

---

## 8. 结果段落逻辑顺序（铁律）

每段结果文字按：
1. **观察**（Observed result）：图中 / 表中直接看到什么
2. **比较**（Comparison）：哪个高 / 低，差多少
3. **解释**（Interpretation）：这些数据说明什么
4. **边界**（Boundary / Caveat）：适用范围、替代解释、未完成项

**禁止从图直接跳到生物学结论，必须经过数据层面过渡。**

---

## 9. 学术措辞

| 优先使用 | 谨慎使用 |
|---------|---------|
| 提示 / 表明 / 说明 | 证明了 |
| 与…一致 | 完全证实了 |
| 支持…这一解释 | 必然由于 |
| 可能反映出… | 足以解释 |
| | 直接说明因果关系 |

涉及"冗余""决定性作用""因果机制"等强结论时降级：
- "与部分重叠贡献的解释相一致"
- "提示其可能参与…"
- "支持其在…中发挥作用"

---

## 10. Claude 生成 Writing Material 时的 panel-level audit（必须）

生成前必须先完成：

1. 提取每个 panel 的一句话结论
2. 检查 panel 编号是否一致（正文引用、标题、图文件名）
3. 检查图文件路径是否存在且正确
4. 列出缺文献 / 缺定义 / 缺统计口径的地方，用 `[TODO]` 明确标记
5. 再按本规范输出正式内容

---

## 11. 文档更新联动（铁律）

### 规则 1：子页面变更 → 向上传播

**触发**：创建 / 实质性更新任何镜像子页。

**必须执行**（按顺序）：

1. 更新**直接父页面**：
   - 状态表对应条目改为最新状态
   - 子页面索引表加入新页
   - 摘要 / 关键结果区同步核心数字
2. 更新**项目主文档更新日志表**：追加一行（日期 / 类型 / 模块 / 文档链接 / 简要说明）
3. 主文档索引表中对应模块状态过时 → 同步更新

**反例（违反）**：只更新子页内容，父页面和主文档仍显示旧状态 → 用户看主页面以为工作没做。

### 规则 2：规范变更 → 回查已有文档

**触发**：本 rule（或 L3 `<platform>-doc-structure.md`）被修改。

**必须执行**：

1. 列出受影响的已有镜像文档（不符合新规范的地方）
2. 向用户汇报哪些文档需要重构
3. 经用户确认后逐个修改

**例外**：纯措辞修正、只影响未来文档的新规则 → 不回查。

---

## 12. 图片插入规范（通用部分）

**统一规范**：

1. **所有图片放在文档末尾**，按 Panel 顺序依次插入，每张图带 caption
2. 文字部分的每个 Panel section 开头注明**图文件路径**（服务器绝对路径），用于溯源
3. **不要**混用"图文交织"和"图在末尾"——统一用"图在末尾"

**例外**：单图文档 / Case study 级单 figure 可图在正文，但多 panel 文档一律图在末尾。

**平台专属**：具体上传 API / MCP 调用方式、是否支持精确插入位置，见 `platforms/feishu.md` 和 `platforms/notion.md`。"图在末尾"的铁律有部分是被飞书 API 限制（`+media-insert` 只能追加）逼出来的；为保持跨平台一致性，Notion 等支持精确插入的平台也沿用此约定。

---

## 13. 路径规范（镜像文档中引用服务器文件）

**必须**使用服务器名 + 绝对路径：

- ✅ `<server>:/data/<lab>/<project>/Results/...`
- ❌ `.../model_name_variant/test/`（信息量不足）

---

## 14. 生物学解读规范

涉及生物学解读时**每个结论至少 1 篇文献**：

- 优先 IF>10 的 review 或近 3 年研究
- 格式：`Author et al., Year, Journal. DOI: xxx`
- 引用三步验证：搜索 DOI → 读原文找逐字支持句 → 留痕记录（见 `.claude/rules/research-and-reporting.md`）
- **不能**仅凭常识下结论（reviewer 可挑战任何未引用的论断）

---

## 15. 命名规范

- 标题格式：`[Tag] 简短描述`
- Tag 统一英文：`Brainstorm / Survey / Ideas / Implementation / Experimental Results / Writing Material / Report`
- **已确认方向的父页面**（探索型模块）：直接用方向内容命名，**不加 Tag 前缀**
  - 例：`边特征丰富化`（不是 `[Direction] 边特征丰富化`）
- **不加日期前缀**（平台本身记录创建时间）
- 描述说明**分析内容**而非图号：✅ `可解释性分析 — 网络 A / 网络 B 利用` / ❌ `Figure 5 故事逻辑`（图号会变）
- 每个文档开头标注**前置文档**链接

---

## 16. Opus token 保护（高级模型下的镜像写入）

使用 **Opus 等高级模型** 时，镜像平台大规模写入（overwrite、大段 append、批量插图）消耗巨大 tokens（本地 md 编辑不受限）。

**必须**：

1. **暂停**：不直接执行写入
2. **汇报**：向用户列出待更新清单（哪些 section、多少文字、几张图）
3. **建议**：提示切换 Sonnet 后再写入
4. **例外**：单行替换（修路径、改错别字）、本地 md 编辑、SSH 操作不受限

**禁止自主 overwrite 整篇镜像文档**，除非用户明确说"全部重写"。overwrite 清空所有图片 token / 评论 / 格式，重建成本是精确 range 替换的 10x。

遇文档结构混乱 → 先 fetch，分析混乱位置，用平台的精确替换能力修复（飞书 `replace_range` / Notion `patch_block_children`，见 platforms/ 对应文件）。
