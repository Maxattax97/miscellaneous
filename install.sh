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
link_source ".gtkrc-2.0" 0
link_source .xinitrc 0

# Dot directories
mkdir -p "${HOME}/.config/"

mkdir -p "${HOME}/.ncmpcpp"
link_source "config/ncmpcpp/config" 1 ".ncmpcpp/config"

mkdir -p "${HOME}/.gnupg"
link_source "config/gnupg/gpg.conf" 0 ".gnupg/gpg.conf"

mkdir -p "${HOME}/.ssh"
link_source "config/ssh/config" 0 ".ssh/config"

mkdir -p "${HOME}/.SpaceVim.d"
link_source "config/SpaceVim.d" 1 ".SpaceVim.d"

# Configure secured password (not included in this repo) with:
# /secure passphrase a strong password here
# /secure set freenode_password yourFreenodePasswordHere
link_source "config/weechat/" 1 ".weechat"

if [ ! -d "${HOME}/.tmux/plugins/tpm" ]; then
    git clone "https://github.com/tmux-plugins/tpm" "${HOME}/.tmux/plugins/tpm"
fi

# ~/.config/
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
link_source "config/redrum.ini" 1 ".config/redrum.ini"
link_source "config/mimeapps.list" 1 ".config/mimeapps.list"
link_source "config/mimeapps.list" 1 ".local/share/applications/mimeapps.list"
link_source "config/btop/" 1 ".config/btop"
link_source "config/Kvantum/" 1 ".config/Kvantum"

mkdir -p "${HOME}/.config/variety"
link_source "config/variety/variety.conf" 1 ".config/variety/variety.conf"

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
            sudo dnf install -y \
                btop \
                curl \
                git \
                keychain \
                neofetch \
                neovim \
                newsboat \
                nodejs \
                python3 \
                ripgrep \
                tmux \
                util-linux-user \
                weechat \
                xclip \
                zsh
        elif [[ -x "$(command -v apt)" ]]; then
            sudo apt install -y \
                btop \
                curl \
                git \
                keychain \
                neofetch \
                neovim \
                newsboat \
                nodejs \
                python3 \
                ripgrep \
                tmux \
                weechat \
                xclip \
                zsh
        elif [[ -x "$(command -v pacman)" ]]; then
            sudo pacman -Syu --needed \
                btop \
                chezmoi \
                curl \
                git \
                keychain \
                neofetch \
                neovim \
                newsboat \
                nodejs \
                python \
                ripgrep \
                tmux \
                weechat \
                xclip \
                zsh
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
        else
            echo "You need to install pip3"
        fi

        # TODO: install LTS node via NVM which is installed via ZSH.
        if [[ -x "$(command -v npm)" ]]; then
            npm install -g neovim || sudo npm install -g neovim
        else
            echo "You need to install npm"
        fi

        if [[ -x "$(command -v gem)" ]]; then
            gem install neovim
        else
            echo "You need to install gem"
        fi

        if [[ ! -d "${HOME}/.cache/dein" ]]; then
            mkdir -p "${HOME}/.cache/dein"
            curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | sh -s -- "${HOME}/.cache/dein"
            # curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh /tmp/.dein_installer.sh && sh /tmp/.dein_installer.sh "${HOME}/.cache/dein"
            # rm -rf /tmp/.dein_installer.sh
        fi

        #if [[ ! -x "$(command -v gotop)" ]]; then
            #if [[ -x "$(command -v yay)" ]]; then
                #yay -S gotop-bin --needed
            #else
                ## Always try to update these.
                #git clone --depth 1 https://github.com/cjbassi/gotop /tmp/gotop && /tmp/gotop/scripts/download.sh && mv gotop "${HOME}/bin/" && rm -rf /tmp/gotop
            #fi
        #fi

        #if [[ ! -x "$(command -v navi)" ]]; then
                #if [[ -x "$(command -v yay)" ]]; then
                        #yay -S navi --needed
                #else
                        #bash <(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)
                #fi
        #fi

        #if [[ ! -x "$(command -v ctop)" ]]; then
            # TODO: Automatically update the version.
            # TODO: Detect architecture of local system and grab the right binary.
            #curl https://github.com/bcicen/ctop/releases/download/v0.7.7/ctop-0.7.7-linux-amd64 -o "${HOME}/bin/ctop" && chmod +x "${HOME}/bin/ctop"
        #fi

        #if [[ ! -x "$(command -v lazydocker)" ]]; then
            #if [[ -x "$(command -v yay)" ]]; then
                #yay -S lazydocker --needed
            #else
                #curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | DIR="${HOME}/bin/" bash
            #fi
        #fi

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
            sudo dnf install \
                brave \
                firefox \
                flameshot \
                gparted \
                inkscape \
                libreoffice \
                mpv \
                nextcloud-client \
                p7zip \
                qalculate-gtk \
                veracrypt \
                zathura \
                zathura-pdf-mupdf \
                -y
        elif [[ -x "$(command -v apt)" ]]; then
            sudo apt install \
                flameshot \
                gparted \
                inkscape \
                libreoffice \
                mpv \
                nextcloud-desktop \
                p7zip-full \
                qalculate-gtk \
                unrar \
                veracrypt \
                zathura \
                -y

            # TODO: Add ppa for veracrypt on Ubuntu
            # TODO: Add ppa for Brave on Ubuntu
        elif [[ -x "$(command -v pacman)" ]]; then
            sudo pacman -Syu \
                flameshot \
                gnome-keyring \
                inkscape \
                libreoffice-fresh \
                mpv \
                nextcloud-client \
                p7zip \
                qalculate-gtk \
                unrar \
                zathura \
                zathura-pdf-mupdf \
                girara \
                veracrypt \
                --needed
            if [[ -x "$(command -v yay)" ]]; then
                    yay -S \
                        all-repository-fonts \
                        brave-bin \
                        yt-dlp \
                        --needed
            fi

            if [[ -x "$(command -v pip3)" ]]; then
                    pip3 install --user \
                        shell-gpt
            fi
        fi

        xdg-settings set default-web-browser brave.desktop
        ;;
    *)
        echo "Skipping utility installation"
        ;;
