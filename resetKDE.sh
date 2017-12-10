#!/bin/bash
echo "Reseting in 3 seconds... Set compositor to OpenGL 3.0"
sleep 3s
export __GL_YIELD="USLEEP"
kwin_x11 --replace &
