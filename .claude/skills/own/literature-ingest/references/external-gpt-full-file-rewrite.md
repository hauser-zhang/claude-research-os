# External GPT Handoff Templates

Use this when a重点 paper wiki page should be handed to a webpage GPT / external AI reading session for deeper paper-grounded completion or guided reading.

Choose a mode:

- **Guided Reading**: user wants to learn the paper through an interactive webpage GPT session. Use when they ask for 带读, 精读讲解, 一边讨论一边补背景, 通俗但技术细节不能丢.
- **Full-File Rewrite**: `stub` / `draft` pages produced during survey should be completed into a replaceable wiki file.
- **Patch-Notes Mode**: the page is already mature, contains substantial human-written interpretation, or the user wants Codex to merge changes conservatively.

## Guided Reading Mode

Use this when the user wants a webpage GPT to read a paper with them before changing local wiki files. This mode emphasizes teaching, adaptive background repair, and project-aware discussion. It does **not** ask the external GPT to output a replacement Markdown file.

```markdown
你是我的论文带读导师。请带我精读论文：

<PAPER_TITLE>
官方论文链接：<PAPER_URL>
项目页 / 代码仓库（如有）：<PROJECT_OR_CODE_URL>

我的研究背景：
<PROJECT_CONTEXT>

我的阅读偏好：
- 请在和我讨论的过程中，留意我可能缺失的背景知识，并在需要时主动补充。
- 解释尽量通俗易懂，可以用类比、分步骤、伪代码和小例子。
- 但不要牺牲计算细节和技术细节：关键公式、数据流、训练目标、模型结构、实验设置、指标定义都要讲清楚。
- 如果一个概念有“直觉版”和“技术版”，请先给直觉版，再给技术版。
- 如果我问了基础问题，不要跳过论文主线；请把背景补完后再拉回本文方法。
- 所有实验数字必须标明来自论文的哪个 Table / Figure / Section，找不到出处就说找不到，不要猜。
- 论文关键结论、关键要点、实验数字、方法细节都要标明对应的原论文 Section / Table / Figure，方便我回原文检查。
- 不要把论文结论外推到它没有评测的场景。

请按下面结构输出中文带读笔记，论文标题、方法名、模型名、数据集名、指标名和代码符号保留英文：

1. Reading Map
- 这篇论文属于什么类型？方法论文、系统论文、survey、benchmark，还是 deployment paper？
- 它解决的核心问题是什么？
- 如果我只读 3 个 section，应该优先读哪几个，为什么？

2. One-Sentence Thesis
- 用一句话说清这篇论文的主张。
- 再用一段 150 字以内的通俗解释说明它为什么重要。
- 标注这句主张主要来自论文哪个 Section / Abstract / Introduction。

3. Background Repair
请列出读懂这篇论文需要的背景知识，并按“必须先懂 / 读到相关章节再懂 / 可选深入”分层。
对每个背景点给出：
- 一句话定义
- 直觉解释
- 和本文哪个模块有关
- 我如果不懂它，会误解论文哪里

4. Problem Setup
请解释作者的问题定义：
- 输入/输出是什么？
- 目标是什么？
- 约束是什么？
- 哪些成本或指标最关键？
- 这些约束和我的项目 <PROJECT_SHORT_NAME> 有什么关系？
每个关键点后面请标注原论文 Section / Figure / Table。

5. Method Walkthrough
请按模块带读方法，而不是只给摘要。
对每个模块输出：
- 模块名字
- 它解决什么子问题
- 输入是什么
- 输出是什么
- 内部怎么做，必要时给公式或伪代码
- 更新哪些参数 / 冻结哪些参数
- 训练时和推理时是否不同
- 它和前后模块如何衔接
- 一个容易误解的点
每个模块必须给出对应原论文 Section；如果模块来自 project page 或 appendix，也要明确标注。

6. Full Data Flow
请写出从 raw input 到 final output 的完整流程。
尽量包括 token、hidden state、KV cache、adapter、latent/state、verifier、loss/reward、metric 等关键对象。
如果论文没有给出维度或 shape，请标 `[TODO: paper does not specify]`。

7. Training / Optimization Details
请整理：
- 数据集
- base model
- 训练目标 / loss / reward
- optimizer / learning rate / batch size / epochs / compute
- 哪些参数更新
- 关键 trick
- 这些细节对复现是否重要

8. Key Numbers
请提取最影响我项目决策的实验数字，整理成表格：
Result | Value | Source | Why it matters for my project
每个数字必须标明 Table / Figure / Section。
如果一个数字来自 project page 而非论文 PDF，请在 Source 写 `Project page`，并说明它是否需要回论文核对。

9. Critical Reading
请批判性分析：
- 这篇论文真正证明了什么？
- 没有证明什么？
- 哪些结论依赖特定硬件、数据集、模型或工程栈？
- 哪些地方可能只是 proxy metric，不等于真实部署收益？
- 最容易被误读或过度宣传的点是什么？
每条批判都要说明它基于原文哪部分证据，或是从原文缺失信息推出的谨慎判断。

10. Connection To My Project
请和以下我关心的路线对比：
<RELATED_METHODS>

输出一个表格：
Method | 显式/隐式 reasoning | 是否减少生成 token | 是否减少 KV-cache/memory | 是否需要额外模块 | 是否适合端侧 | 复现难度 | 对我的 proposal 的作用

11. Discussion Prompts For Me
请给我 10 个问题，帮助我边读边检查理解。
每个问题后面附：
- 为什么这个问题重要
- 简短参考答案
- 论文对应位置

12. Proposal Takeaways
最后请给我：
- 3 条可以写进 proposal 的结论
- 3 条必须谨慎表述的 caveat
- 3 个后续实验或复现建议
每条都标注其依据来自论文哪个 Section / Table / Figure，或明确写“基于本文整体判断”。

13. Next Interaction Options
请在最后主动问我接下来想怎么继续，并给出两个选项：

A. “接下来有什么问题要讨论么？”
适用于我已经基本接收完信息，想讨论这篇论文对自己项目的意义、和其他方法的关系、能否写进 proposal、是否值得复现。

B. “开启最细的精读模式？”
适用于这篇 paper 非常重要，我希望一边读原文一边让你解释。请从 Abstract、Introduction 开始，按论文原文顺序一段一段带读。必要时引用短句原文，解释作者为什么这么写、逻辑如何推进、每段和全文主张的关系。讲述顺序必须严格贴合原论文，不要提前重组为你自己的综述；但可以在每段后补背景、公式解释、实验设计说明和项目启发。

请等待我选择 A 或 B；不要在第一次输出里自动进入 B 的逐段精读。
```

