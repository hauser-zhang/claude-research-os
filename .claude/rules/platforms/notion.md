# Notion 平台接入规范

> **通用写作 / 存档规范**见 `../writing-and-archival.md`。本文件只覆盖 Notion 平台的**接入方式**和**平台特定坑点**。
> **项目专属 Notion 文档树**（database 设计、tag 属性）见 L3 `projects/<name>/.claude/rules/notion-doc-structure.md`（若启用 Notion 才建）。
>
> **状态**：v2（2026-05-04 校对官方文档）。Notion 已弃用 self-host npx MCP server，全面转向 hosted MCP（OAuth）。本规范同步重写接入路径；块 API / markdown 坑点不变。

---

## Setup

### 三档接入方式（按推荐度从高到低）

| 方式 | 适用 | 维护状态 |
|------|------|---------|
| **A. 官方 Claude Code plugin**（推荐）| Claude Code 用户、想一键拿到 skill + slash command | 官方 actively maintained |
| **B. 手动配置 hosted MCP** | 只要 MCP server、不要 plugin 附带的 skill；或要跨客户端复用 | 官方 actively maintained |
| **C. self-host npx server**（deprecated）| 仅遗留环境保留；新接入**不要走这条** | 官方将 sunset，issue/PR 不再 monitor |

### 方式 A：官方 Claude Code plugin（推荐）

