---
name: Long Task Monitoring — Sub-agent Pattern
description: 长时间任务（训练/推理）必须用后台 sub-agent 轮询，主 agent 保持空闲接收用户新任务
type: feedback
---

启动训练/推理/数据处理等长时间任务后，主 agent 不得 sleep/wait，必须立即释放为空闲状态。

**Why:** 用户在训练运行期间可能随时分配新任务，主 agent 阻塞会导致无法并行处理。

**How to apply:**
1. `nohup ... &` 后台启动任务，记录 PID 和 log 路径
2. 立即 `Agent(..., run_in_background=True)` 启动监控 sub-agent
3. 主 agent 告知用户"任务已启动，sub-agent 后台监控"，回到空闲

**轮询间隔：** Bash tool 最大 timeout=600000ms，`sleep 600`（10分钟）是上限，不能用 `sleep 1200`。

**sub-agent 只在停止条件（完成/OOM/崩溃）时通知主 agent，中间状态不汇报。**

---

## ⚠️ 崩溃判断铁律

**禁止用 GPU 利用率判断卡死。** DataLoader 加载间隙 GPU=0% 是正常的。用此条件会误杀健康训练，导致从头重跑浪费数小时 GPU。

### 崩溃判断（三条必须同时满足）
1. 进程数为 0
2. log 超过 300 秒未更新（`stat -c %Y` 检查）
3. log 末尾无完成标志

### 崩溃后 Resume（必须用原目录）
```bash
python -m <your-training-module>.train --config <YAML> --continue_train --resume_dir <原run目录>
```
不加 `--resume_dir` 会新建时间戳目录从头训练，浪费 GPU 时间。
