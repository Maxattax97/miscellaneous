#!/usr/bin/env python3
import sys


cfg_file = None
ini_string = "[Game Files]\nGameFile0=Morrowind.esm\nGameFile1=Tribunal.esm\nGameFile2=Bloodmoon.esm\n"

try:
    cfg_file = sys.argv[1]
except IndexError:
    sys.stderr.write("NEED CFG FILE\n")
    sys.exit(1)

with open(cfg_file, "r") as cfg:
    lines = cfg.readlines()

content_lines = []

for l in lines:
    if l.startswith("content="):
        content_lines.append(l)

count = 3
for c in content_lines:
    if (
        "Morrowind.esm" not in c
        and "Tribunal.esm" not in c
        and "Bloodmoon.esm" not in c
    ):
        ini_string += "GameFile{}=".format(count) + c.split("=")[1].strip() + "\n"
        count += 1

print(ini_string)