Suggested placeholders:

- `<PAPER_TITLE>`: exact title.
- `<PAPER_URL>`: official arXiv/OpenReview/ACL/publisher URL.
- `<PROJECT_OR_CODE_URL>`: official project/code URL or `无`.
- `<PROJECT_CONTEXT>`: 2-5 sentences about the current project and why this paper matters.
- `<PROJECT_SHORT_NAME>`: project shorthand, e.g. `my-project`.
- `<RELATED_METHODS>`: names and one-line descriptions of related papers/routes to compare against.

## Full-File Rewrite: Top HTML Comment

Place this immediately after the YAML frontmatter and before `# <Paper Short Name>`.

```markdown
<!--
External GPT full-file rewrite instructions:

你现在收到的是 Research OS 的一篇 wiki/papers Markdown 文件草稿。请把它当作“待补全的完整文件”，结合本 session 中已经打开/上传/阅读的 <PAPER_SHORT_NAME> 论文原文<OPTIONAL_CODE_PHRASE>，输出一份可以直接复制回本文件的完整 Markdown。

硬性要求：
1. 只输出完整 Markdown 文件内容，从 YAML frontmatter 的 `---` 开始，到 References 结束；不要输出解释、寒暄、diff、代码围栏。
2. 输出内容必须符合本仓库 wiki 模板：frontmatter + H1 + `> [!NOTE] Paper Meta` + TL;DR + Core Contribution + Data Flow + Training Recipe / Method Details + Key Numbers + Reproduction Notes + Limitations / Open Questions + How It Connects To Our Work + Referenced By + References。
3. 正文内容默认中文为主；论文标题、方法名、模型名、数据集名、指标名、代码符号、表格字段中需要和论文/代码精确对应的词保留英文。
4. frontmatter 中的官方元数据保持英文；如果你能从论文/官方页面核实 DOI 或代码 URL，可以补上，否则保留空字段并在正文标 `*[TODO 待核实]*`。
5. 所有实验数字必须来自论文原文表格/图/正文，并在表格中写清 Source table/section。不要从记忆或二手摘要补数字。
6. 如果原文没有给出某项信息，写 `[TODO: paper does not specify / not found]`，不要猜。
7. 请删除本 HTML comment 和底部 “External GPT Full-File Rewrite Prompt” section，不要把提示词保留在最终 wiki 页里。
-->
```

`<OPTIONAL_CODE_PHRASE>` examples:

- `与官方代码仓库`
- `、OpenReview 页面与官方代码仓库`
- leave empty if no code exists

## Bottom Section

Place this before `## Referenced By`. It gives the user a shorter copy target if they do not want to paste the whole file.

````markdown
## External GPT Full-File Rewrite Prompt

如果你没有复制整篇文件，而是只想复制一个短 prompt，可以复制下面这段；但推荐直接复制整篇 md 文件内容给网页版 GPT。

