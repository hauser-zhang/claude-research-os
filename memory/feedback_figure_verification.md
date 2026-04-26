---
name: Figure output verification
description: User requires visual verification of generated figures — code changes alone are not trusted; check colorbar scale, label overlap, and layout
type: feedback
---

修改绘图代码后必须实际查看生成的图片确认效果，不能仅凭代码逻辑判断"应该没问题"。

**Why:** 2026-04-09 Panel E 连续出现三次问题：(1) 相对值没乘100显示为0~0.7而非百分比，(2) colorbar 与热图重叠，(3) 99行VF标签严重拥挤。每次都是用户看图后发现的，Claude 多次声称"已修复"但实际效果仍有问题。

**How to apply:**
1. 修改可视化代码后，必须 scp 图片到本地并用 Read 工具查看
2. 关注：colorbar 位置是否遮挡内容、刻度值单位是否正确（%）、标签是否可读
3. 图的布局要符合科研论文习惯（colorbar 不与数据区重叠，标签不拥挤）
4. seaborn.clustermap 的 axes 布局：用 `get_position()` 获取实际坐标再决定 cbar_pos，不要盲猜
5. 如果标签过多导致拥挤，优先用 `max_display` 参数限制展示行数（数据层 CSV 不变）
