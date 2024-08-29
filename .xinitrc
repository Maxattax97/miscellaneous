#!/bin/sh

source "${HOME}/.xprofile"

if lspci | grep -iq nvidia; then
    echo "NVIDIA card detected"
    xrandr --setprovideroutputsource modesetting NVIDIA-0
    xrandr --auto
else
    echo "No NVIDIA card detected"
fi

session=${1:-bspwm}
case $session in
    bspwm)
        export XDG_CURRENT_DESKTOP="bspwm"
        exec bspwm
        ;;
    i3|i3wm)
        export XDG_CURRENT_DESKTOP="i3wm"
        exec i3
        ;;
    kde)
        exec startplasma-x11
        ;;
    xfce|xfce4)
        # Do I need to export it for XFCE?
        exec startxfce4
        ;;
    # No known session, try to run it as command
    *)
        exec $1
        ;;
esac
