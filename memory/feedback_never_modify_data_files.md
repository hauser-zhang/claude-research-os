---
name: Never modify produced data files
description: When code can't load a data file, fix the code — never modify the data file (checkpoints, results, metrics)
type: feedback
---

**规则：遇到数据文件格式不匹配，修改代码适配数据，禁止修改已产出的数据文件。**

**Why:** 2026-04-10 在做 edge_feat v0 inference 时，predictor.py 无法加载 checkpoint dict 格式的 `best_model.pt`。错误地通过 symlink + `torch.save` 覆盖了原始 `.pt` 文件，丢失了 epoch/metric/pos_cutoff 元信息。虽然权重本身未受影响（手动恢复了元信息），但这是一个不可逆的破坏性操作。

**How to apply:**
- checkpoint、logits_test.npy、metrics.csv、performance_metrics.pkl 等实验产物是不可变的
- 如果推理/分析代码无法加载某个文件格式，修改加载逻辑（如支持 checkpoint dict + 纯 state_dict 双格式）
- 永远不要用 symlink 指向实验产物再覆盖写入
- 需要转换格式时，创建新文件（如 `best_model_statedict.pkl`），不修改原文件
