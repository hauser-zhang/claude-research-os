---
name: Research OS Architecture v1
description: 协作范式升级决策——从单项目协作升级为 Research OS 分层架构，未来所有科研工作在此框架下进行
type: feedback
---
用户要求把单项目协作体系升级为通用的 Research OS（个人科研操作系统），未来开源。

**Why:** 当前协作体系存在三个痛点：(1) 知识没有 compound——文献埋在外部平台 Survey 里无法跨方向复用；(2) 过程与知识耦合——Brainstorm/Survey/Results 全挤在一个文档模块；(3) skill/rules 没有作用域分层——项目专属和通用的混在一起。用户希望扩展到覆盖科研项目 + 写作 + 日程 + 文献学习。

**How to apply:**

1. **三层架构（L1/L2/L3）**：
   - L1 全局 `~/.claude/` — 所有会话通用
   - L2 Research OS 仓库根 `.claude/` — 所有科研项目通用
   - L3 项目专属 `projects/<name>/.claude/` — 绑定项目的路径/服务器/文档结构
   - 判断标准：只一个项目用→L3；所有科研项目用→L2；跨 domain→L1

2. **Dual-Primary 知识架构**：
   - `projects/<name>/tracks/<track>/<thread>/`（过程层，time-ordered）：决策叙事、失败教训
   - `wiki/`（知识层，timeless）：论文、概念、数据集、综合（跨项目共享）
   - 双向链接通过 `wiki_touches` frontmatter + `## Touched By` 自动同步

3. **五阶段研究流程**：00 Brainstorm → 01 Survey → 02 Proposal → 03 Implement → 04 Experiment
   每阶段 Claude 扮演不同 agency（pair divergent / autonomous / pair critical / autonomous milestone / critical reporter）

4. **Self-Evolving 机制**：friction 实时捕获（一行 md）→ session-end 汇总 → weekly meta-review 批处理

5. **Skill 按 Anthropic 官方三层规范**：metadata + SKILL.md<500 行 + references/ 吸收细节；不写死的 MUST/ALWAYS，要解释 why

6. **外部协作平台定位**：镜像视图（分享给导师/合作者），不是权威来源。本地 md 是源。

7. **Memory 分层**：L2 存跨项目通用的 feedback（协作风格、研究纪律）；L3 项目 memory 存项目专属（特定数据格式、实验状态）

8. **ADR 记录架构决策**：L2 `decisions/`（Research OS 级）+ 项目 `projects/*/decisions/`（项目级）

**保留原则**：所有历史工作（feedback、外部平台文档、skill 演化）不丢弃，都迁入新框架对应层级。"这些过程都非常宝贵。"
