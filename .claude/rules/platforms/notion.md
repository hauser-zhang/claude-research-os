# Notion 平台接入规范（初版）

> **通用写作 / 存档规范**见 `../writing-and-archival.md`。本文件只覆盖 Notion 平台的**接入方式**和**平台特定坑点**。
> **项目专属 Notion 文档树**（database 设计、tag 属性）见 L3 `projects/<name>/.claude/rules/notion-doc-structure.md`（若启用 Notion 才建）。
>
> **状态**：初版。结构镜像 `feishu.md`；接入细节基于 Notion 官方 MCP server + Notion API 公开约定。首次实际接入时请按 Setup 验证命令确认版本差异。

---

## Setup

### 前置

- Notion 账号 + 在 <https://www.notion.so/my-integrations> 创建 **Internal Integration**，拿到 `NOTION_API_KEY`（格式 `secret_xxx` 或 `ntn_xxx`）
- 在目标工作区页面**手动 Share 给 Integration**（Notion 权限模型：integration 默认看不到任何页面，必须逐个 share）
- Node.js ≥ 18（运行官方 MCP server）

### 步骤（Claude Desktop / Claude Code）

1. 在 Notion 创建 integration + 授权目标页面 / database
2. 在 `~/.claude/settings.json`（或 Claude Desktop 的 `claude_desktop_config.json`）的 `mcpServers` 加：

   ```json
   {
     "mcpServers": {
       "notion": {
         "command": "npx",
         "args": ["-y", "@notionhq/notion-mcp-server"],
         "env": {
           "NOTION_API_KEY": "secret_xxxxxxxxxxxx"
         }
       }
     }
   }
   ```

3. 重启 Claude Code / Claude Desktop
4. 验证：让 Claude 调用 `notion` MCP 的 `search` 或 `retrieve-page` 工具，返回真实页面元数据 → 配置成功

### 详细文档

- 官方 MCP server：<https://github.com/makenotion/notion-mcp-server>
- Notion API：<https://developers.notion.com/>
- 块结构参考：<https://developers.notion.com/reference/block>

### 核心工具能力（Notion MCP）

典型提供的工具（具体命名以实际 server 版本为准）：

- `search` — 工作区全局搜索页面 / database
- `retrieve-page` / `retrieve-block-children` — 读取页面 / 块树
- `create-page` — 在父页或 database 下建新页
- `update-page` / `append-block-children` / `patch-block-children` — 更新页面属性、追加块、精确改块
- `query-database` — 过滤 / 排序 database
- `create-comment` / `retrieve-comments` — 评论

---

## 1. 本地 → Notion 的具体落地

映射表（Tag、同步方式）见 `../writing-and-archival.md` §2——Notion 侧的具象化：

- **组织结构二选一**：
  - **方案 A（推荐）**：每个 thread 作为一个 Notion **database page**，五阶段对应 database 里的 5 个 child page（`[Brainstorm]` ... `[Experimental Results]`），Tag 用 database 的 `Select` 属性而非标题前缀
  - **方案 B（更贴近飞书）**：每个 thread 一个普通 page，5 个子页直接作为 sub-page，标题含 `[Tag]` 前缀

  推荐 A：能用 Notion database 的 filter/sort/view 看所有 thread 的状态总览，成本基本为零。
- **项目主文档**：一个 parent page，内嵌 database view（threads）+ Changelog database（镜像更新日志表）
- **图片托管**：详见 §3

---

## 2. 图片插入

**Notion 的两种图片来源**：

1. **External URL**：`image` block 指向公网可访问的 URL（https）。最简单，但依赖外链持久性——如果源地址失效，Notion 不会本地化
2. **Notion-hosted file**：通过 MCP/API 上传后拿到 Notion 自己的 file URL（有时效签名），更稳定，但上传流程稍复杂

**与飞书的关键差异**：

- Notion API 支持在指定位置 `append-block-children` 插入图片 block，**原生支持精确插入**（不像飞书 `+media-insert` 只能追加到末尾）
- 为保持跨平台一致（见 `../writing-and-archival.md` §12），Notion 侧仍采用"图在末尾"约定；单图文档或 case study 级单 figure 可图在正文
- 图片 caption：通过 `image` block 的 `caption` rich_text 数组设置

**上传推荐流程**（MCP 可用时）：

1. 把本地图 push 到 Notion（MCP 提供 upload 工具时直接调用；否则先传到公网 URL 再用 external）
2. 用 `append-block-children` 插到页面末尾
3. 顺便写 `caption`

---

