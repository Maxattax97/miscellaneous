#!/bin/bash

MISC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

echo "Linking from ${MISC_DIR} ..."

link_source() {
    src="${MISC_DIR}/${1}"
    dest="${HOME}/${2:-$1}"
    if [ -h "$dest" ]; then
        echo "Skipping $dest because it is already linked ..."
    elif [ -f "$dest" ]; then
        echo "Skipping $dest because a file exists there ..."
    elif [ -d "$dest" ]; then
        echo "Skipping $dest because a directory exists there ..."
    else
        echo "Linking $src -> $dest ..."
        ln -sf "$src" "$dest"
    fi
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

if [ ! -d "${HOME}/.tmux/plugins/tpm" ]; then
    git clone "https://github.com/tmux-plugins/tpm" "${HOME}/.tmux/plugins/tpm"
fi

# ~/.config/
#echo "Backing up ${HOME}/.config ..."
#tar -czf "${HOME}/.config.bak.tar.gz" "${HOME}/.config/"
link_source "config/i3/" ".config/i3"
link_source "config/mpd/" ".config/mpd"
link_source "config/polybar/" ".config/polybar"
link_source "config/psd/" ".config/psd"
link_source "config/compton/" ".config/compton"
link_source "config/awesome/" ".config/awesome"
link_source "config/gtk-3.0/" ".config/gtk-3.0"
link_source "config/ranger/" ".config/ranger"
link_source "config/rofi/" ".config/rofi"
link_source "config/nvim/" ".config/nvim"
link_source "config/newsboat/" ".config/newsboat"
link_source "config/zathura/" ".config/zathura"

# Binaries / executables
mkdir -p "${HOME}/bin/"

link_source "bin/ctlpanel"
link_source "bin/gspeak"
link_source "bin/idle-mine"
link_source "bin/reload-kde"
link_source "bin/restart-kde"
link_source "bin/logout-kde"

echo "Environment installation complete"

read -r -p "Would you like attempt an install of common utilities? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        if [[ -x "(command -v dnf)" ]]; then
            dnf install -y neovim tmux htop git curl
        fi

	# TODO: install LTS node via NVM which is installed via ZSH.

        if [[ ! -d "${HOME}/.cache/dein" ]]; then
            mkdir -p "${HOME}/.cache/dein"
            curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | sh -s -- "${HOME}/.cache/dein"
            # curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh /tmp/.dein_installer.sh && sh /tmp/.dein_installer.sh "${HOME}/.cache/dein"
	    # rm -rf /tmp/.dein_installer.sh
        fi

        if [[ ! -s "${HOME}/bin/gotop" ]]; then
            git clone --depth 1 https://github.com/cjbassi/gotop /tmp/gotop && /tmp/gotop/scripts/download.sh && mv gotop "${HOME}/bin/"
            rm -rf /tmp/gotop
        fi
        ;;
    *)
        echo "Skipping utility installation"
        ;;
esac