esac

read -r -p "Would you like to attempt an install of bspwm? [y/N] " response
case "$response" in
        [yY][eE][sS]|[yY])
                # TODO: install custom st.
                if [[ -x "$(command -v dnf)" ]]; then
                        # TODO: Fill the rest in.
                        sudo dnf install \
                            bspwm \
                            dunst \
                            lxappearance \
                            materia-gtk-theme \
                            materia-kde \
                            nitrogen \
                            papirus-icon-theme \
                            pcmanfm \
                            qt6ct \
                            rofi \
                            sxhkd \
                            sxiv \
                            variety \
                            yad \
                            xarchiver \
                            -y
                elif [[ -x "$(command -v apt)" ]]; then
                        # NetworkManager pre-installed.
                        sudo apt install \
                            bspwm \
                            dunst \
                            lxappearance \
                            materia-gtk-theme \
                            materia-kde \
                            murrine-themes \
                            nitrogen \
                            papirus-icon-theme \
                            pcmanfm \
                            qt6ct \
                            rofi \
                            sxhkd \
                            sxiv \
                            variety \
                            xarchiver \
                            yad \
                            -y

                        echo "You will need to build polybar from source: https://github.com/polybar/polybar/wiki/Compiling"
                        echo "python-xcbgen may need to be changed to python3-xcbgen"
                        sudo apt install -y build-essential git cmake cmake-data pkg-config python3-sphinx python3-packaging libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev i3-wm libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev

                        echo "You will need to build picom from source: https://github.com/yshui/picom#build"
                        sudo apt install -y libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev
                elif [[ -x "$(command -v pacman)" ]]; then
                        sudo pacman -Syu \
                            bspwm \
                            dunst \
                            gtk-engine-murrine \
                            kvantum-theme-materia \
                            lxappearance \
                            materia-gtk-theme \
                            materia-kde \
                            network-manager-applet \
                            nitrogen \
                            nm-connection-editor \
                            papirus-icon-theme \
                            pcmanfm-gtk3 \
                            picom \
                            polybar \
                            qt6ct \
                            rofi \
                            sxhkd \
                            sxiv \
                            variety \
                            xarchiver \
                            yad \
                            --needed

                        if [[ -x "$(command -v yay)" ]]; then
                                yay -S \
                                    ly \
                                    --needed
                        fi
                fi

                #if [[ -x "$(command -v pip3)" ]]; then
                        #pip3 install --user \
                #fi

                # copy service files
                mkdir -p ~/.config/systemd/user/
                #cp -u services/redrum.service ~/.config/systemd/user/
                #cp -u services/redrum.timer ~/.config/systemd/user/

                # enable and start systemd timer
                #systemctl --user enable redrum.timer
                #systemctl --user start redrum.timer

                # the service can be triggered manually as well
                #systemctl --user start redrum
                ;;
        *)
                echo "Skipping bspwm installation"
                ;;