Notion 官方 plugin（[`makenotion/claude-code-notion-plugin`](https://github.com/makenotion/claude-code-notion-plugin)）一条命令同时装好 MCP server + 4 个 skill（knowledge capture / meeting intelligence / research docs / spec-to-implementation）+ slash command（`/Notion:search`、`/Notion:create-page`、`/Notion:database-query`、`/Notion:create-task` 等）。

**步骤**：

1. 在 Claude Code 内依次执行：

   ```
   /plugin marketplace add makenotion/claude-code-notion-plugin
   /plugin install notion-workspace-plugin@notion-plugin-marketplace
   ```

2. 首次调用任何 Notion 工具时，Claude Code 触发 OAuth 浏览器弹窗——登录 Notion → 选 workspace → 同意权限 → 自动跳回。**不再需要手动建 Internal Integration、不再需要复制 API key**。
3. 在 Notion 里把要 Claude 访问的页面 / database **share 给 integration**（详见下面 §Page 授权）。
4. 验证：在 Claude Code 里说"用 notion 找一下 xxx"或运行 `/Notion:search <关键词>`，返回页面命中即成功。

**优点**：MCP + skill + slash command 一并装好，Claude 知道常见场景下该用哪个工具。
**缺点**：plugin 注册到 Claude Code，跨客户端（Claude Desktop / Cursor）不复用配置。

### 方式 B：手动配置 hosted MCP

只想要 MCP server、不想要 plugin 附带的 skill 时走这条。配置进 `~/.claude/settings.json`，跨项目共享。

```json
{
  "mcpServers": {
    "notion": {
      "url": "https://mcp.notion.com/mcp",
      "transport": "streamable-http"
    }
  }
}
```

**步骤**：

1. 把上面 JSON merge 进 `~/.claude/settings.json` 的 `mcpServers` 字段。
2. 重启 Claude Code。
3. 在 Claude Code 内运行 `/mcp` → 找到 `notion` 项 → 走 OAuth 授权流程（浏览器弹窗 → Notion 登录 → 同意 → 自动回填 token）。
4. Notion 里 share 页面给 integration（详见下面 §Page 授权）。
5. 验证：让 Claude 调用 `notion` MCP 的 `search` / `retrieve-page` 工具。

**注意**：
- URL 必须用 `https://mcp.notion.com/mcp`（Streamable HTTP transport，更高效）；老的 SSE 端点 `https://mcp.notion.com/sse` 是 fallback，**不要用**。
- Access token 有效期 1 小时，refresh token 自动轮转——MCP 客户端透明处理。
- **不再需要 `NOTION_API_KEY` / Internal Integration Secret**——OAuth 全替代。

### 方式 C（deprecated）：self-host npx + API key

仅作记录，新接入**不要走这条**。老写法（保留在 git 历史里）：`npx -y @notionhq/notion-mcp-server` + `NOTION_API_KEY` 环境变量。

[`makenotion/notion-mcp-server`](https://github.com/makenotion/notion-mcp-server) README 原话：
> "We may sunset this local MCP server repository in the future. Issues and pull requests here are not actively monitored."

**迁移建议**：删 settings.json 里的老 `notion` 配置 → 走方式 A 或 B。

### Page 授权（A / B 都适用，但行为与旧版 Internal Integration 不同）

> **重要**（2026-05-04 实测更正）：hosted MCP 的 OAuth 流程**默认开 workspace 级访问**——授权时 Notion 会让你二选一：
>
> 1. **"Use Claude across this entire workspace"**（默认推荐 / 多数人会勾）→ integration 拿到**整 workspace 读写权**，所有现存和未来新建的 page / database 都能直接 search / fetch / update，**不需要逐页 share**
> 2. **"Use Claude on selected pages"** → 仅授权当时勾选的 page 子树，等同旧 Internal Integration 的白名单模式
>
> 老的 Internal Integration（self-host npx + API key 时代）才**必须**逐页 share，hosted MCP OAuth 不是。本仓库早期文档承袭了旧描述，现已更正。

**自检"我授权了哪种范围"**：让 Claude 调用 `notion-search` 一个空泛 query（如 "test"）——

- 能看到 workspace 里多年前建的老 page → 选了 entire workspace（已是全量接入）
- 只能看到最近自己手动 share 的几页 → 选了 selected pages（按下面入口扩范围）

**想限制范围 / 事后调整白名单**：

1. **页面级 share**（少量精确控制）：打开目标页面 → 右上角 `•••` → `Connections` → `Add connections` → 搜你授权时挂的 integration（hosted MCP 通常显示为 "Claude" / "Notion MCP"）→ 点上去 → Confirm
2. **批量管理**（全局视角）：Notion `Settings` → `Connections` → 找到 integration → `Access` tab → 增删授权范围

**关键差异速记**（vs 飞书）：飞书"组织内默认可见、按云空间权限"；Notion OAuth "授权范围在 OAuth 同意页一次性敲定，事后改要去 Settings → Connections"。

**最佳实践**：

- 个人小 workspace（< 50 page）→ 直接选 entire workspace，省心
- 多用户 / 商业 workspace → 选 selected pages，把要给 Claude 看的页拖到一个父页（如 `Claude-Accessible/`）下，授权父页面 → 子页面自动继承

### 详细文档

- 官方 hosted MCP 文档：<https://developers.notion.com/docs/get-started-with-mcp>
- 官方 Claude Code plugin：<https://github.com/makenotion/claude-code-notion-plugin>
- Notion API（block 结构等底层参考）：<https://developers.notion.com/>
- Block 结构参考：<https://developers.notion.com/reference/block>
- （deprecated）self-host server：<https://github.com/makenotion/notion-mcp-server>

### 核心工具能力（Notion MCP）

典型工具（hosted MCP 与 self-host 工具名可能略有差异，以实际 server 版本为准）：

- `search` — 工作区全局搜索页面 / database
- `retrieve-page` / `retrieve-block-children` — 读取页面 / 块树
- `create-page` — 在父页或 database 下建新页
- `update-page` / `append-block-children` / `patch-block-children` — 更新页面属性、追加块、精确改块
- `query-database` — 过滤 / 排序 database
- `create-comment` / `retrieve-comments` — 评论

方式 A（plugin）额外提供 slash command 包装：`/Notion:search`、`/Notion:create-page`、`/Notion:create-task`、`/Notion:database-query`，底层还是上面这套工具。

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
