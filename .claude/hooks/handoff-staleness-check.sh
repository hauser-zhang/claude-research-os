#!/usr/bin/env bash
# SessionStart hook: warn when HANDOFF.md is stale relative to thread activity.
#
# Two heuristics (both reported in the systemMessage):
#   1. tracks/**/*.md has any file newer than HANDOFF.md
#      → thread activity happened but HANDOFF wasn't synced
#   2. HANDOFF.md mtime > 72h
#      → absolute staleness threshold even if tracks didn't move
#
# Emits a JSON with `hookSpecificOutput.additionalContext` so the
# warnings land in the model's system prompt on session start.
#
# Cross-project: scans projects/*/.claude/HANDOFF.md under the repo root.
# Underscore-prefixed projects (e.g. _example, _template-*) are skipped — by
# convention they are read-only reference skeletons that never advance.
# Fails silent (exit 0, no output) if scan can't find anything sensible —
# hooks that complain about themselves are worse than no hook.

set -u

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
THREE_DAYS_SEC=$((72 * 60 * 60))
NOW=$(date +%s)

warnings=()

for handoff in "$REPO_ROOT"/projects/*/.claude/HANDOFF.md; do
    [ -f "$handoff" ] || continue
    project_dir="$(dirname "$(dirname "$handoff")")"
    project_name="$(basename "$project_dir")"
    case "$project_name" in _*) continue ;; esac
    handoff_mtime=$(stat -c %Y "$handoff" 2>/dev/null || echo 0)
    [ "$handoff_mtime" -gt 0 ] || continue

    age_sec=$((NOW - handoff_mtime))
    age_days=$((age_sec / 86400))

    # Heuristic 2: absolute staleness > 72h
    if [ "$age_sec" -gt "$THREE_DAYS_SEC" ]; then
        warnings+=("[$project_name] HANDOFF.md 未更新 $age_days 天（mtime 超过 72h 阈值）")
    fi

    # Heuristic 1: tracks/ has files newer than HANDOFF
    tracks_dir="$project_dir/tracks"
    if [ -d "$tracks_dir" ]; then
        newer_count=$(find "$tracks_dir" -type f -name '*.md' -newer "$handoff" 2>/dev/null | wc -l | tr -d ' ')
        if [ "$newer_count" -gt 0 ]; then
            newest_file=$(find "$tracks_dir" -type f -name '*.md' -newer "$handoff" -printf '%T@ %p\n' 2>/dev/null | sort -n | tail -1 | awk '{print $2}')
            newest_rel="${newest_file#$REPO_ROOT/}"
            warnings+=("[$project_name] tracks/ 下有 $newer_count 个 md 比 HANDOFF.md 新（最新：$newest_rel）→ HANDOFF 活跃 thread 盘点可能过期")
        fi
    fi
done

if [ ${#warnings[@]} -eq 0 ]; then
    # No warnings → no output, hook is silent on healthy state
    exit 0
fi

# Emit additionalContext via hookSpecificOutput
{
    printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"'
    printf 'HANDOFF 老化检查（hook 自动提醒）：\\n'
    for w in "${warnings[@]}"; do
        # escape backslashes and double quotes for JSON
        esc=$(printf '%s' "$w" | sed 's/\\/\\\\/g; s/"/\\"/g')
        printf -- '- %s\\n' "$esc"
    done
    printf '\\n→ 如本 session 会推进/修改 thread 状态，请在 session 结束前同步 HANDOFF §1 活跃 thread 盘点。'
    printf '"}}'
} 2>/dev/null

exit 0
