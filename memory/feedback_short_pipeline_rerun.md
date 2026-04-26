---
name: Short Pipeline Rerun Policy
description: For pipelines that finish in minutes, after bugfix/style change always rerun and overwrite outputs in-place instead of creating _v2/_v3 suffixed copies
type: feedback
originSessionId: 820ad158-9864-4d9c-901b-cffb3330c5f6
---
修 bug 或调作图风格后，先估算 pipeline 运行时间：
- **< 10 分钟**：清空当前任务目录下的旧输出 → 原地重跑覆盖，**不要**生成 `_v2`/`_v3` 后缀
- **> 10 分钟或依赖远端 GPU 训练**：新建带日期或版本后缀的子目录，保留旧结果

**Why:** 用户反馈："别多出很多 `_v2`/`_v3` 的图我都不知道啥意思"。很多科研 pipeline 耗时较短（case study 几十秒、作图 pipeline 几分钟），版本后缀只会带来路径冗余。同时必须严守 session 边界——清旧结果时只清当前任务目录，绝不批量删其他 session 的输出。

**How to apply:**
1. 跑 pipeline 前 `time <command>` 或看类似任务的历史耗时评估
2. 确认 <10min 后：
   - 复用 pipeline 内建的清理逻辑（如各 case study 自带的 `_cleanup_figures_dir`）
   - 或手动 `rm` **当前任务专属目录下**的旧 png/svg/csv（eg. `figures/`、`merged_results/`）
3. **禁止**：
   - `rm -rf` 其他 session 的输出目录（如别人在跑的训练 run、别的 case study）
   - 无差别清整个 `Results/` 根目录
   - 给输出文件加 `_v2`/`_v3` 后缀当作"保留旧版本"——用 git 留痕代码变更才是正确做法
4. 清理时打 log 说明清了什么（好的 pipeline 内建这个输出：`Cleaned N old figure(s) from <dir>: [...]`）
