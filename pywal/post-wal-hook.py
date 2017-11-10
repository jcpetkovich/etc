#!/usr/bin/env python
import os
import pywal
import subprocess

wallpaper = pywal.wallpaper.get()

colours = pywal.colors.get(wallpaper)

homedir = os.path.expanduser("~")

template = os.path.join(
    homedir,
    "etc",
    "pywal",
    "stresources"
)

with open(template, "r") as f:
    template = f.read()

template = template.format(
    foreground = colours["special"]["foreground"],
    background = colours["special"]["background"],
    cursor = colours["special"]["cursor"]
)

stresources = os.path.join(homedir, ".cache/wal/stresources")

with open(stresources, "w") as f:
    f.write(template)

pywal.reload.xrdb(stresources)

subprocess.check_call(os.path.join(homedir, ".config", "bspwm", "theme"))