```text
请基于当前 session 中已阅读/上传的论文原文<OPTIONAL_CODE_PHRASE>，把我给你的 Research OS wiki/papers Markdown 草稿改写成完整可替换版本。

输出要求：
- 只输出完整 Markdown 文件内容，不要解释，不要 diff，不要代码围栏。
- 从 YAML frontmatter 的 `---` 开始输出，到 `## References` 结束。
- 删除草稿里的 HTML prompt comment 和 `External GPT Full-File Rewrite Prompt` section。
- 保持官方英文元数据：title、authors、venue、DOI、URL、model/dataset/metric/code names。
- 正文以中文为主，必要英文术语保留英文，例如 <KEY_TERMS>。
- 所有数字必须来自论文原文表格/图/正文，并标明 Source table/section。
- 找不到的信息写 `[TODO: paper does not specify / not found]`，不要猜。

必须补全这些内容：
1. TL;DR: 100 字以内，说明 <PAPER_SHORT_NAME> 是什么、为什么对本项目重要。
2. Core Contribution: 用中文解释核心方法，并保留关键英文术语。
3. Data Flow: 从输入到输出的完整数据流；尽量写出 model / tensor / latent / token / dataset 的形状或长度，如果论文没写则标 TODO。
4. Training Recipe 或 Method Details: loss、objective、optimizer、数据构造、哪些参数更新；不适用项写 TODO。
5. Key Numbers: 提取和本项目决策最相关的主结果、ablation、efficiency 指标。
6. Reproduction Notes: code URL、数据集、训练/推理入口、compute 风险、最小复现建议。
7. Limitations / Open Questions: 至少 3 条，面向当前项目目标。
8. How It Connects To Our Work: 分 `background/proposal`、`reproduction`、`future method track` 三点写。
9. References: 用 Author, Year, Venue/DOI/URL 格式。

额外要求：
- 请在关键事实后写短括号标注，例如 `(Table 1)`、`(Section 3.2)`、`(GitHub README)`。
- 不要把论文结论外推到它没有评测的场景。
- 不要把二手摘要中的数字写入正文，除非原文核实。
```
````

## Replacement Checklist

After external AI returns the full Markdown:

- The returned file starts with YAML frontmatter.
- The HTML comment is gone.
- The `External GPT Full-File Rewrite Prompt` section is gone.
- Every number has a source table/section.
- Unverified claims are TODO, not asserted as fact.
- Body is Chinese-first while official names and technical terms remain English.

## Patch-Notes Mode

Use this when the wiki page should not be fully replaced. This is safer for mature pages or pages with important human-written judgments.

Place the following section before `## Referenced By`, then ask the external GPT session to output patch notes instead of a full file.

````markdown
## External GPT Patch-Notes Prompt

如果你不想整篇替换本 wiki 文件，可以复制下面这段给网页版 GPT。它应该输出“修改建议”，由 Codex 回到本地后逐条合并。

```text
请基于当前 session 中已阅读/上传的论文原文<OPTIONAL_CODE_PHRASE>，审查并补充我给你的 Research OS wiki/papers Markdown 文件。

输出要求：
- 不要输出完整重写文件。
- 不要输出 diff 或代码围栏。
- 按 section 输出 patch notes，每条建议说明：目标 section、建议替换/新增内容、依据的论文 table/figure/section。
- 保持正文中文为主；论文标题、方法名、模型名、数据集名、指标名、代码符号保留英文。
- 所有实验数字必须来自论文原文表格/图/正文，并标明 Source table/section。
- 找不到出处的信息写 `[TODO: paper does not specify / not found]`，不要猜。
- 不要删除原文件中的人工判断；如果你认为某段需要改，说明为什么。

请覆盖这些检查点：
1. frontmatter 和 Paper Meta 是否缺字段或不一致。
2. TL;DR 是否准确且 100 字以内。
3. Core Contribution 是否说清关键机制。
4. Data Flow 是否能从输入到输出串起来；缺失形状/维度时标 TODO。
5. Training Recipe / Method Details 是否缺 loss、objective、optimizer、数据构造、参数更新范围。
6. Key Numbers 是否缺主结果、ablation、efficiency 指标；每个数字标 Source table/section。
7. Reproduction Notes 是否缺 code URL、数据集、训练/推理入口、compute 风险。
8. Limitations / Open Questions 是否足够面向当前项目。
9. How It Connects To Our Work 是否能支持 background/proposal、reproduction、future method track。

输出格式：
## Patch Notes for <PAPER_SHORT_NAME>

### High-priority fixes
- Section: ...
  Suggestion: ...
  Evidence: ...

### Optional enrichments
- Section: ...
  Suggestion: ...
  Evidence: ...

### Claims to downgrade or remove
- Claim: ...
  Reason: ...
  Suggested handling: ...
```
````

## User Handoff Reminder

When handing a paper to the user, remind them to start a fresh webpage GPT session and provide:

1. The paper PDF or official paper link.
2. The current `wiki/papers/<slug>.md`.
3. `wiki/_TEMPLATE.md`.
4. Official GitHub README or key code files if reproduction details matter.

Tell the user that full-file rewrite is the default for rough survey drafts; patch notes are safer when they want to preserve existing human edits.
