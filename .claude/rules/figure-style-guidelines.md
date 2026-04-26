# 学术图表绘制规范（Publication-Quality Figures）

## 适用范围
所有需要放入论文/PPT/飞书的分析图表。本规范基于 Nature/Science/Cell 系列期刊的通用要求。

## 输出格式（铁律）

**每张图必须同时生成两种格式**：
1. **SVG**（矢量图，用于论文投稿和编辑）— `fig.savefig(..., format="svg")`
2. **PNG**（位图，用于预览、飞书插入、PPT）— `fig.savefig(..., dpi=300, format="png")`

**不再生成 PDF**。SVG 是更通用的矢量格式，所有期刊均接受，且浏览器/飞书可直接预览。

代码模板：
```python
for fmt in ["svg", "png"]:
    fig.savefig(f"{output_stem}.{fmt}",
                dpi=300 if fmt == "png" else None,
                bbox_inches="tight",
                transparent=False)
```

## 分辨率

| 图类型 | 最低 DPI | 推荐 DPI |
|--------|---------|---------|
| 线图 / 柱图 / 散点图 | 300 | 300（矢量优先） |
| 照片 / 电泳图 | 300 | 600 |
| 组合图（混合） | 300 | 300 |

## 字体规范

| 参数 | 值 | 说明 |
|------|---|------|
| 字体族 | **Arial**（首选）或 Helvetica | Nature/Cell/Science 均要求 sans-serif |
| 正文字号 | **8–10 pt** | 期刊最终排版后的字号；脚本中设 8–10 pt |
| 轴标签 | **9 pt** | 清晰且不浪费空间 |
| 刻度标签 | **8 pt** | 比轴标签小 1 pt |
| 图标题 | **10 pt bold** | 仅在独立子图时使用 |
| 图例 | **8 pt** | 紧凑 |
| 统计注释 | **8–9 pt** | p 值、星号等 |

**字体嵌入**：
```python
plt.rcParams["svg.fonttype"] = "none"   # SVG 文字保持可编辑
# PDF 已不再使用，无需设置 pdf.fonttype
```

## 颜色规范

### 调色板原则
- 使用**色盲友好**（colorblind-safe）的调色板
- 推荐 Tableau 10 / ColorBrewer / Okabe-Ito 色板
- 同一张 Figure 内所有 Panel **必须使用统一色板**
- 偏好**亮色系**（不要过暗），正式出版物中亮色更易辨识

### 示例色板（亮色系，供项目参考）
```python
# 示例：三类样本对比的亮色系色板
PALETTE = {
    "Class A":    "#F28E2B",   # 橙色（Tableau 10 Orange）
    "Class B":    "#4E79A7",   # 蓝色（Tableau 10 Blue）
    "Background": "#BAB0AC",   # 灰色（Tableau 10 Gray）
}
```

项目内的标准色板建议放到 L3 `projects/<name>/.claude/rules/figure-style.md` 里，并保持整个项目的 Figure 都用同一色板。

### 连续色阶
- 富集分析气泡图：`YlOrRd`（黄→橙→红）
- 热图：`RdBu_r`（红蓝发散）或 `viridis`

## 布局规范

### 紧凑原则
- **最小化空白**：期刊版面寸土寸金，图内空白越少越好
- `fig.tight_layout()` + `bbox_inches="tight"` 是必须的

### 尺寸规范（A4 论文排版导向）

**核心原则**：图片生成时即按论文排版的实际尺寸输出，用户无需再缩放。

| 布局 | 宽度 (mm) | 宽度 (inches) | 典型用途 |
|------|----------|--------------|---------|
| 单栏 | **85** | 3.35 | 单个小图（violin、bar） |
| 1.5 栏 | **114** | 4.49 | 中等图（气泡图、热图） |
| 双栏（满幅） | **170** | 6.69 | 组合 Figure（多 Panel） |

