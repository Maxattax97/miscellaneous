#!/usr/bin/env python3
"""Convert an OpenMW configuration's content entries to Morrowind INI data."""

import sys


def main() -> int:
    """Print OpenMW content entries in Morrowind INI format."""
    try:
        config_path = sys.argv[1]
    except IndexError:
        sys.stderr.write("NEED CFG FILE\n")
        return 1

    with open(config_path, "r", encoding="utf-8") as config_file:
        content_lines = [line for line in config_file if line.startswith("content=")]

    ini_lines = [
        "[Game Files]",
        "GameFile0=Morrowind.esm",
        "GameFile1=Tribunal.esm",
        "GameFile2=Bloodmoon.esm",
    ]
    base_files = ("Morrowind.esm", "Tribunal.esm", "Bloodmoon.esm")
    for content_line in content_lines:
        if not any(base_file in content_line for base_file in base_files):
            filename = content_line.split("=", 1)[1].strip()
            ini_lines.append(f"GameFile{len(ini_lines) - 1}={filename}")

    print("\n".join(ini_lines))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
