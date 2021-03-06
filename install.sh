#!/usr/bin/env bash

MISC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

echo "Linking from ${MISC_DIR} ..."

link_source() {
    src="${MISC_DIR}/${1}"
    overwrite="${2:-0}"
    dest="${HOME}/${3:-$1}"

    if [ -h "$dest" ]; then
        echo "Skipping $dest because it is already linked ..."
    elif [ -f "$dest" ]; then
        if [ "$overwrite" -eq 1 ]; then
            rm -f "$dest"
            echo "Overwriting file and linking $src -> $dest ..."
            ln -sf "$src" "$dest"
        else
            echo "Skipping $dest because a file exists there ..."
        fi
    elif [ -d "$dest" ]; then
        if [ "$overwrite" -eq 1 ]; then
            rm -rf "$dest"
            echo "Overwriting directory and linking $src -> $dest ..."
            ln -sf "$src" "$dest"
        else
            echo "Skipping $dest because a directory exists there ..."
        fi
    else
        echo "Linking $src -> $dest ..."
        ln -sf "$src" "$dest"
    fi
}

# Dot files
link_source .ctags 1
link_source .bashrc 1
link_source .zshrc 1
link_source .tmux.conf 1
link_source .tmuxline.conf 1
link_source .Xdefaults 1
link_source .eslintrc.json 0

# Dot directories
mkdir -p "${HOME}/.config/"

mkdir -p "${HOME}/.ncmpcpp"
link_source "config/ncmpcpp/config" 1 ".ncmpcpp/config"

link_source "config/SpaceVim.d" 1 ".SpaceVim.d"

# Configure secured password (not included in this repo) with:
# /secure passphrase a strong password here
# /secure set freenode_password yourFreenodePasswordHere
link_source "config/weechat/" 1 ".weechat"

if [ ! -d "${HOME}/.tmux/plugins/tpm" ]; then
    git clone "https://github.com/tmux-plugins/tpm" "${HOME}/.tmux/plugins/tpm"
fi

# ~/.config/
#echo "Backing up ${HOME}/.config ..."
#tar -czf "${HOME}/.config.bak.tar.gz" "${HOME}/.config/"
link_source "config/i3/" 1 ".config/i3"
link_source "config/mpd/" 1 ".config/mpd"
link_source "config/polybar/" 1 ".config/polybar"
link_source "config/psd/" 1 ".config/psd"
link_source "config/compton/" 1 ".config/compton"
link_source "config/awesome/" 1 ".config/awesome"
link_source "config/gtk-3.0/" 0 ".config/gtk-3.0"
link_source "config/ranger/" 1 ".config/ranger"
link_source "config/rofi/" 1 ".config/rofi"
link_source "config/nvim/" 1 ".config/nvim"
link_source "config/newsboat/" 1 ".config/newsboat"
link_source "config/zathura/" 1 ".config/zathura"
link_source "config/bspwm/" 1 ".config/bspwm"
link_source "config/sxhkd/" 1 ".config/sxhkd"
link_source "config/dunst/" 1 ".config/dunst"
link_source "config/fontconfig/" 0 ".config/fontconfig"
link_source "config/pcmanfm/" 1 ".config/pcmanfm"
link_source "config/xmrig.json" 1 ".config/xmrig.json"

# Binaries / executables
mkdir -p "${HOME}/bin/"

