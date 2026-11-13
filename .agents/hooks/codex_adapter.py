#!/usr/bin/env python3
"""Translate the documented Codex hook contract to the normalized hook API."""

import json
import subprocess
import sys
from pathlib import Path

raw = json.load(sys.stdin)
if not isinstance(raw, dict):
    raw = {}
hook_event = str(raw.get("hook_event_name", ""))  # pylint: disable=invalid-name
event_names = {
    "PreToolUse": "pre_tool",
    "PreCompact": "pre_compact",
    "SessionEnd": "session_end",
}
normalized = {
    "host": "codex",
    "event": event_names.get(hook_event, hook_event.lower()),
    "session_id": raw.get("session_id"),
    "cwd": raw.get("cwd"),
    "tool_name": raw.get("tool_name"),
    "tool_input": raw.get("tool_input", {}),
}
engine = Path(__file__).with_name("agent_hygiene.py")
run = subprocess.run(
    [sys.executable, str(engine)],
    input=json.dumps(normalized),
    text=True,
    capture_output=True,
    check=False,
)
decision = json.loads(run.stdout or "{}")
output = {}
specific = {"hookEventName": raw.get("hook_event_name")}
if decision.get("decision") == "deny":
    specific.update(
        permissionDecision="deny",
        permissionDecisionReason=decision.get("message", "Denied by agent hygiene"),
    )
if decision.get("context"):
    specific["additionalContext"] = decision["context"]
if len(specific) > 1:
    output["hookSpecificOutput"] = specific
if decision.get("message") and decision.get("decision") != "deny":
    output["systemMessage"] = decision["message"]
print(json.dumps(output))
