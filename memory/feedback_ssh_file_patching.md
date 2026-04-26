---
name: SSH File Patching Pattern
description: SSH远程写入Python文件时避免heredoc单引号陷阱 — cp+patch优于内联heredoc；行号定位优于字符串替换
type: feedback
---
SSH 远程写入/修改 Python 文件时，以下两个坑反复出现，必须遵守对应规范。

**Why:** 某个 session 在向远程插入代码块时、在写新 pipeline 时都踩到了这些坑，浪费了多轮调试。

---

## 坑 1：heredoc 内嵌 Python 单引号 → "unexpected EOF"

**症状**：SSH heredoc 内容含 Python 字符串字面量（单引号）时，shell 解析器遇到 `'` 提前结束 heredoc，报 `unexpected EOF while looking for matching`。

**错误做法**：
```bash
ssh <server> "cat > /path/to/file.py << 'EOF'
def foo():
    return 'hello'   # 这里的单引号会炸
EOF"
```

**正确做法 — cp + Python patch**：
1. 先将临时文件 cp 到目标位置：`ssh <server> "cp /tmp/source.py /dest/dir/file.py"`
2. 再用 Python heredoc 做字符串替换/追加（Python 字符串不受 shell 单引号影响）：
```bash
ssh <server> python3 << 'EOF'
with open('/dest/dir/file.py', 'a') as f:
    f.write('''
def new_function():
    return 'hello'
''')
EOF
```

**How to apply:** 每次需要 SSH 写入含 Python 字符串的文件时，优先用 cp+patch 路线，而不是 heredoc 内嵌 Python 代码。

---

## 坑 2：字符串 replace 找不到目标 → 改用行号定位插入

**症状**：`content.replace('目标字符串', ...)` 在 SSH 远程文件上找不到匹配，即使目标字符串看似正确（空格/缩进/引号细节不一致）。

**错误做法**：
```python
content = content.replace('target_line', 'new_line\ntarget_line')
```

**正确做法 — grep 行号 + Python 按行插入**：
```bash
# Step 1: 用 grep -n 找到目标行的行号
LINE=$(ssh <server> "grep -n 'target keyword' /path/to/file.py | tail -1 | cut -d: -f1")

# Step 2: Python 按行读入，在 LINE 前插入新内容
ssh <server> python3 << 'EOF'
path = '/path/to/file.py'
with open(path) as f:
    lines = f.readlines()
insert_idx = int($LINE) - 1   # 0-indexed
new_lines = ['new_content_line1\n', 'new_content_line2\n']
lines = lines[:insert_idx] + new_lines + lines[insert_idx:]
with open(path, 'w') as f:
    f.writelines(lines)
EOF
```

**How to apply:** 凡是 SSH 远程代码插入任务，先用 grep -n 定位行号，再按行列表插入，绝不用字符串 replace。
