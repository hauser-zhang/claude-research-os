# External GPT Handoff Templates

Use this when a重点 paper wiki page should be handed to a webpage GPT / external AI reading session for deeper paper-grounded completion.

Default to **full-file rewrite** for `stub` / `draft` pages produced during survey. Use **patch-notes mode** when the page is already mature, contains substantial human-written interpretation, or the user wants Codex to merge changes conservatively.

## Full-File Rewrite: Top HTML Comment

Place this immediately after the YAML frontmatter and before `# <Paper Short Name>`.

```markdown
<!--
External GPT full-file rewrite instructions:

你现在收到的是 Research OS 的一篇 wiki/papers Markdown 文件草稿。请把它当作“待补全的完整文件”，结合本 session 中已经打开/上传/阅读的 <PAPER_SHORT_NAME> 论文原文<OPTIONAL_CODE_PHRASE>，输出一份可以直接复制回本文件的完整 Markdown。

硬性要求：
1. 只输出完整 Markdown 文件内容，从 YAML frontmatter 的 `---` 开始，到 References 结束；不要输出解释、寒暄、diff、代码围栏。
2. 输出内容必须符合本仓库 wiki 模板：frontmatter + H1 + `> [!NOTE] Paper Meta` + TL;DR + Core Contribution + Data Flow + Key Numbers + Limitations / Open Questions + How It Connects To Our Work + Referenced By + References。
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
8. How It Connects To Our Work: 分 `foundation/proposal`、`reproduction`、`future method track` 三点写。
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
9. How It Connects To Our Work 是否能支持 foundation/proposal、reproduction、future method track。

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
