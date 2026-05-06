#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
SessionStart hook: warn when HANDOFF.md is stale relative to thread activity.

Two heuristics (both reported in additionalContext):
  1. tracks/**/*.md has any file newer than HANDOFF.md
     -> thread activity happened but HANDOFF wasn't synced
  2. HANDOFF.md mtime > 72h
     -> absolute staleness threshold even if tracks didn't move

Emits JSON with hookSpecificOutput.additionalContext so warnings land in
the model's system prompt on session start.

Silent (exit 0, no stdout) when healthy.
Cross-project: scans projects/*/.claude/HANDOFF.md under the repo root.
Underscore-prefixed projects (e.g. _example, _template-*) are skipped — by
convention they are read-only reference skeletons that never advance.
"""
import json
import sys
import time
from pathlib import Path

# Force UTF-8 stdout on Windows (default is system codepage, often GBK in CN locale)
if sys.stdout.encoding.lower() != "utf-8":
    sys.stdout.reconfigure(encoding="utf-8")

SCRIPT_DIR = Path(__file__).resolve().parent
REPO_ROOT = SCRIPT_DIR.parent.parent
THREE_DAYS_SEC = 72 * 60 * 60


def main() -> int:
    now = time.time()
    warnings = []

    for handoff in sorted(REPO_ROOT.glob("projects/*/.claude/HANDOFF.md")):
        if not handoff.is_file():
            continue
        project_dir = handoff.parent.parent
        project_name = project_dir.name
        if project_name.startswith("_"):
            continue
        try:
            handoff_mtime = handoff.stat().st_mtime
        except OSError:
            continue

        age_sec = now - handoff_mtime
        age_days = int(age_sec // 86400)

        if age_sec > THREE_DAYS_SEC:
            warnings.append(
                f"[{project_name}] HANDOFF.md 未更新 {age_days} 天（超过 72h 阈值）"
            )

        tracks_dir = project_dir / "tracks"
        if tracks_dir.is_dir():
            newer = []
            for md in tracks_dir.rglob("*.md"):
                try:
                    if md.stat().st_mtime > handoff_mtime:
                        newer.append(md)
                except OSError:
                    pass
            if newer:
                newest = max(newer, key=lambda p: p.stat().st_mtime)
                newest_rel = newest.relative_to(REPO_ROOT).as_posix()
                warnings.append(
                    f"[{project_name}] tracks/ 下有 {len(newer)} 个 md 比 HANDOFF.md 新"
                    f"（最新：{newest_rel}）→ HANDOFF 活跃 thread 盘点可能过期"
                )

    if not warnings:
        return 0

    lines = ["HANDOFF 老化检查（hook 自动提醒）："]
    lines.extend(f"- {w}" for w in warnings)
    lines.append(
        "\n→ 如本 session 会推进 / 修改 thread 状态，请在 session 结束前同步 "
        "HANDOFF §1 活跃 thread 盘点。"
    )

    output = {
        "hookSpecificOutput": {
            "hookEventName": "SessionStart",
            "additionalContext": "\n".join(lines),
        }
    }
    print(json.dumps(output, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    sys.exit(main())
