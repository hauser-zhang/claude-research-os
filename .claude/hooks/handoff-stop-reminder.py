#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Stop hook: remind to update HANDOFF.md if tracks/ moved this session.

Uses the same two heuristics as handoff-staleness-check.py but emits a
systemMessage (shown to user in UI) instead of additionalContext:
  1. tracks/**/*.md has files newer than HANDOFF.md
  2. HANDOFF.md mtime > 72h

Advisory only — exit 0 without continue:false, doesn't block anything.
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
    msg_parts = []

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
        reasons = []

        tracks_dir = project_dir / "tracks"
        if tracks_dir.is_dir():
            newer_count = sum(
                1
                for md in tracks_dir.rglob("*.md")
                if md.is_file() and md.stat().st_mtime > handoff_mtime
            )
            if newer_count > 0:
                reasons.append(f"{newer_count} 个 thread md 比 HANDOFF 新")

        if age_sec > THREE_DAYS_SEC:
            reasons.append(f"HANDOFF 已 {age_days} 天未更新")

        if reasons:
            msg_parts.append(f"[{project_name}] " + "；".join(reasons))

    if not msg_parts:
        return 0

    message = (
        "Session 结束提醒：检查 HANDOFF §1 活跃 thread 盘点是否需要同步 —— "
        + "；".join(msg_parts)
    )
    print(json.dumps({"systemMessage": message}, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    sys.exit(main())
