#!/usr/bin/env bash

path="/usr/lib64/libreoffice/share/registry/main.xcd"

if [ -f $path ]; then
    sed -i 's/Liberation Sans/FreeSans/g' $path
    sed -i 's/Liberation Serif/Hack Nerd Font Mono/g' $path
    sed -i 's/Liberation Mono/Hack Nerd Font Mono/g' $path
fi
