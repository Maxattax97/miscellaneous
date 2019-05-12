#!/bin/bash

MISC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

echo "Linking from ${MISC_DIR} ..."

link_source() {
    echo "Linking ${MISC_DIR}/${1} -> ${HOME}/${2:-$1} ..."
    ln -sf "${MISC_DIR}/${1}" "${HOME}/${2:-$1}"
}

# Dot files
link_source .ctags
link_source .bashrc
link_source .zshrc
link_source .tmux.conf
link_source .tmuxline.conf
link_source .Xdefaults
link_source .eslintrc.json

# Dot directories
mkdir -p "${HOME}/.config/"

mkdir -p "${HOME}/.ncmpcpp"
link_source "config/ncmpcpp/config" ".ncmpcpp/config"

link_source "config/SpaceVim.d" ".SpaceVim.d"

git clone "https://github.com/tmux-plugins/tpm" "${HOME}/.tmux/plugins/tpm"

# ~/.config/
echo "Backing up ${HOME}/.config ..."
tar -czf "${HOME}/.config.bak.tar.gz" "${HOME}/.config/"
link_source "config/i3/" ".config/"
link_source "config/mpd/" ".config/"
link_source "config/polybar/" ".config/"
link_source "config/psd/" ".config/"
link_source "config/compton/" ".config/"
link_source "config/awesome/" ".config/"
link_source "config/gtk-3.0/" ".config/"
link_source "config/ranger/" ".config/"
link_source "config/rofi/" ".config/"

# Binaries / executables
mkdir -p "${HOME}/bin/"

link_source "bin/ctlpanel"
link_source "bin/gspeak"
link_source "bin/idle-mine"
link_source "bin/reload-kde"
link_source "bin/restart-kde"
link_source "bin/logout-kde"

echo "Environment installation complete"