## 3. Notion markdown 已知坑点

Notion **不直接**接受 markdown——必须转成 block JSON 数组（通过 MCP server 帮忙转）。以下是 markdown 语义映射过程中**必然**遇到的坑：

### 3.1 rich_text 单块 2000 字符上限

Notion API 要求每个 `rich_text` 段 content 长度 ≤ 2000 字符；超过会 400 报错。

**解决**：长段落预先切分成多个 `paragraph` block，或一段内多个 `rich_text` object 拼接。MCP server 通常会帮你切，但遇到超长表格单元格或超长代码块仍可能踩。

### 3.2 原生 markdown 表格 → table block 的对齐差异

Notion 的 `table` block 不支持列对齐（left/center/right），markdown 的 `|---:|:--:|` 对齐提示会被丢弃。表格内的单元格也是 `rich_text`，同样受 2000 字符限制。

**解决**：对齐不重要；超长单元格拆成多行 / 改成段落形式。

### 3.3 嵌套列表深度 / 嵌套 block 语义

Notion block 是树形，但 markdown 的深度嵌套列表（> 3 层）在转换时常被拍平，或者 `children` 字段未正确构造导致内层块丢失。

**解决**：嵌套 ≤ 3 层；再深的结构改用"标题 + 列表"或拆分为多个 block 的组合。

### 3.4 Code block 语言标识符有限集

markdown 的 code fence 语言名（如 \`\`\`cypher、\`\`\`yaml）必须映射到 Notion 支持的枚举集合（`python` `javascript` `typescript` `json` `yaml` `bash` `shell` 等有限集）。不识别的语言会被强制改成 `plain text` 或接口报错。

**解决**：常用语言标准化；自造语言（如 pseudocode）用 `plain text` + 注释说明。

### 3.5 LaTeX / 数学公式

Notion 的 `equation` block 只支持 KaTeX 子集，复杂环境（`align`, `cases` 嵌套）会渲染失败或静默截断。inline `$...$` 需转成 `equation` 类型 rich_text object，不是 paragraph 内嵌。

**解决**：复杂公式拆成多条简单公式；用图片兜底。

### 3.6 Callout / Toggle / Synced block 的 markdown 原生不存在

GitHub Alerts 风格的 `> [!NOTE]` / `> [!WARNING]` 在 Notion 里对应 `callout` block，**必须**通过 block JSON 构造（加 icon + color），不会从 markdown `>` blockquote 自动识别。

**解决**：push 前预处理—把 `> [!NOTE]` / `> [!TIP]` 等提取出来显式转 `callout` block。

---

## 4. Opus token 保护（Notion 专属细节）

通用原则见 `../writing-and-archival.md` §16。Notion 侧补充：

- **禁止自主批量 delete + recreate**——这等同飞书的 overwrite，会清空评论和嵌入块
- 修改优先顺序：`patch-block-children`（改已有 block）> `append-block-children`（追加）> delete+create（最后手段）
- 大页面（> 100 block）遇结构混乱时，先 `retrieve-block-children` 翻页读取，再定位要改的 block_id 做精确 patch
- 单块小改（修 URL、修 typo）不受 Opus 保护限制

---

## 5. Notion vs 飞书 关键差异速查

| 维度 | 飞书 | Notion |
|------|------|--------|
| 权限模型 | 组织内文档默认可见（按云空间权限） | Integration 必须**被显式 share** 每个页面才能访问 |
| 图片精确插入 | 不支持（只能追加末尾） | 支持（`append-block-children` 到任意位置） |
| 表格对齐 | 富文本编辑器原生支持 | 不支持（`table` block 无对齐字段） |
| Markdown 输入 | `lark-cli docs +create --markdown` 直接接受 | MCP 帮忙转 block JSON；不接受原生 markdown payload |
| 数据库视图 | 多维表格 (`lark-base`) 独立模块 | Database 是一等公民，page 内即可嵌套 view |
| Tag 方案推荐 | 标题前缀 `[Tag]` | database `Select` 属性 |
| 精确替换能力 | `replace_range`（锚点串） | `patch-block-children`（block_id，更可靠） |

---

## 6. 命名 / 路径 / 生物学引用

这些跨平台通用，见 `../writing-and-archival.md` §13–§15。Notion 侧两个可选优化：

- Tag 用 database `Select` 属性时，标题可不加 `[Tag]` 前缀（避免重复）；但保持 thread 父页统一可搜索
- 前置文档用 Notion 的 `mention` 功能双向链接，比纯文本链接更稳定