- 最大高度：**225 mm**（~8.86 in），超过后 reviewer 看不完整
- figsize 用 **inches** 传入 matplotlib：`fig, ax = plt.subplots(figsize=(6.69, 4.0))`
- 生成的图直接粘贴到 A4 Word/LaTeX 中应当尺寸合适，无需手动缩放
- 组合 Figure 中各 Panel 按实际排版比例安排（如 2×2 网格、1+3 布局等）

```python
# 常用尺寸常量（inches）
FIG_SINGLE_COL = 3.35    # 85 mm
FIG_1_5_COL = 4.49       # 114 mm
FIG_DOUBLE_COL = 6.69    # 170 mm
FIG_MAX_HEIGHT = 8.86    # 225 mm
```

### 子图标题
- **组合 Figure 中子图不加标题**（标题信息放图注里）
- 只在独立单图时加标题
- 用 (A)、(B)、(C) 标注面板，放在子图左上角

### 坐标轴
- 只保留左侧 Y 轴和底部 X 轴（去掉 top/right spine）
- Y 轴标签首字母大写（如 "Pathogenic domain ratio" 而非 "pathogenic domain ratio"）
- 特殊符号使用 Unicode：`−log₁₀` 用 `"\u2212log\u2081\u2080"` 而非 `"-log10"` 或 Matplotlib 的 `$-\log_{10}$`
  - 注意：在 SVG/PNG 中，LaTeX `$...$` 可能导致方块乱码；优先用 Unicode 字符
  - 下标数字：₀ ₁ ₂ ₃ ₄ ₅ ₆ ₇ ₈ ₉（U+2080–U+2089）
  - 负号：− (U+2212) 而非 ASCII 的 -

## matplotlib 全局配置模板（v2）

```python
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

plt.rcParams.update({
    "font.family": "sans-serif",
    "font.sans-serif": ["Arial", "DejaVu Sans"],
    "font.size": 9,
    "axes.titlesize": 10,
    "axes.labelsize": 9,
    "xtick.labelsize": 8,
    "ytick.labelsize": 8,
    "legend.fontsize": 8,
    "axes.spines.top": False,
    "axes.spines.right": False,
    "axes.linewidth": 0.8,
    "xtick.major.width": 0.6,
    "ytick.major.width": 0.6,
    "svg.fonttype": "none",
})
```

## 图表类型特定规范

### 小提琴图 / 箱线图
- 不加独立标题（信息放图注）
- boxplot 叠加层 width ≤ 0.1
- 统计注释（星号 + 横线）统一风格：线宽 0.8，字号 8–9 pt
- 均值虚线：黑色 `--`，linewidth=1.5

### 气泡图（GO/KEGG 富集）
- 横轴 `log₂(OR)` 用 Unicode 下标
- colorbar 标签用 Unicode：`−log₁₀(adj. p-value)`
- 图例气泡大小标注在右下角
- Y 轴标签首字母大写
- 紧凑高度：`fig_h = max(4, n_terms * 0.28 + 1.0)`

### 柱状图（COG 等）
- 分组柱间距 ≤ 0.4
- 显著性标注统一用 `*`（不用 `**` `***` 分级，除非需要区分 p 值量级）
- X 轴标签旋转 35°，ha="right"

## 质量自检清单（每次出图后必须检查）

- [ ] 字体是否为 Arial/sans-serif，8–10 pt 范围内？
- [ ] 所有 Panel 配色是否一致（同一色板）？
- [ ] Y 轴标签首字母大写？
- [ ] Unicode 特殊符号（下标、负号）显示正常（无方块乱码）？
- [ ] 空白最小化（`tight_layout` + `bbox_inches="tight"`）？
- [ ] 同时生成了 SVG + PNG？
- [ ] SVG 字体类型设为 `"none"`（可编辑文字）？
- [ ] 独立子图无多余标题（标题放图注）？
- [ ] 图例紧凑、不遮挡数据？
