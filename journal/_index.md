# Journal — 每日 Lab Notebook

> 每次 session 开始 / 结束在对应日期文件追加。格式：`journal/YYYY-MM-DD.md`。
> 记录：今天想做什么、实际做了什么、遇到什么 friction、下一步是什么。
>
> 开源模板发行版：`journal/` 下的具体日记是维护者的私人 lab notebook，`.gitignore` 默认排除。
> 开源用户：在本文件的 Index 表格追加你自己的日期。

## Index

| Date | Summary |
|------|---------|
| _(待填充)_ | — |

---

## 每日 journal 推荐骨架

```markdown
# YYYY-MM-DD — <一句话摘要>

## 今天目标
- ...

## 完成工作
### <子任务 / 变更>
...

## Frictions（今天记录）
1. <现象> → <假设>

## 下一步（等用户指示）
- ...
```

**关键原则**：每日 journal 与 `tracks/<track>/<thread>/frictions.md` 互补——thread frictions 绑定具体任务，journal 捕获跨任务的流程观察。session-end 时两者都会被 `/session-end` 命令 grep 到 `meta/frictions-backlog.md`。
