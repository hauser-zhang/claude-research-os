---
name: literature-ingest
description: >-
  当用户要求做广泛文献 survey、下载 raw paper、建立 wiki/papers 笔记、
  把文献事实回流到项目 tracks/**/01-survey.md，或需要为重点论文生成
  “可复制到网页版 GPT / 外部 AI 精读、带读或回填 wiki”的 prompt 时触发。
  本 skill 管理 Research OS 的 raw → wiki → thread survey 文献摄入闭环：
  官方来源核验、PDF 落盘、wiki stub/draft、survey 后重点文献候选判断、
  外部 AI guided-reading / full-file rewrite / patch-notes handoff，以及外部结果回填时的事实审查。
---

# Literature Ingest

## 定位

把“Codex 做 survey 初筛 + 用户用网页版 GPT 精读重点 paper + Codex 审查回填”变成一个稳定闭环：

```text
official source / PDF
  -> raw/papers/<slug>.pdf
  -> wiki/papers/<slug>.md
  -> projects/<name>/tracks/<track>/<thread>/01-survey.md
  -> deep-read candidate review
  -> external GPT handoff for重点 paper
  -> return / merge audit
  -> wiki + thread survey update
```

不要把 `paper-reading` 建成 track。track 按研究目标命名；读文献是 thread 的 `01-survey` 阶段。

## 场景 1：Survey Ingest

当 project `01-survey.md` 需要文献调研时，先确认 L3 项目上下文、track、thread 和当前 survey 问题。调研不是堆论文列表，而是服务路线判断：哪些方法能复现、哪些结果影响 proposal、哪些风险需要后续实验验证。

落点判断：

- **跨项目反复会引用的重点论文**：建 `wiki/papers/<first-author>-<year>-<keyword>.md`。
- **只服务当前 thread 的背景文献**：可以只写进当前 `01-survey.md`，不强制建 wiki 页。
- **原始 PDF / 网页 clipping**：落 `raw/papers/` 或 `raw/clippings/`，并更新 `raw/manifest.json`。
- **项目路线判断 / 方法比较**：落当前项目的 `tracks/<track>/<thread>/01-survey.md`。

优先找官方来源：arXiv、OpenReview、ACL Anthology、publisher 页面、官方 GitHub。对最近论文、版本、代码仓库、榜单或任何不确定信息，联网核验后再写入。

记录时区分三类事实：

| 事实类型 | 可写入位置 | 要求 |
|---|---|---|
| 元数据 | frontmatter / Paper Meta | title、authors、venue、year、DOI、URL 以官方页面为准 |
| 方法结构 | wiki 正文 / `01-survey.md` | 来自 paper abstract / method section / official README |
| 实验数字 | Key Numbers | 必须来自论文表格、图或正文；写 Source table/section |

如果没有读到原文支撑，写 `[TODO 待核实]`，不要补猜。

## 场景 2：Wiki Paper Drafting

给 paper 建 wiki 页时，先读 `wiki/_TEMPLATE.md` 和 `wiki/papers/_README.md`。允许 survey 阶段的页面是 `stub` 或 `draft`，但它必须诚实：粗读得到的判断可以写，未核实的数字、机制细节和代码命令要显式 TODO。

重点论文下载 PDF，并把 raw 索引写清楚：

```bash
mkdir -p raw/papers
curl -L --fail --silent --show-error -o raw/papers/<slug>.pdf <official-pdf-url>
```

更新 `raw/manifest.json`，至少包含 title、authors、year、source_url、pdf、ingested。`raw/papers/*.pdf` 通常是私有 ignore 内容，但 manifest 仍是本地权威索引。

Paper wiki 页面必须遵循：

- frontmatter + H1 + `> [!NOTE] Paper Meta`
- `TL;DR`
- `Core Contribution`
- `Data Flow`
- `Key Numbers`
- `Limitations / Open Questions`
- `How It Connects To Our Work`
- `Referenced By`
- `References`

语言习惯：正文中文为主；论文题目、方法名、模型名、数据集名、指标名、代码符号保留英文。

## 场景 3：Thread Survey 回流

更新当前项目 thread 的 `01-survey.md` 时，不要复制 wiki 全文。写面向决策的 survey：

- 方法谱系表：paper / mechanism / relevance / risk / next action
- 代表方法详解：只展开和当前 thread 决策有关的部分
- 可复现信息：code、dataset、model、first command、compute risk
- 待核实清单：哪些数字、表格、代码路径还没验证

在 phase doc frontmatter 写 `wiki_touches: [<slug>]`，保持双向链接合同。

如果项目有 Feishu mirror（如 `projects/<name>/.claude/rules/feishu-doc-structure.md`）：

- 本地 `wiki/papers/*.md` 仍是权威源，Feishu 是协作导航视图。
- Paper Index 应优先用 Base 管理 `slug / title / route / proposal_role / evidence_status / reproduction_status / local_wiki_path / feishu_page / official_url / code_url / notes`，不要长期维护静态大表。
- 重点 paper 应在 Feishu Paper Index 下按 route 建 child pages；phase / thread / proposal 页引用 paper 时同时保留 local path 与 Feishu page link。
- Survey 顶部不保留一次性的 `Feishu Coverage Audit` / `Paper Wiki Refresh 回流摘要` 迁移日志；同步完成后改成当前 `Paper Index / Feishu Mirror Status` 和 `Current Reading / Reproduction Priority`。
- Feishu Markdown 表格中用显式 `[label](url)` 链接，不要在裸 URL 后直接接 `;`、`,` 等标点，避免标点被吞进链接。

