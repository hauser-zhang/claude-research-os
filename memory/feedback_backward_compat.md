---
name: Backward Compatibility
description: 代码修改必须向下兼容——旧 YAML、旧 checkpoint、旧推理路径不能因新功能而报错
type: feedback
---

代码修改必须保证向下兼容：旧配置文件、旧模型权重、旧推理流程在新代码下正常运行。

**Why:** 用户明确强调"向下兼容一定是后续修改代码的重要原则"。训练周期长（数天），不能因为框架升级导致正在跑的实验或已有结果不可用。

**How to apply:**
1. **新 YAML 字段必须有默认值**：旧 YAML 缺失新字段时，OmegaConf merge 自动填默认值，不报错
2. **checkpoint 格式不可变**：state_dict 结构不能改，新功能只加 trainer 层包裹，不动模型本身
3. **推理路径隔离**：AMP/TF32/TensorBoard 等训练优化只在训练器（Trainer）中生效，推理器（Predictor）完全不碰
4. **每次改代码前验证**：用旧 YAML + 旧 checkpoint 测试 load_config + load_state_dict + 推理，确认不报错
5. **新功能用 YAML 开关控制**：`train.amp: true/false`，而非代码里写死，用户可随时回退
