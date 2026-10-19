#!/usr/bin/env python3
"""Exclude fast-churning source trees from Spotlight (and optionally Time Machine).

Dropping a `.metadata_never_index` marker in a directory stops Spotlight from
indexing that directory and everything beneath it. Existing index entries are
not purged -- for that, add the path to the Spotlight Privacy list in System
Settings, which deletes them immediately.
"""

from __future__ import annotations

import argparse
import pathlib
import platform
import subprocess
import sys

MARKER = ".metadata_never_index"
DEFAULT_TARGETS = ["~/src", "~/entegrata"]


def exclude_spotlight(path: pathlib.Path) -> str:
    marker = path / MARKER
    if marker.exists():
        return "already excluded"
    marker.touch()
    return "marker created"


def exclude_timemachine(path: pathlib.Path) -> str:
    check = subprocess.run(
        ["tmutil", "isexcluded", str(path)], capture_output=True, text=True
    )
    if check.stdout.startswith("[Excluded]"):
        return "already excluded"
    add = subprocess.run(
        ["tmutil", "addexclusion", str(path)], capture_output=True, text=True
    )
    return "excluded" if add.returncode == 0 else f"failed: {add.stderr.strip()}"


def indexed_count(path: pathlib.Path) -> str:
    """Stale entries still in the Spotlight index for this path.

    Matching on kMDItemFSName returns 0 under -onlyin even for indexed trees;
    kMDItemContentType is the attribute that actually reports them.
    """
    result = subprocess.run(
        ["mdfind", "-count", "-onlyin", str(path), "kMDItemContentType=='*'"],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        return "?"
    return result.stdout.strip()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("targets", nargs="*", default=DEFAULT_TARGETS)
    parser.add_argument(
        "--time-machine", action="store_true", help="also exclude from Time Machine"
    )
    args = parser.parse_args()

    if platform.system() != "Darwin":
        print("macOS only.", file=sys.stderr)
        return 1

    failed = False
    for raw in args.targets:
        path = pathlib.Path(raw).expanduser().resolve()
        if not path.is_dir():
            print(f"{path}: not a directory, skipping", file=sys.stderr)
            failed = True
            continue

        print(f"{path}")
        print(f"  spotlight:    {exclude_spotlight(path)}")
        if args.time_machine:
            print(f"  time machine: {exclude_timemachine(path)}")
        print(f"  stale index:  {indexed_count(path)} entries")

    print(
        "\nTo purge stale entries, add these paths under"
        "\nSystem Settings > Siri & Spotlight > Spotlight Privacy."
    )
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
