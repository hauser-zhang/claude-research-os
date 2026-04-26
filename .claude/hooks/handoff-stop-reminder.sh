#!/usr/bin/env bash
# Stop hook: remind to update HANDOFF.md if tracks/ moved this session.
#
# Runs when Claude stops (session end, /clear, /compact, etc.). Checks the
# same two heuristics as handoff-staleness-check.sh but emits a `systemMessage`
# (shown to user in the UI) instead of `additionalContext` (goes to model):
#   1. tracks/**/*.md has files newer than HANDOFF.md  → likely this session
#   2. HANDOFF.md mtime > 72h  (absolute threshold)
#
# The message is advisory — exit 0 without `continue: false` so it doesn't
# block anything.
#
# Cross-project: scans projects/*/.claude/HANDOFF.md.

set -u

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
THREE_DAYS_SEC=$((72 * 60 * 60))
NOW=$(date +%s)

msg_lines=()

for handoff in "$REPO_ROOT"/projects/*/.claude/HANDOFF.md; do
    [ -f "$handoff" ] || continue
    project_dir="$(dirname "$(dirname "$handoff")")"
    project_name="$(basename "$project_dir")"
    handoff_mtime=$(stat -c %Y "$handoff" 2>/dev/null || echo 0)
    [ "$handoff_mtime" -gt 0 ] || continue

    age_sec=$((NOW - handoff_mtime))
    age_days=$((age_sec / 86400))

    flagged=0
    reasons=()

    tracks_dir="$project_dir/tracks"
    if [ -d "$tracks_dir" ]; then
        newer_count=$(find "$tracks_dir" -type f -name '*.md' -newer "$handoff" 2>/dev/null | wc -l | tr -d ' ')
        if [ "$newer_count" -gt 0 ]; then
            flagged=1
            reasons+=("$newer_count 个 thread md 比 HANDOFF 新")
        fi
    fi

    if [ "$age_sec" -gt "$THREE_DAYS_SEC" ]; then
        flagged=1
        reasons+=("HANDOFF 已 $age_days 天未更新")
    fi

    if [ "$flagged" -eq 1 ]; then
        IFS='；' ; joined_reasons="${reasons[*]}" ; unset IFS
        msg_lines+=("[$project_name] $joined_reasons")
    fi
done

if [ ${#msg_lines[@]} -eq 0 ]; then
    exit 0
fi

{
    printf '{"systemMessage":"'
    printf 'Session 结束提醒：检查 HANDOFF §1 活跃 thread 盘点是否需要同步 —— '
    for ((i=0; i<${#msg_lines[@]}; i++)); do
        esc=$(printf '%s' "${msg_lines[$i]}" | sed 's/\\/\\\\/g; s/"/\\"/g')
        if [ $i -gt 0 ]; then printf '；'; fi
        printf '%s' "$esc"
    done
    printf '"}'
} 2>/dev/null

exit 0
