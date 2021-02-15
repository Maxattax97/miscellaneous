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

# Configure secured password (not included in this repo) with:
# /secure passphrase a strong password here
# /secure set freenode_password yourFreenodePasswordHere
link_source "config/weechat/" ".weechat"

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
link_source "config/bspwm/" ".config/bspwm"
link_source "config/sxhkd/" ".config/sxhkd"

# Binaries / executables
mkdir -p "${HOME}/bin/"

link_source "bin/ctlpanel"
link_source "bin/gspeak"
link_source "bin/idle-mine"
link_source "bin/reload-kde"
link_source "bin/restart-kde"
link_source "bin/logout-kde"

echo "Environment installation complete"

read -r -p "Would you like to attempt an install of common utilities? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        # TODO: Verify weechat plugins are installed (probably aren't).
        if [[ -x "$(command -v dnf)" ]]; then
            sudo dnf install -y zsh neovim tmux htop git curl ripgrep python3 nodejs xclip weechat newsboat
        elif [[ -x "$(command -v apt)" ]]; then
            sudo apt install -y zsh neovim tmux htop git curl ripgrep python3 nodejs xclip weechat newsboat
        elif [[ -x "$(command -v pacman)" ]]; then
            # Partial upgrades are not supported!
            sudo pacman -Syu zsh neovim tmux htop git curl ripgrep python nodejs xclip weechat newsboat neofetch chezmoi
        fi

        if [[ -x "$(command -v pacman)" ]]; then
            previous_dir="$(pwd)"
            cd "${HOME}" && curl -sfL https://git.io/chezmoi | sh; cd "$previous_dir" || exit
        fi

        if [[ -x "$(command -v pip2)" ]]; then
            pip2 install --user neovim
        fi

        if [[ -x "$(command -v pip3)" ]]; then
            pip3 install --user neovim
        fi

	# TODO: install LTS node via NVM which is installed via ZSH.
        if [[ -x "$(command -v npm)" ]]; then
            npm install -g neovim || sudo npm install -g neovim
        fi

        if [[ -x "$(command -v gem)" ]]; then
            gem install neovim
        fi

        if [[ ! -d "${HOME}/.cache/dein" ]]; then
            mkdir -p "${HOME}/.cache/dein"
            curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | sh -s -- "${HOME}/.cache/dein"
            # curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh /tmp/.dein_installer.sh && sh /tmp/.dein_installer.sh "${HOME}/.cache/dein"
	    # rm -rf /tmp/.dein_installer.sh
        fi

        # Always try to update these.
        git clone --depth 1 https://github.com/cjbassi/gotop /tmp/gotop && /tmp/gotop/scripts/download.sh && mv gotop "${HOME}/bin/" && rm -rf /tmp/gotop

        # TODO: Automatically update the version.
        # TODO: Detect architecture of local system and grab the right binary.
        curl https://github.com/bcicen/ctop/releases/download/v0.7.5/ctop-0.7.5-linux-amd64 -o "${HOME}/bin/ctop" && chmod +x "${HOME}/bin/ctop"

        chsh -s /bin/zsh "${USER}"
        ;;
    *)
        echo "Skipping utility installation"
        ;;
esac

read -r -p "Would you like to attempt an install of workstation utilities? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        if [[ -x "$(command -v dnf)" ]]; then
            sudo dnf install -y nextcloud-client veracrypt
        elif [[ -x "$(command -v apt)" ]]; then
            # TODO: nextcloud, veracrypt, gnome-keyring
            sudo apt install -y
        elif [[ -x "$(command -v pacman)" ]]; then
            sudo pacman -Syu nextcloud-client veracrypt flameshot gnome-keyring
        fi

        if [[ -x "$(command -v yay)" ]]; then
            yay -Syu zathura-git girara-git ytop-bin picom-tryone-git
            sudo pacman -Syu zathura-pdf-mupdf
        fi
        ;;
    *)
        echo "Skipping utility installation"
        ;;
esac

read -r -p "Would you like to setup Git? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        if [[ ! -s "${HOME}/.gitconfig" ]]; then
            printf "[user]\n\tname = Max O'Cull\n\temail = max.ocull@protonmail.com\n" > "${HOME}/.gitconfig"
        fi

        if [[ ! -s "${HOME}/.ssh/id_rsa.pub" ]]; then
            ssh-keygen -t rsa -b 4096 -C "max.ocull@protonmail.com"
            eval "$(ssh-agent -s)"
            ssh-add "${HOME}/.ssh/id_rsa"
        fi

        xclip -sel clip < "${HOME}/.ssh/id_rsa.pub" && echo "Key copied to clipboard"
        cat "${HOME}/.ssh/id_rsa.pub"
        ;;
    *)
        echo "Skipping Git setup"
        ;;
esac

read -r -p "Would you like to setup system permissions? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        # TODO: Check that these are correct groupadd commands.
        sudo groupadd -r docker
        sudo usermod -a -G docker "$USER"

        sudo groupadd -r wireshark
        sudo usermod -a -G wireshark "$USER"

        sudo groupadd -r tty
        sudo usermod -a -G tty "$USER"
        ;;
    *)
        echo "Skipping permission setup"
        ;;
esac

read -r -p "Would you like to install fonts? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        ./scripts/font-install.sh
        ;;
    *)
        echo "Skipping font installation"
        ;;
esac
