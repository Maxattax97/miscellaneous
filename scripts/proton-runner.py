#!/usr/bin/env python

import os
import sys

app_id = "24980"
app_name = ""

home = os.environ["HOME"]
os.environ["STEAM_COMPAT_DATA_PATH"] = "/extended/ExtendedLibrary/steamapps/compatdata/" + app_id

run = "run"
# exe = "\"" + home + "/.local/share/Steam/steamapps/common/Star Wars Empire at War/corruption/swfoc.exe\""
exe = "\"" + home + "/Downloads/ALOT for ME2 9.0/A Lot Of Textures (ALOT)/ALOTInstaller.exe\""

cmd = "\"" + home + "/.steam/steam/steamapps/common/Proton 3.7/proton\" " + run + " " + exe

for arg in sys.argv[1:]:
    cmd += " " + arg

os.system(cmd)
