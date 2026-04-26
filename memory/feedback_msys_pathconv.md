---
name: MSYS Path Conversion Fix
description: lark-cli api calls with /open-apis/... paths fail on Windows Git Bash — must use MSYS_NO_PATHCONV=1
type: feedback
---

Windows Git Bash converts `/open-apis/...` to `C:/Program Files/Git/open-apis/...`, causing HTTP 404.

**Why:** Git Bash's MSYS layer performs POSIX-to-Windows path conversion for arguments starting with `/`. The lark-cli `api` subcommand with raw path `/open-apis/wiki/v2/...` gets mangled before the HTTP request is made.

**How to apply:** Always prefix with `MSYS_NO_PATHCONV=1` when calling `lark-cli api`:
```bash
MSYS_NO_PATHCONV=1 lark-cli api POST "/open-apis/wiki/v2/spaces/SPACE_ID/nodes/NODE_TOKEN/move" \
  --as user --data '{"target_parent_token":"TOKEN"}'
```
This applies to ALL `lark-cli api` calls with path arguments starting with `/`. The `lark-cli docs +create`, `lark-cli wiki spaces get_node` etc. (shortcut commands) are NOT affected — only the raw `lark-cli api METHOD /path` form.

Also applies to SSH heredoc content containing Unix paths: `MSYS_NO_PATHCONV=1 ssh host bash << 'EOF'` prevents MSYS from mangling `/data1/...` paths inside the heredoc, which would cause "unexpected EOF looking for matching `'`" errors. Use SCP for large files: `MSYS_NO_PATHCONV=1 scp "//share/path/file" "host:/dest/path"`.
