---
name: Lark Media Insert Path Constraint
description: lark-cli docs +media-insert 只接受相对路径，必须先cd到文件所在目录
type: feedback
---
`lark-cli docs +media-insert --file` 参数**只接受当前目录下的相对路径**，传绝对路径会报错：
```
error: unsafe file path: --file must be a relative path within the current directory
```

**Why:** 某次 session 中，直接传 `C:/Users/<user>/AppData/Local/Temp/<file>.png` 被拒绝。

**How to apply:**
```bash
# 错误
lark-cli docs +media-insert --doc "xxx" --file "C:/full/path/to/image.png"

# 正确
cd "C:/full/path/to" && lark-cli docs +media-insert --doc "xxx" --file "image.png"
```

需配合 `MSYS_NO_PATHCONV=1` 防止 Git Bash 的路径自动转换（见 feedback_msys_pathconv.md）。
