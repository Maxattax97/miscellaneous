#!/usr/bin/env python
"""Run the configured game executable through a local Proton installation."""

import os
import subprocess
import sys


def main() -> int:
    """Run Proton with the configured executable and forwarded arguments."""
    app_id = "24980"
    home = os.environ["HOME"]
    environment = os.environ.copy()
    environment["STEAM_COMPAT_DATA_PATH"] = (
        f"/extended/ExtendedLibrary/steamapps/compatdata/{app_id}"
    )
    proton = f"{home}/.steam/steam/steamapps/common/Proton 3.7/proton"
    executable = (
        f"{home}/Downloads/ALOT for ME2 9.0/"
        "A Lot Of Textures (ALOT)/ALOTInstaller.exe"
    )
    completed = subprocess.run(  # noqa: S603
        [proton, "run", executable, *sys.argv[1:]],
        env=environment,
        check=False,
    )
    return completed.returncode


if __name__ == "__main__":
    raise SystemExit(main())
