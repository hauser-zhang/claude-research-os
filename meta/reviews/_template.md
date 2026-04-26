# Meta-Review YYYY-MM-DD

<!-- 文件名命名: meta/reviews/YYYY-MM-DD.md (周五 / 周日做都行, 用当天日期) -->
<!-- 本模板落地位置: meta/reviews/_template.md -->
<!-- 复制一份改名为当天日期即可开始填写 -->

- **Review 周期**: YYYY-MM-DD ~ YYYY-MM-DD  <!-- 本次 review 覆盖的一周区间 -->
- **参与 threads**: `<project>/<track>/<thread>`, ...  <!-- 本周有活跃改动的 thread 列表 -->
- **Reviewer**: <你的名字> + Claude

---

## 1. 本周 frictions 分类汇总

<!-- 来源: grep 本周所有 tracks/*/frictions.md + meta/frictions-backlog.md 新增行 -->
<!-- Friction = 系统中任何不够用的地方; 捕获成本低, 决策批量做 -->
<!-- 每条格式: - [源路径] 现象一句话 → 处理方案 -->

### 1.1 规则空白 (rule gap)

<!-- 当前 .claude/rules/ 没覆盖到, 需要新规则或扩展现有规则 -->
- [tracks/xx/frictions.md:L12] ... → 新增 rule `.claude/rules/xxx.md`

### 1.2 模板缺章节 (template gap)

<!-- 五阶段 / wiki / meta-review 模板某个 section 不够用 -->
- [tracks/xx/frictions.md:L20] ... → 扩充 `<template>` 新增 `<section>`

### 1.3 命令 / skill 缺失 (tooling gap)

<!-- 手动重复操作, 应该沉淀成 skill 或脚本 -->
- [meta/frictions-backlog.md:L5] ... → 新建 skill `.claude/skills/own/xxx/`

### 1.4 Claude 误解 (AI misunderstanding)

<!-- Claude 反复搞错同一件事 → 规则表述有歧义, 需要重写 -->
- [tracks/xx/frictions.md:L8] ... → 重写 `rule/xxx.md` §N 消除歧义

---

## 2. 本次 review 产出

<!-- 列出本次 review 实际做了的改动; 对应上面每个 friction 至少给一个去向 -->
<!-- 未处理项不要假装处理, 留到 §4 backlog -->

| 类型 | 文件 | 说明 |
|------|------|------|
| 新 rule | `.claude/rules/xxx.md` | ... |
| 扩展 rule | `.claude/rules/yyy.md` §N | ... |
| 新 ADR | `decisions/ADR-00XX-xxx.md` | ... |
| 新模板 | `<path>/_template.md` | ... |
| skill 更新 | `.claude/skills/own/xxx/SKILL.md` | ... |

---

## 3. 下周 focus

<!-- 最多 3 个, 超过的留到 backlog; 不强行拉长 -->
1. ...
2. ...
3. ...

---

## 4. 累积未处理 backlog

<!-- 本周没处理的 frictions 已回流到 meta/frictions-backlog.md -->
<!-- 这里只标总数 + 高优先级前 3 条, 详见 backlog 文件 -->

- 未处理总数: N 条 (见 `meta/frictions-backlog.md`)
- 高优先级 (下周可能触发):
  - ...
  - ...