link_source "bin/ctlpanel" 1
link_source "bin/gspeak" 1
link_source "bin/idle-mine" 1
link_source "bin/reload-kde" 1
link_source "bin/restart-kde" 1
link_source "bin/logout-kde" 1

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
            sudo pacman -Syu zsh neovim tmux htop git curl ripgrep python nodejs xclip weechat newsboat neofetch chezmoi ctop --needed
        fi

        if [[ ! -x "$(command -v chezmoi)" ]]; then
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

        if [[ ! -x "$(command -v gotop)" ]]; then
            if [[ -x "$(command -v yay)" ]]; then
                yay -Syu gotop-bin
            else
                # Always try to update these.
                git clone --depth 1 https://github.com/cjbassi/gotop /tmp/gotop && /tmp/gotop/scripts/download.sh && mv gotop "${HOME}/bin/" && rm -rf /tmp/gotop
            fi
        fi

		if [[ ! -x "$(command -v navi)" ]]; then
			if [[ -x "$(command -v yay)" ]]; then
				yay -Syu navi
			else
				bash <(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)
			fi
		fi

        if [[ ! -x "$(command -v ctop)" ]]; then
            # TODO: Automatically update the version.
            # TODO: Detect architecture of local system and grab the right binary.
            curl https://github.com/bcicen/ctop/releases/download/v0.7.5/ctop-0.7.5-linux-amd64 -o "${HOME}/bin/ctop" && chmod +x "${HOME}/bin/ctop"
        fi

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
            sudo dnf install -y nextcloud-client veracrypt firefox
        elif [[ -x "$(command -v apt)" ]]; then
            # TODO: nextcloud, veracrypt, gnome-keyring
            sudo apt install -y
        elif [[ -x "$(command -v pacman)" ]]; then
            sudo pacman -Syu nextcloud-client veracrypt flameshot gnome-keyring firefox p7zip unrar --needed
        fi

        if [[ -x "$(command -v yay)" ]]; then
            yay -Syu zathura-git girara-git
            sudo pacman -Syu zathura-pdf-mupdf firefox --needed
        fi

        xdg-settings set default-web-browser firefox.desktop
        ;;
    *)
        echo "Skipping utility installation"
        ;;
esac

if [[ -x "$(command -v pacman)" ]]; then
    read -r -p "Would you like to attempt an install of bspwm (Arch Linux only)? [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY])
            # TODO: install custom st.
            sudo pacman -Syu bspwm sxhkd nitrogen nm-connection-editor network-manager-applet rofi papirus-icon-theme pcmanfm-gtk3 xarchiver dunst lxappearance sxiv --needed

            if [[ -x "$(command -v yay)" ]]; then
                yay -Syu polybar picom-git ly --needed
            fi
            ;;
        *)
            echo "Skipping bspwm installation"
            ;;
    esac
fi

if [[ -x "$(command -v pacman)" ]]; then
    read -r -p "Would you like to attempt an install of XMRig suite? [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY])
			if [[ -x "$(command -v dnf)" ]]; then
				sudo dnf install -y git make cmake gcc gcc-c++ libstdc++-static libuv-static hwloc-devel openssl-devel tor nyx msr-tools
			elif [[ -x "$(command -v pacman)" ]]; then
				sudo pacman -Syu tor nyx msr-tools --needed
			fi

            if [[ -x "$(command -v yay)" ]]; then
                yay -Syu xmrig-donateless --needed
            fi

cat >> /etc/tor/torrc<< EOF
ControlPort 9051
CookieAuthentication 1
CookieAuthFile /var/lib/tor/control_auth_cookie
CookieAuthFileGroupReadable 1
DataDirectoryGroupReadable 1
EOF

			if [[ -x "$(command -v dnf)" ]]; then
				sudo usermod -a -G toranon "$USER"
			elif [[ -x "$(command -v pacman)" ]]; then
				sudo usermod -a -G tor "$USER"
			fi
            echo "You will want to refresh your groups before running Nyx: newgrp tor"
            echo "To start Tor: sudo systemctl restart tor"
            ;;
        *)
            echo "Skipping xmrig suite installation"
            ;;
    esac
fi

read -r -p "Would you like to setup Git? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        if [[ ! -s "${HOME}/.gitconfig" ]]; then
            printf "[user]\n\tname = Max O'Cull\n\temail = max.ocull@protonmail.com\n" > "${HOME}/.gitconfig"
            printf "[alias]\n\tlogline = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit\n" >> "${HOME}/.gitconfig"
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
