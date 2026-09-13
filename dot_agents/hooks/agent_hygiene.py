#!/usr/bin/env python3
"""Host-neutral agent hygiene hook. Reads one JSON event and writes one decision."""

from __future__ import annotations

import fcntl
import hashlib
import json
import os
import shlex
import sys
import tempfile
from pathlib import Path


def disabled(name: str) -> bool:
    values = ("AGENT_HYGIENE_DISABLED", f"AGENT_HYGIENE_{name.upper()}_DISABLED")
    return any(os.getenv(key, "").lower() in {"1", "true", "yes"} for key in values)


def cache_root() -> Path:
    return Path(os.getenv("XDG_CACHE_HOME", Path.home() / ".cache")) / "agent-hygiene"


def state_path(event: dict) -> Path:
    host = str(event.get("host") or "unknown")
    session = str(event.get("session_id") or "unknown")
    key = hashlib.sha256(f"{host}\0{session}".encode()).hexdigest()
    return cache_root() / f"{key}.json"


def load(path: Path) -> dict:
    try:
        value = json.loads(path.read_text())
        return value if isinstance(value, dict) else {}
    except (OSError, ValueError):
        return {}


def save(path: Path, state: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fd, temporary = tempfile.mkstemp(prefix=path.name, dir=path.parent)
    try:
        with os.fdopen(fd, "w") as handle:
            json.dump(state, handle, sort_keys=True)
            handle.flush()
            os.fsync(handle.fileno())
        os.replace(temporary, path)
    finally:
        try:
            os.unlink(temporary)
        except FileNotFoundError:
            pass


def normalize(raw: object) -> dict:
    if not isinstance(raw, dict):
        return {}
    return {
        "host": raw.get("host"),
        "event": raw.get("event"),
        "session_id": raw.get("session_id"),
        "cwd": raw.get("cwd"),
        "tool_name": raw.get("tool_name"),
        "tool_input": (
            raw.get("tool_input") if isinstance(raw.get("tool_input"), dict) else {}
        ),
        "files": raw.get("files") if isinstance(raw.get("files"), list) else [],
        "delegated": bool(raw.get("delegated")),
    }


def file_fingerprint(event: dict) -> tuple[str, bool, bool] | None:
    data = event["tool_input"]
    path_value = data.get("path") or data.get("file_path")
    if not path_value and isinstance(data.get("command"), str):
        try:
            words = shlex.split(data["command"])
        except ValueError:
            words = []
        # Recognize only the unambiguous full-file form. Shell pipelines,
        # substitutions, and ranged readers remain advisory rather than denied.
        if len(words) == 2 and words[0] == "cat":
            path_value = words[1]
    if not isinstance(path_value, str):
        return None
    ranged = any(
        data.get(key) not in (None, "", 0)
        for key in ("offset", "line", "start", "limit", "end")
    )
    path = (Path(event.get("cwd") or ".") / path_value).resolve()
    try:
        stat = path.stat()
        fingerprint = f"{path}:{stat.st_mtime_ns}:{stat.st_size}"
    except OSError:
        fingerprint = str(path)
    return fingerprint, ranged, path.exists()


def _evaluate_unlocked(event: dict) -> dict:
    if disabled("all"):
        return {"decision": "allow"}
    path = state_path(event)
    state = load(path)
    counts = state.setdefault("counts", {})
    kind = str(event.get("event") or "unknown")
    counts[kind] = int(counts.get(kind, 0)) + 1
    if event.get("delegated"):
        state["delegations"] = int(state.get("delegations", 0)) + 1

    result = {"decision": "allow"}
    if kind == "pre_tool" and not disabled("read_guard"):
        tool = str(event.get("tool_name") or "").lower()
        broad = tool in {"read", "cat", "grep", "search", "glob", "bash"}
        state["broad_reads"] = int(state.get("broad_reads", 0)) + int(broad)
        details = file_fingerprint(event)
        if details:
            fingerprint, ranged, exists = details
            seen = state.setdefault("full_reads", {})
            if exists and not ranged and fingerprint in seen:
                result = {
                    "decision": "deny",
                    "message": "This unchanged file was already read in full; use a ranged read or inspect its diff.",
                }
            elif exists and not ranged:
                seen[fingerprint] = True
        if result["decision"] == "allow" and state["broad_reads"] in {4, 8}:
            result["context"] = (
                "Several broad reads/searches have occurred. Narrow the search or delegate an independent investigation when available."
            )
    elif kind in {"pre_compact", "session_end"} and not disabled("summary"):
        result["context"] = (
            f"Session hygiene: {sum(counts.values())} stable events, "
            f"{state.get('delegations', 0)} delegations, {counts.get('pre_compact', 0)} compactions."
        )
    save(path, state)
    return result


def evaluate(event: dict) -> dict:
    if disabled("all"):
        return {"decision": "allow"}
    path = state_path(event)
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.with_suffix(".lock").open("a+") as lock:
        fcntl.flock(lock.fileno(), fcntl.LOCK_EX)
        return _evaluate_unlocked(event)


def main() -> int:
    try:
        raw = json.load(sys.stdin)
        print(json.dumps(evaluate(normalize(raw))))
        return 0
    except (ValueError, TypeError) as exc:
        print(
            json.dumps(
                {
                    "decision": "allow",
                    "message": f"agent-hygiene ignored malformed input: {exc}",
                }
            )
        )
        return 0


if __name__ == "__main__":
    raise SystemExit(main())
