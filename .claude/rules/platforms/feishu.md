# 飞书（Lark）平台接入规范

> **通用写作 / 存档规范**见 `../writing-and-archival.md`。本文件只覆盖飞书平台的**接入方式**和**平台特定坑点**。
> **项目专属飞书文档树**（tag、父子结构）见 L3 `projects/<name>/.claude/rules/feishu-doc-structure.md`。

---

## Setup

### 前置

- 飞书账号 + 飞书开放平台自建应用（拿到 app_id / app_secret）
- `lark-cli` 已安装
- 需要的 scope：文档读写、图片上传、（视任务）多维表格、知识库等

### 步骤

> **概念先行**：飞书 CLI 配置分两层。`config init` 绑定的是开放平台应用（app_id / app_secret，说明“这个 CLI 是哪个应用”）；`auth login` 授权的是用户身份（user token，说明“哪个用户允许这个应用访问自己的资源”）。Bot 身份只能访问应用自己的资源，通常看不到用户个人云文档。

1. 检查安装与当前状态：

   ```bash
   lark-cli --version
   lark-cli config show
   lark-cli auth status
   ```

2. 创建 / 绑定应用：

   ```bash
   lark-cli config init --new --brand feishu --lang zh
   ```

   命令会输出飞书网页链接 / 二维码。用户在浏览器完成创建或绑定后，CLI 会把 `appSecret` 存入系统 keychain；不要让用户把 secret 明文贴到聊天里。
   如果 CLI 提示当前是 Agent workspace，优先用 `lark-cli config bind` 绑定已有应用；只有用户明确想在该 workspace 创建独立应用时才加 `--force-init`。

   需要多个应用 profile 时使用 `--name`：

   ```bash
   lark-cli config init --new --name work --brand feishu --lang zh
   ```

3. 授权用户身份（文档归档常用域）：

   ```bash
   lark-cli auth login --domain docs,drive,wiki,markdown
   ```

   需要多维表格 / 表格再增量授权：

   ```bash
   lark-cli auth login --domain base,sheets
   ```

4. 设置默认身份为 user，避免误用 bot 身份：

   ```bash
   lark-cli config default-as user
   ```

5. 验证：

   ```bash
   lark-cli auth status
   lark-cli auth check --scope "docx:document:create docx:document:write_only docx:document:readonly drive:file:upload search:docs:read wiki:node:create wiki:node:read wiki:space:read"
   lark-cli docs +search --query "" --page-size 3 --format pretty
   ```

   只要 `auth status` 显示 `identity: user`、`tokenStatus: valid`，且 `docs +search` 能返回云文档，说明配置可用。

### 配置文件与身份

默认配置文件：

```text
~/.lark-cli/config.json
```

典型结构：

```json
{
  "apps": [
    {
      "appId": "cli_xxx",
      "appSecret": {
        "source": "keychain",
        "id": "appsecret:cli_xxx"
      },
      "brand": "feishu",
      "lang": "zh",
      "defaultAs": "user",
      "users": [
        {
          "userOpenId": "ou_xxx",
          "userName": "示例用户"
        }
      ]
    }
  ]
}
```

- `apps`：本机保存的飞书 / Lark 应用配置列表
- `appId`：开放平台应用 ID
- `appSecret.source: keychain`：secret 存在系统 keychain，不在 JSON 中明文保存
- `brand: feishu`：使用中国飞书域名；国际版 Lark 则是 `lark`
- `defaultAs: user`：默认用用户身份发起 API 请求
- `users`：已经给该应用授权过的用户

身份速记：

| 身份 | 含义 | 适用 |
|------|------|------|
| `--as user` | 使用已登录用户的 user token | 访问个人云文档、知识库、日历等 |
| `--as bot` | 使用应用 / 机器人身份 | 应用自己的资源、机器人发消息等 |
| `default-as: user` | 默认使用当前已授权用户 | Research OS 推送飞书文档的推荐设置 |

### 详细文档

- 飞书开放平台：<https://open.feishu.cn/>
- `lark-cli` skills：`lark-shared` / `lark-doc` / `lark-sheets` / `lark-base` / `lark-drive`（参见本仓库 skill 注册）
- 权限/认证细节：`lark-shared` skill

---

## 1. 本地 → 飞书的具体落地

映射表（Tag、同步方式）见 `../writing-and-archival.md` §2——此处只补充飞书侧的具象化：

- **父子结构**：飞书知识库节点必须保留 `Project root → [Track] → [Thread] → [Phase]`。每个 phase Tag 对应一个飞书子页（`[Brainstorm]` `[Survey]` ...），且只能归属到对应 `[Thread]` 父页；具体挂法见 L3 `feishu-doc-structure.md`
- **项目主文档**：飞书根页，包含索引表 + 更新日志表
- **项目级页面**：`[Ideas] Inbox` 和 `[Plan] Project Plan` 挂在项目根页下，因为它们跨 track/thread；不要挂到某个 thread 下，除非具体 idea 已 promote
- **图片托管**：由飞书自己的 media token 系统托管，上传后拿 `img_token` 插入

禁止结构：

```text
Project root
├── [Brainstorm] ...
├── [Survey] ...
└── [Implementation] ...
```

正确结构：

