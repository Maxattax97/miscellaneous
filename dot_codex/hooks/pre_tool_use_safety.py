#!/usr/bin/env python3
"""Block shell commands that violate repository-managed Codex safety policy."""

import json
import re
import sys

GIT_COMMIT = re.compile(
    r"(?<![A-Za-z0-9_./-])(?:/usr/bin/|/bin/)?git"
    r"(?:\s+(?:-[cC]\s+\S+|--\S+))*\s+commit(?=$|[\s;&|()<>])"
)


def deny(reason: str) -> None:
    json.dump(
        {
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": "deny",
                "permissionDecisionReason": reason,
            }
        },
        sys.stdout,
    )
    sys.stdout.write("\n")


def main() -> int:
    try:
        event = json.load(sys.stdin)
    except (json.JSONDecodeError, UnicodeDecodeError):
        # A malformed hook event is a configuration/runtime problem, not evidence
        # that the pending command violates this policy.
        return 0

    tool_input = event.get("tool_input") or {}
    command = tool_input.get("command") if isinstance(tool_input, dict) else None
    if not isinstance(command, str):
        return 0

    if GIT_COMMIT.search(command):
        deny("Agents must leave git commits to the user.")
        return 0
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
