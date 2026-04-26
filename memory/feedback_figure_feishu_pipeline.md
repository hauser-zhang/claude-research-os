---
name: Figure to External-Platform Insertion Pipeline
description: 服务器图表插入外部协作平台（飞书 / Notion / Confluence 等）的完整 pipeline：SVG 不可靠，用 Ghostscript 从 PDF 转 PNG，再 +media-insert
type: feedback
---
将服务器上的图表插入外部协作平台文档的标准流程，务必按此执行。

**Why:** 某次 session 中，ImageMagick `convert` 无法处理复杂 matplotlib SVG（`non-conforming drawing primitive`），PNG 只有 11K 实为空白/破损；PDF 转换又被 Ubuntu ImageMagick 安全策略拒绝（`not authorized`）。最终用 Ghostscript 成功，生成 70-140K 正常图片。

**How to apply:**

**Step 1: 服务器上 PDF → PNG（用 Ghostscript）**
```bash
# 不要用 ImageMagick convert（SVG path 报错 / PDF 权限被拒）
# 用 gs，注意 -sDEVICE=pngalpha 保留透明通道，-r300 为 300dpi
gs -dBATCH -dNOPAUSE -dSAFER -sDEVICE=pngalpha -r300 \
   -dFirstPage=1 -dLastPage=1 \
   -sOutputFile=/path/to/output.png \
   /path/to/input.pdf
```
建议统一输出到 `res_png_for_external/` 目录（与图表结果目录同级）。

**Step 2: SCP 到本地（逐文件列出，不要用 brace expansion）**
```bash
# brace expansion {lv1,lv2,lv3}.png 在部分 shell 下不支持，会报 No such file
# 正确做法：一次传所有文件，或逐个 scp
scp "<server>:/path/a.png" "<server>:/path/b.png" "C:/local/dest/"
```

**Step 3: 插入外部平台（cd 到文件目录后用相对路径）**
```bash
cd "C:/local/dest"
MSYS_NO_PATHCONV=1 lark-cli docs +media-insert \
  --doc "<DOC_ID>" --as user \
  --file "a.png" --caption "Figure X: ..."
```

注意：同一文档多图时逐张顺序插入，每张等上一张完成再执行下一条。
