---
name: Use gh CLI (and other authed CLIs) when WebFetch / WebSearch blocked
description: 当 WebFetch 返回 "Unable to verify domain" 或 WebSearch 返回 PROXY_ERROR 时，优先考虑用已认证的 CLI（gh / npm / pip / MCP）从官方 API 查同样信息
type: feedback
---

Claude Code 有三条"访问外部信息"的路径，走的是完全不同的基础设施：

| 工具 | 走哪 | 常见失败模式 |
|------|------|-------------|
| `WebSearch` | Claude API 搜索（Anthropic 代理） | 企业网络 / 代理策略拦截 → `PROXY_ERROR 400` |
| `WebFetch` | Claude SDK URL 取（claude.ai 域白名单） | "Unable to verify if domain is safe to fetch" |
| 已认证 CLI（`gh` / `npm` / `pip` / `lark` / MCP / ...） | 用户本机 token → 直连目标 API | 一般不被拦，等同手动 curl |

**Why:** 某次写开源 README 时需引用 3 个 GitHub repo 的 star 数 + tagline 作为 citation（"有据可依"铁律）。`WebSearch` 和 `WebFetch` 都被沙箱 / 代理拒绝，差点让任务延后一版。用户提示试 `gh api` —— 一次搞定，还能用 `/repos/<owner>/<name>` 精确核实，规避 search endpoint 的 fork/mirror 误匹配。

**How to apply:**

1. `WebFetch` / `WebSearch` 被拒 → **不要立刻延后任务 / 不要凭记忆**。先想：有没有已认证 CLI 能查同一信息？
2. 常见替换路径：
   - GitHub repo / org / issue / PR / release / star → `gh api <endpoint>` 或 `gh repo view <owner>/<name>`
   - npm 包元数据 → `npm view <pkg>`
   - PyPI → `pip index versions <pkg>` 或 `pip show <pkg>`
   - 已安装 MCP（Notion / Lark / ...）→ 直接调 MCP 工具
3. **Windows Git Bash 坑**：`gh api /search/repositories` 会被 MSYS 层转成 `C:/Program Files/Git/search/repositories` 导致 "invalid API endpoint"。前缀 `MSYS_NO_PATHCONV=1` 解决（见 `feedback_msys_pathconv.md`）
4. 核实质量分级：search endpoint 可能返回 fork/mirror（如搜"storm" 出现大量个人 fork），**要精确上游 → 用 `/repos/<owner>/<name>` 直取**，不用 search