```text
Project root
├── [Track] foundation
│   └── [Thread] initial-survey-and-proposal
│       ├── [Brainstorm] ...
│       └── [Survey] ...
├── [Ideas] Inbox
└── [Plan] Project Plan
```

---

## 1.1 页面标题、图标和表格可读性

- Feishu 侧边栏标题应是短而稳定的结构 label，可以在最前面加一个类型 icon，例如 `🧭 [Track] ...`、`🧵 [Thread] ...`、`📚 [Reference] ...`。
- 如果当前 CLI 没有原生 page icon API，可用标题前缀 icon 作为可自动化 fallback；项目 L3 规则应明确每类页面的 icon 表。
- `docs +update --command overwrite` 后，文档标题可能被正文 H1 重置。每次 overwrite 后必须重新 patch 标题，并用 `wiki nodes list` 验证。
- 溯源 / reference / linked evidence 信息默认放到文档末尾 `Appendix`，不要挡在正文第一屏；Reference / Index 页面除外。
- 表格优先 2-3 列；大索引、状态表、论文清单优先放 Base，不要塞进普通文档宽表。
- 表格链接用短 label，例如 `[Open](...)`、`[Plan](...)`、`[LRT](...)`；不要放裸 URL，也不要在裸 URL 后直接接 `;`、`,` 等标点。
- Markdown 表格无法稳定设置列宽，只能通过短 label、拆表、少列控制；需要精确列宽时用 XML table 的 `<colgroup>`。

## 1.1.1 项目 L3 飞书结构合同

项目级 `projects/<name>/.claude/rules/feishu-doc-structure.md` 至少应包含：

- `Root`：项目根页 URL / token 和根页职责。
- `Required Tree`：规范 Wiki 层级，默认采用 `Project root → Track → Thread → Phase`，项目级 Ideas / Plan / Reference 挂在 root 下。
- `Current Node Tokens`：稳定记录 wiki node token 与真实 object token，避免每次重新解析。
- `Local Source Mapping`：本地权威文件到 Feishu 镜像页 / Base / Sheet 的映射。
- `Update Rules`：项目特定同步规则，并继承评论保护协议。
- `Page Type Icons`：页面类型到标题图标 / sidebar label 的映射。
- `Layout Rules`：正文第一屏、appendix、表格、索引、Base 的项目约定。
- `Lessons`：项目特定坑点；跨项目坑点回流到本 L2 规则或 `feishu-mirror-sync` skill。

创建或重整 L3 结构时，使用 `.claude/skills/own/feishu-mirror-sync/references/generic-doc-structure.md` 作为脱敏模板。

## 1.2 评论保护协议（强制）

飞书评论是协作上下文，不是可丢弃格式。任何可能重排、替换或删除正文的更新，都必须先保护评论。

- **禁止无快照 overwrite。** 在执行 `docs +update --command overwrite`、大范围 `block_replace`、跨段 `str_replace`、`block_delete` 前，必须先用 `drive file.comments list` 拉取评论快照。评论保护是“需要恢复历史评论”的明确场景，应省略 `is_solved` 查询全量评论，避免已解决评论在结构性更新中永久丢失；普通“查看评论”任务仍遵守 lark-drive 默认只查未解决评论。
- **快照保存位置。** 临时评论快照写入 `/tmp/research-os-feishu-comments/<YYYYMMDD-HHMMSS>/<doc_token>.json`，不要提交到仓库；如果用户要求长期审计，再把脱敏摘要写入项目 handoff。
- **快照内容。** 至少保留 `comment_id`、`is_solved`、`is_whole`、`quote`、首条评论正文、全部 reply、`user_id`、`create_time`、`update_time`。不要只保存评论数量。
- **更新后比对。** 写入完成后再次 `drive file.comments list`，按 `comment_id` / `quote` / 首条评论正文比对是否丢失或脱锚。
- **恢复策略。** 如果原评论对应的 `quote` 仍存在，优先用 `drive +add-comment --selection-with-ellipsis` 恢复为局部评论；如果能可靠定位 block id，也可用 `--block-id`。如果正文已被本次更新删除或改写到无明确对应位置，评论可以不恢复，但必须在交付说明中列出“未恢复原因”。
- **作者与时间不可伪造。** 重新创建的评论无法保持原 `comment_id`、原作者和原时间。恢复评论正文时在开头注明 `[restored by Codex after Feishu mirror update; original author/time: ...]`，保留原评论内容和必要 replies。
- **不要制造重复。** 如果更新后原评论仍存在，不要再创建一条重复评论；只记录它已保留。只对确认为缺失 / 脱锚且仍有对应正文的评论做恢复。
- **恢复前验证锚点。** 使用 `docs +fetch --api-version v2 --doc-format markdown` 或 `--detail with-ids` 确认 quote / block 仍在当前文档，再写评论。

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

### 3.6 `--content @file` 只能用当前目录内相对路径

`lark-cli docs +update --content @/abs/path/file.xml` 会被拒绝，报错类似：`--file must be a relative path within the current directory`。

**解决**：

```bash
cd /path/to/content-dir
lark-cli docs +update --api-version v2 --doc <DOC_TOKEN> \
  --command append \
  --content @content.xml
```

不要把这当成权限错误；这是 CLI 的路径校验规则。需要临时 XML 时，可以把文件放到 `/tmp`，然后以 `/tmp` 为 `workdir` 调用相对路径。

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