esac

if [[ -x "$(command -v pacman)" ]]; then
    read -r -p "Would you like to attempt an install of XMRig suite? [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY])
                        if [[ -x "$(command -v dnf)" ]]; then
                                sudo dnf install -y \
                                    cmake \
                                    gcc \
                                    gcc-c++ \
                                    git \
                                    hwloc-devel \
                                    libstdc++-static \
                                    libuv-static \
                                    make \
                                    msr-tools \
                                    nyx \
                                    openssl-devel \
                                    tor
                        elif [[ -x "$(command -v pacman)" ]]; then
                                sudo pacman -Syu --needed \
                                    msr-tools \
                                    nyx \
                                    tor

                                if [[ -x "$(command -v yay)" ]]; then
                                        yay -S --needed \
                                            xmrig-donateless
                                fi
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
            printf "[alias]\n\tlogline = log --graph --pretty=format:'" >> "${HOME}/.gitconfig"
            echo -n '%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' >> "${HOME}/.gitconfig"
            printf "' --abbrev-commit\n" >> "${HOME}/.gitconfig"
        fi

        git config --global diff.tool nvimdiff
        git config --global diff.algorithm histogram
        git config --global merge.tool nvimdiff
        git config --global --add difftool.prompt false

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

read -r -p "Would you like to copy install configurations with root? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        sudo rm -f "/etc/chrony.conf"
        sudo cp -f "${MISC_DIR}/config/chrony.conf" "/etc/chrony.conf"

        sudo rm -f "/etc/xdg/reflector/reflector.conf"
        sudo cp -f "${MISC_DIR}/config/xdg/reflector/reflector.conf" "/etc/xdg/reflector/reflector.conf"

        sudo rm -f "/etc/systemd/zram-generator.conf"
        sudo cp -f "${MISC_DIR}/config/systemd/zram-generator.conf" "/etc/systemd/zram-generator.conf"

        sudo rm -f "/etc/pacman.conf"
        sudo cp -f "${MISC_DIR}/config/pacman.conf" "/etc/pacman.conf"

        sudo mkdir -p "/etc/pacman.d/hooks/"
        sudo rm -f "/etc/pacman.d/hooks/nvidia.hook"
        sudo cp -f "${MISC_DIR}/config/pacman.d/hooks/nvidia.hook" "/etc/pacman.d/hooks/nvidia.hook"
        sudo rm -f "/etc/pacman.d/hooks/refind.hook"
        sudo cp -f "${MISC_DIR}/config/pacman.d/hooks/refind.hook" "/etc/pacman.d/hooks/refind.hook"

        # NOTE: Skipped mkinitcpio because it's system dependent... use Chezmoi!
        ;;
    *)
        echo "Skipping installing configurations with root"
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