## 场景 4：Deep-Read Candidate Review

survey 完成或阶段性告一段落后，主动给用户一组“建议精读候选”，但不要自动给所有 paper 塞 prompt。候选判断看它是否会影响后续决策，而不是看它是否出名。

常见候选：

- **route-defining paper**：会改变 proposal 路线或方法分类。
- **reproduction target**：后续最可能复现或作为 first baseline。
- **strong baseline / SOTA**：需要和本项目直接对比。
- **confusing or risky paper**：摘要看起来重要，但机制、数字或限制还没读透。
- **repeated citation hub**：多篇 paper 都依赖它，后续 wiki 会反复引用。

给用户汇报时增加一块：

```text
建议精读候选：
1. <slug> — <原因>；建议 <full-file rewrite | patch notes>
2. <slug> — <原因>；建议 <full-file rewrite | patch notes>

要我给其中某几篇插入 External GPT 精读 prompt 吗？
```

如果用户明确指定某篇 paper 要精读，直接负责插入 prompt；不再重新论证它是否“足够重要”。

## 场景 5：External GPT Handoff

根据用户目的选择 handoff 模式：

- **guided-reading（带读）**：用户想先读懂论文、边问边补背景、要求通俗解释但保留计算/技术细节。输出给用户一个可复制到网页版 GPT 的带读 prompt，不要求外部 GPT 直接改本地文件。
- **full-file rewrite**：适合 `stub` / `draft` 页面、刚从 survey 生成的粗读笔记、用户希望外部 GPT 带着论文从头补全 wiki 文件的情况。
- **patch-notes**：适合 `mature` 页面、已有大量人工判断、担心整篇替换覆盖细节，或用户明确要求只给修改建议。

具体模板见 `references/external-gpt-full-file-rewrite.md`。插入或交付前按 paper 名称、来源、是否有代码仓库、关键术语、项目背景和用户想学的层次替换占位符。

同时提醒用户网页版 GPT 流程：

```text
建议你在 GPT 网页版里打开一个新对话，上传/粘贴：
1. 论文 PDF 或官方论文链接
2. 当前 wiki/papers/<slug>.md
3. wiki/_TEMPLATE.md
4. 如需复现，再加官方 GitHub README / 关键代码文件
5. 如果是 guided-reading，告诉 GPT：讨论中我可能暴露背景知识缺口，请主动补背景，但不要牺牲计算/技术细节

然后让 GPT 按所选模式输出：guided-reading 输出带读笔记和问答路线；full-file rewrite 输出完整 Markdown；patch-notes 输出分 section 修改建议。
```

## 场景 6：Return / Merge Audit

用户把网页版 GPT / 其他 AI 生成的完整 md 贴回或保存后：

如果用户没有给具体文件路径，默认在 `$HOME/Downloads` 中谨慎搜索候选文件。搜索时优先用 paper slug、短标题、第一作者、关键词（如 `bondarenko-2026-edge-reasoning`、`edge reasoning`、`patch_notes`）匹配，并按修改时间倒序查看。不要使用真实用户主目录写进 skill 或模板；对外描述时用 `$HOME/Downloads`。如果命中多个候选，先报告候选列表并让用户确认；如果只命中一个，也要在合并前说明将使用哪个文件，避免把别的论文 patch 错合进来。

1. 检查它是否仍保留 HTML prompt comment 或 prompt section；最终 wiki 页应删除这些。
2. 检查 frontmatter 与 Paper Meta 是否一致。
3. 抽查所有数字是否带 Source table/section。
4. 把“外部 AI 声称但无出处”的内容降级为 `[TODO 待核实]` 或删掉。
5. 检查正文是否中文为主，同时保留必要英文术语。
6. 对 full-file rewrite，先判断是否会覆盖用户已有人工判断；必要时改成人工 merge。
7. 对 patch-notes，逐条合并，不把外部 AI 的建议原样当事实。
8. 更新 `wiki/index.md` / `wiki/log.md` 和相关 `01-survey.md`。

## 输出风格

给用户汇报时分三块即可：

1. **已落盘**：PDF、wiki、survey、manifest 路径。
2. **已核实**：官方来源、代码仓库、已确认元数据。
3. **建议精读候选**：哪些重点 paper 值得外部 GPT 精读、推荐 full-file rewrite 还是 patch-notes。

## 保护准确性

- 不把二手 survey 的数字直接写成 wiki fact。
- 不因为 abstract 声称 efficient 就外推到真实端侧硬件；除非论文实际测了设备、量化、latency、memory 或 energy。
- 不把所有 paper 都建 wiki；只给关键、会复用、会影响决策的 paper 建页。
- 不覆盖用户已有 wiki 页；已有内容要 merge，保留更强出处。
