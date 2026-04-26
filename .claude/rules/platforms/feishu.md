# 飞书（Lark）平台接入规范

> **通用写作 / 存档规范**见 `../writing-and-archival.md`。本文件只覆盖飞书平台的**接入方式**和**平台特定坑点**。
> **项目专属飞书文档树**（tag、父子结构）见 L3 `projects/<name>/.claude/rules/feishu-doc-structure.md`。

---

## Setup

### 前置

- 飞书账号 + 飞书开放平台自建应用（拿到 app_id / app_secret）
- `lark-cli` 已安装并完成首次 `lark-cli config init`、`lark-cli auth login`
- 需要的 scope：文档读写、图片上传、（视任务）多维表格、知识库等

### 步骤

1. `lark-cli config init`——填 app_id / app_secret
2. `lark-cli auth login`——授权用户身份（user token）；若需机器人身份另走 `--as bot`
3. 验证：`lark-cli docs +list`（能列出云文档 → 配置成功）

### 详细文档

- 飞书开放平台：<https://open.feishu.cn/>
- `lark-cli` skills：`lark-shared` / `lark-doc` / `lark-sheets` / `lark-base` / `lark-drive`（参见本仓库 skill 注册）
- 权限/认证细节：`lark-shared` skill

---

## 1. 本地 → 飞书的具体落地

映射表（Tag、同步方式）见 `../writing-and-archival.md` §2——此处只补充飞书侧的具象化：

- **父子结构**：每个 Tag 对应一个飞书子页（`[Brainstorm]` `[Survey]` ...），归属到 thread 父页；具体挂法见 L3 `feishu-doc-structure.md`
- **项目主文档**：飞书根页，包含索引表 + 更新日志表
- **图片托管**：由飞书自己的 media token 系统托管，上传后拿 `img_token` 插入

---

## 2. 图片插入（飞书专属限制）

**背景**：`lark-cli docs +media-insert` API 只能将图片**追加到文档末尾**，无法精确插入段落中间。

这就是通用规范（`../writing-and-archival.md` §12）"所有图片放文档末尾"铁律的由来。其他平台若支持精确插入，也沿用此约定，保持跨平台一致。

---

## 3. lark-cli markdown 已知坑点

### 3.1 英文双引号截断（严重）

`"xxx"` 中的双引号会导致飞书解析器截断其后内容。

**解决**：
- 去外层双引号：`原文支持句：These pathogens...`
- 或改中文引号：`原文支持句：「These pathogens...」`
- 绝不在 `--markdown` 参数中用英文双引号包长段落

### 3.2 Blockquote `>` 多行截断

`>` 引用块换行后内容不渲染，只保留第一行。

**解决**：改普通段落 + `**📌 文献留痕：**` 加粗标题。

### 3.3 `replace_range` 定位串含双引号 → 参数报错

**解决**：选不含双引号的锚点文字。

### 3.4 `lark-table` 内 `replace_range` 无法跨 cell 分割

单元格内 markdown 的 `|` 被当 literal 文本，**不会**拆成两个 cell。
**解决**：多 cell 修改 → 对每 cell 独立替换。

### 3.5 通用检查

写入前检查 `--markdown` 内容：
- 英文双引号 → 改中文引号或去掉
- 多行 `>` blockquote → 改普通段落
- 特殊 shell 字符 → heredoc 中正确转义

---

## 4. Opus token 保护（飞书专属细节）

通用原则见 `../writing-and-archival.md` §16。飞书侧补充：

- **禁止自主 overwrite 整篇飞书文档**（`lark-cli docs +overwrite` / 整段 body 替换），除非用户明确说"全部重写"
- overwrite 清空所有**图片 token / 评论 / 格式**，重建成本是 `replace_range` 的 10x
- 遇文档结构混乱 → 先 `lark-cli docs +fetch` 分析混乱位置，用 `replace_range` 精确修复
- 单行替换（修路径、改错别字）、本地 md 编辑、SSH 操作不受 Opus 保护限制

---

## 5. 命名 / 路径 / 生物学引用

这些跨平台通用，见 `../writing-and-archival.md` §13–§15。飞书侧**没有**额外约束。
