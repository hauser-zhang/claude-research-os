# Learning — 非任务驱动阅读

> 定位：跨科研项目的自主学习入口。读的是**当前 thread 不直接需要**但对长期能力有益的材料（新方法论、新工具、跨领域论文、行业 blog、大神 GitHub 笔记）。
> 对比：thread 内的 `01-survey.md` 是任务驱动的调研——有明确的待决策问题。本目录是"为了长期能力储备"。

---

## 三种素材的归宿（ADR-0004 三段管道）

```
             ┌────────────────────────────────────────────────┐
             │                                                │
 学术论文 ─────→ raw/papers/<slug>.pdf ─────→ wiki/papers/<slug>.md
            │                                                  │
 博客 / GitHub │                                                  │
 笔记 / 推文   │─→ raw/clippings/<slug>.md ──→ learning/<slug>.md─┼→ wiki/syntheses/<theme>.md
            │                                                  │   （可选：跨多源综合）
 教程 /     │                                                  │
 YouTube 讲解 │─→ raw/clippings/<slug>.md ──→ learning/<slug>.md─┘
             │
             └────────────────────────────────────────────────┘
```

| 素材类型 | 原始源去向 | 消化笔记去向 | 升级条件 |
|---------|-----------|-------------|---------|
| **学术论文**（有 DOI / venue / 同行评议） | `raw/papers/<slug>.pdf` | 直接进 `wiki/papers/<slug>.md` | — |
| **博客 / GitHub notes / 推特长文** | `raw/clippings/<slug>.md`（原 URL + 引用摘录） | **`learning/<slug>.md`**（消化笔记） | 凑齐 3+ 同主题源 → `wiki/syntheses/<theme>.md` |
| **教程 / YouTube 讲解** | `raw/clippings/<slug>.md`（链接 + 要点列表） | **`learning/<slug>.md`**（我学到了什么） | 同上 |

**为什么 blog / GitHub 不进 `wiki/papers/`**：blog 的权威性和可引用性远低于学术论文。进 `wiki/papers/` 会让 Claude 在 citation 时把两类等量齐观——这在严肃 reviewer 面前会翻车。

**如果 blog 真的要被多处引用**：默认路径是 `wiki/syntheses/`，把多篇 blog + 几篇 paper 综合成一个论点。只有当某个 blog 本身被超级反复引用（且作者 + 日期 + 链接锚点稳定）时才降级放 `wiki/papers/`，frontmatter 用 `type: blog-post` 和真正的 paper 区分开。

---

## 使用方式

**当你读完一篇有价值的博客 / GitHub 笔记 / 大神推文**：

1. **落原始源**（2 分钟）
   ```bash
   # 落 raw/
   cat > raw/clippings/karpathy-2026-01-llm-coding-pitfalls.md <<'EOF'
   ---
   source_url: https://x.com/karpathy/status/2015883857489522876
   fetched: 2026-01-27
   author: Andrej Karpathy
   type: x-post
   ---

   > The models make wrong assumptions on your behalf and just run along with them...
   > (粘贴原文 / 截图路径)
   EOF
   ```

2. **写消化笔记**（5-15 分钟，取决于长度）
   ```bash
   cat > learning/karpathy-llm-coding-pitfalls.md <<'EOF'
   ---
   title: Karpathy 的 LLM 编码陷阱观察
   source: raw/clippings/karpathy-2026-01-llm-coding-pitfalls.md
   status: draft
   ---

   ## 核心观点
   ...

   ## 对我有什么启发
   - 我项目里遇到过哪些类似现象？
   - 有哪些点我**不**同意 / 不适用我的场景？

   ## 值得进一步做的
   - 要不要升级为本项目的 .claude/rules/... ?
   - 要不要看相关的其他源再综合？
   EOF
   ```

3. **在本文件 Learning Log 追加一行**

4. **（可选）升级为 wiki/syntheses/** — 等你读到 3+ 篇同主题源、且综合起来有新论点时

**当你发现一个大神的整个 GitHub skill 仓库（如 `forrestchang/andrej-karpathy-skills`）**：
- 如果仓库是 MIT / Apache-2.0 / BSD / ISC 等 MIT-compatible 许可 → 直接 **mirror 进 `.claude/skills/upstream/<slug>/`**（见 [ADR-0004 · Q2 部分](../decisions/ADR-0004-learning-sources-and-skills-split.md)）
- 不兼容 MIT → **不要** mirror；只在本文件 Learning Log 里留链接 + 一句 takeaway

---

## Learning Log

| Date | Slug | Type | Takeaway |
|------|------|------|----------|
| _(待填充)_ | — | — | — |

**Type 枚举**：`paper` / `blog` / `x-post` / `github-notes` / `youtube` / `talk`

---

## 当前学习目标

_列出当前想集中读的主题 + 为什么。示例：_

- **Transformer scaling laws** — 理解 isoFLOPs 曲线，以决定后续项目的 compute budget 分配策略
- **图神经网络 expressivity** — 为未来 graph-based 研究打底
- **Andrej Karpathy / Simon Willison / Jay Alammar blog** — LLM 编码与评估模式的长期跟踪
