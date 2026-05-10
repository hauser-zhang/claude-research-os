---
name: guided-setup
description: >-
  带用户配置一个工具、账号、权限、token、CLI、MCP、外部平台集成或开发环境时触发；
  尤其适用于用户明确说“带我做”“一步一步”“顺便讲原理”“我想学习一下”。
  目标是边做边教：每一步先解释概念和为什么要做，再执行或让用户执行，
  最后验证真实可用状态并沉淀路径、配置文件、权限和后续维护命令。
---

# Guided Setup

## 定位

把一次配置过程变成可学习、可复现、可检查的共同操作。适用于 Feishu / Notion / GitHub / npm / SSH / MCP / API token / 数据库连接 / 远程服务器等 setup。

核心原则：**先建立 mental model，再做最小一步，再验证，再解释下一步**。

## 工作流

### 1. 建立状态图

先检查当前状态，不直接重装或重配：

- 已安装什么版本
- 配置文件在哪里
- 当前登录 / token / profile 是谁
- 缺的是安装、应用凭据、用户授权、权限 scope，还是验证命令

把系统拆成 2-4 个概念层讲清楚。例如 OAuth setup 可拆成：

```text
CLI binary -> app credentials -> user authorization -> resource permission -> verification
```

### 2. 一步一讲

每一步按这个结构输出：

```text
我们现在做 X。
原理：X 负责把 A 和 B 绑定起来，不等于 Y。
我会运行/请你打开：<command 或 link>
成功标志：看到 <observable result>。
```

用户需要浏览器授权、扫码、输入验证码或确认高风险权限时，暂停等待。不要要求用户把 secret、token、password 明文发到聊天里。

### 3. 最小权限优先

先申请当前任务需要的最小权限。后续发现缺 scope，再增量授权。解释“后台启用 scope”和“用户授权 scope”的区别。

### 4. 每步都验证

不要只相信“命令没报错”。至少做一条真实读操作或轻量写操作：

- 读：status / list / search / whoami
- 写：优先 dry-run 或创建测试资源；写前说明影响范围
- 权限：用 check 命令列出 granted / missing

### 5. 收尾交付

结束时给出短清单：

- 安装位置 / 配置文件位置
- 当前账号 / profile / identity
- 已授权权限或能力
- 验证过的命令
- 常用维护命令
- 仍未做或需要用户以后补的权限

## 安全规则

- 不在终端或聊天中输出 secret / token 明文
- 不静默覆盖已有配置；看到多 profile / existing config 先解释
- 高风险写操作先 dry-run 或请用户确认
- 遇到权限不足，先读错误里的 missing scope / console URL，再修

## 判断放哪里

- 某个平台的具体命令、scope、坑点：放 `.claude/rules/platforms/<platform>.md`
- “带读式配置”的通用交互方法：放本 skill
- 只某个项目的私有 token、文档 ID、服务器路径：放 L3 `projects/<name>/CLAUDE.md` 或项目 `.claude/`
