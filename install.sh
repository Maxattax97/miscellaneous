#!/usr/bin/env bash

# TODO: Convert this script to shell so it can run on lighter systems.

MISC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if [ -n "${AUTOMATED}" ]; then
    AUTOMATED_PACMAN_FLAGS="--noconfirm"
fi

echo "Linking from ${MISC_DIR} ..."

TEXT_RED='\033[0;91m';
TEXT_RESET='\033[0m';
TEXT_BLINK='\033[5m';

link_skipped_files="";
link_linked_files="";
link_overwritten_files="";

link_source() {
    src="${MISC_DIR}/${1}"
    overwrite="${2:-0}"
    dest="${HOME}/${3:-$1}"

    if [ -h "$dest" ]; then
        #echo "Skipping $dest because it is already linked ..."
        link_skipped_files+="$dest "
    elif [ -f "$dest" ]; then
        if [ "$overwrite" -eq 1 ]; then
            rm -f "$dest"
            #echo "Overwriting file and linking $src -> $dest ..."
            link_overwritten_files+="$dest "
            ln -sf "$src" "$dest"
        else
            echo -e "${TEXT_RED}${TEXT_BLINK}Not overwriting $dest because a file exists there!${TEXT_RESET}"
        fi
    elif [ -d "$dest" ]; then
        if [ "$overwrite" -eq 1 ]; then
            rm -rf "$dest"
            #echo "Overwriting directory and linking $src -> $dest ..."
            link_overwritten_files+="$dest "
            ln -sf "$src" "$dest"
        else
            echo -e "${TEXT_RED}${TEXT_BLINK}Not overwriting $dest because a directory exists there!${TEXT_RESET}"
        fi
    else
        #echo "Linking $src -> $dest ..."
        link_linked_files+="$dest "
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
link_source .Xdefaults 1 .Xresources
link_source .eslintrc.json 0
link_source ".gtkrc-2.0" 0
link_source .xinitrc 0
link_source .xprofile 0
link_source .warprc 0

# Dot directories
mkdir -p "${HOME}/.config/"

mkdir -p "${HOME}/.ncmpcpp"
link_source "config/ncmpcpp/config" 1 ".ncmpcpp/config"

mkdir -p "${HOME}/.gnupg"
link_source "config/gnupg/gpg.conf" 0 ".gnupg/gpg.conf"

mkdir -p "${HOME}/.ssh"
link_source "config/ssh/config" 0 ".ssh/config"
link_source "config/ssh/aws-ssm-ec2-proxy-command.sh" 1 ".ssh/aws-ssm-ec2-proxy-command.sh"

# Linked folders
link_source "config/SpaceVim.d" 1 ".SpaceVim.d"
link_source ".tmuxp" 1

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

mkdir -p "${HOME}/.config/copyq"
link_source "config/copyq/copyq-commands.ini" 1 ".config/copyq/copyq-commands.ini"
link_source "config/copyq/copyq.conf" 1 ".config/copyq/copyq.conf"
link_source "config/copyq/copyq-filter.ini" 1 ".config/copyq/copyq-filter.ini"
link_source "config/copyq/copyq_geometry.ini" 1 ".config/copyq/copyq_geometry.ini"
link_source "config/copyq/copyq_tabs.ini" 1 ".config/copyq/copyq_tabs.ini"

# We only want to copy the roles folder from sgpt; the .sgptrc file contains our OpenAI key
mkdir -p "${HOME}/.config/shell_gpt/roles/"
link_source "config/shell_gpt/roles/" 1 ".config/shell_gpt/roles"

# We link for both the regular and Flatpak versions of FreeCAD.
mkdir -p "${HOME}/.var/app/org.freecadweb.FreeCAD/config/FreeCAD"
link_source "config/FreeCAD/user.cfg" 1 ".var/app/org.freecadweb.FreeCAD/config/FreeCAD/user.cfg"
mkdir -p "${HOME}/.config/FreeCAD"
link_source "config/FreeCAD/user.cfg" 1 ".config/FreeCAD/user.cfg"

# awcli
mkdir -p "${HOME}/.aws"
link_source "config/aws/config" 0 ".aws/config"

# Binaries / executables
mkdir -p "${HOME}/bin/"

link_source "bin/ctlpanel" 1
link_source "bin/gspeak" 1
link_source "bin/idle-mine" 1
link_source "bin/reload-kde" 1
link_source "bin/restart-kde" 1
link_source "bin/logout-kde" 1

echo "Overwritten files: ${link_overwritten_files}"
echo "Linked files: ${link_linked_files}"
echo "Skipped files: ${link_skipped_files}"

echo "Environment installation complete"

read -r -p "Would you like to attempt an install of common utilities? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        # TODO: Verify weechat plugins are installed (probably aren't).
        if [[ -x "$(command -v dnf)" ]]; then
            # shell-gpt needs python3-devel on Fedora.
            # gem needs ruby-devel on Fedora.
            sudo dnf install -y \
                btop \
                ctags \
                curl \
                dnf-plugins-core \
                fastfetch \
                gcc \
                git \
                git-crypt \
                git-lfs \
                gnupg2 \
                keychain \
                make \
                neovim \
                newsboat \
                nodejs \
                nodejs-npm \
                pipx \
                python3 \
                python3-devel \
                python3-neovim \
                python3-pip \
                ripgrep \
                ruby-devel \
                rubygems \
                tmux \
                util-linux-user \
                weechat \
                xclip \
                zsh
        elif [[ -x "$(command -v brew)" ]]; then
            # macOS has outdated version of curl, make, binutils, gcc
            # macOS login needs pinentry-mac in order to complete gpg git commit signing
            brew install \
                binutils \
                btop \
                chezmoi \
                ctags \
                curl \
                fastfetch \
                gcc \
                gh \
                git \
                git-crypt \
                git-lfs \
                gnupg \
                keychain \
                libtool \
                make \
                neovim \
                newsboat \
                node \
                pinentry-mac \
                pipx \
                pkg-config \
                python \
                ripgrep \
                tmux \
                weechat \
                xclip \
                zsh
        elif [[ -x "$(command -v apt)" ]]; then
            sudo apt install -y \
                btop \
                ctags \
                curl \
                gcc \
                git \
                git-crypt \
                git-lfs \
                gpg \
                keychain \
                make \
                neofetch \
                neovim \
                newsboat \
                nodejs \
                npm \
                pipx \
                python3 \
                python3-pip \
                python3-pynvim \
                ripgrep \
                ruby-rubygems \
                tmux \
                weechat \
                xclip \
                zsh
        elif [[ -x "$(command -v pacman)" ]]; then
            sudo pacman -Syu --needed "$AUTOMATED_PACMAN_FLAGS" \
                btop \
                chezmoi \
                ctags \
                curl \
                gcc \
                git \
                git-crypt \
                git-lfs \
                github-cli \
                gnupg \
                keychain \
                make \
                neovim \
                newsboat \
                nodejs \
                npm \
                python \
                python-pip \
                python-pipx \
                python-pynvim \
                ripgrep \
                rubygems \
                tmux \
                weechat \
                xclip \
                zsh

            if [[ -x "$(command -v yay)" ]]; then
                    yay -Syu "$AUTOMATED_PACMAN_FLAGS" \
                        fastfetch \
                        --needed
            fi
        elif [[ -x "$(command -v pkg)" ]]; then
            sudo pkg install \
                btop \
                chezmoi \
                ctags \
                curl \
                fastfetch \
                gcc \
                gh \
                git \
                git-crypt \
                git-lfs \
                gmake \
                gnupg \
                keychain \
                neovim \
                newsboat \
                node \
                npm \
                py39-pip \
                py39-pipx \
                py39-pynvim \
                python \
                ripgrep \
                ruby \
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
            pip2 install --user \
                neovim
        fi

        if [[ -x "$(command -v pipx)" ]]; then
            pipx install ansible
            pipx install ansible-core
            pipx install ansible-lint
            pipx install ansible-navigator
            pipx install argcomplete
            pipx install flake8
            pipx install flake8-pyproject
            pipx install isort
            pipx install molecule
            pipx install neovim
            pipx install pre-commit
            pipx install shell-gpt
            pipx install thefuck
            pipx install tmuxp
        elif [[ -x "$(command -v pip3)" ]]; then
            pip3 install --user \
                ansible \
                ansible-core \
                ansible-lint \
                argcomplete \
                flake8 \
                isort \
                neovim \
                shell-gpt \
                thefuck \
                tmuxp
        else
            echo "You need to install pipx / pip3"
        fi

        # TODO: install LTS node via NVM which is installed via ZSH.
        if [[ -x "$(command -v npm)" ]]; then
            npm install -g neovim || sudo npm install -g neovim

            # I set this up to use npx instead
            #npm install -g bash-language-server
        else
            echo "You need to install npm"
        fi

        if [[ -x "$(command -v gem)" ]]; then
            gem install \
                neovim \
                taskjuggler
        else
            echo "You need to install gem"
        fi

        if [[ ! -d "${HOME}/.cache/dein" ]]; then
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/Shougo/dein-installer.vim/master/installer.sh)" -- "${HOME}/.cache/dein" --use-neovim-config
        fi

        # Pull GPG keys for max.ocull@protonmail.com
        gpg --receive-keys 9AC8DC8D17BA0401CBD0F4E16077844530A4A68E

        # Gentoo keys
        gpg --keyserver hkps://keys.gentoo.org --receive-keys 13EBBDBEDE7A12775DFDB1BABB572E0E2D182910

        # FreeBSD team keys
        curl -s https://docs.freebsd.org/pgpkeys/pgpkeys.txt | gpg --import

        # Linux Kernel
        # https://www.kernel.org/signature.html
        ## Linus Torvalds
        gpg --receive-keys ABAF11C65A2970B130ABE3C479BE3E4300411886
        ## Greg Kroah-Hartman
        gpg --receive-keys 647F28654894E3BD457199BE38DBBDC86092693E
        ## Sasha Levin
        gpg --receive-keys E27E5D8A3403A2EF66873BBCDEA66FF797772CDC
        ## Ben Hutchings
        gpg --receive-keys AC2B29BD34A6AFDDB3F68F35E7BFC8EC95861109

        # Arch Linux Official Keys
        # https://archlinux.org/master-keys/
        ## Florian Pritz
        gpg --receive-keys 91FFE0700E80619CEB73235CA88E23E377514E00
        ## Levente Polyak
        gpg --receive-keys D8AFDDA07A5B6EDFA7D8CCDAD6D055F927843F1C
        ## David Runge
        gpg --receive-keys 2AC0A42EFB0B5CBC7A0402ED4DC95B6D7BE9892E
        ## Johannes Löthberg
        gpg --receive-keys 69E6471E3AE065297529832E6BA0F5A2037F4F41
        ## Leonidas Spyropoulos
        gpg --receive-keys 3572FA2A1B067F22C58AF155F8B821B42A6FDCD7


        if [[ ! "$SHELL" =~ "zsh" ]]; then
            chsh -s "$(command -v zsh)" "${USER}"
        fi
        ;;
    *)
        echo "Skipping common utility installation"
        ;;
esac

read -r -p "Would you like to add unofficial package repositories? [y/N] " response
case "$response" in
        [yY][eE][sS]|[yY])
                if [[ -x "$(command -v dnf)" ]]; then
                    sudo dnf install -y "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
                    sudo dnf install -y "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

                    # Add repo for Brave
                    sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
                    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

                    # Add repo for Docker
                    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

                    # Import PGP key for VeraCrypt.
                    sudo rpm --import https://www.idrix.fr/VeraCrypt/VeraCrypt_PGP_public_key.asc

                    # Add Copr repo for OpenVPN Connect
                    ## This repo does not have an x64 build for Fedora 39 for some reason?
                    ##sudo dnf copr enable dsommers/openvpn3
                    # This one works:
                    sudo dnf copr enable ojab/openvpn3

                    # Add Signal Desktop repo
                    sudo dnf config-manager --add-repo "https://download.opensuse.org/repositories/network:im:signal/Fedora_$(rpm -E %fedora)/network:im:signal.repo"

                    # Add Github CLI repo
                    sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo

                    # Update all the new repositories
                    sudo dnf update -y

                    read -r -p "Would you like to install Brave? [y/N] " response
                    case "$response" in
                            [yY][eE][sS]|[yY])
                                sudo dnf install -y brave-browser
                                ;;
                            *)
                                echo "Skipping Brave installation"
                                ;;
                    esac

                    read -r -p "Would you like to install Docker? [y/N] " response
                    case "$response" in
                            [yY][eE][sS]|[yY])
                                sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
                                sudo systemctl enable docker
                                sudo systemctl start docker
                                ;;
                            *)
                                echo "Skipping Docker installation"
                                ;;
                    esac

                    read -r -p "Would you like to install AWS Session Manager Plugin? [y/N] " response
                    case "$response" in
                            [yY][eE][sS]|[yY])
                                sudo dnf install -y https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm
                                ;;
                            *)
                                echo "Skipping AWS Session Manager Plugin installation"
                                ;;
                    esac

                    read -r -p "Would you like to install Github CLI? [y/N] " response
                    case "$response" in
                            [yY][eE][sS]|[yY])
                                sudo dnf install -y gh
                                ;;
                            *)
                                echo "Skipping Github CLI installation"
                                ;;
                    esac

                    read -r -p "Would you like to install Signal Desktop? [y/N] " response
                    case "$response" in
                            [yY][eE][sS]|[yY])
                                sudo dnf install -y signal-desktop
                                ;;
                            *)
                                echo "Skipping Signal Desktop installation"
                                ;;
                    esac
                elif [[ -x "$(command -v apt)" ]]; then
                    # Install tools for adding repositories
                    sudo apt-get install -y apt-transport-https

                    # Make sure the keyrings directory exists
                    sudo mkdir -p -m 755 /etc/apt/keyrings

                    # Keys and repository for Kubernetes
                    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
                    sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring
                    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
                    sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly

                    # Keys and repository for Helm
                    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
                    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

                    # Keys and repository for Github CLI
                    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
                    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
                    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

                    sudo apt-get update

                    read -r -p "Would you like to install AWS Session Manager Plugin? [y/N] " response
                    case "$response" in
                            [yY][eE][sS]|[yY])
                                curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
                                sudo dpkg -i "session-manager-plugin.deb"
                                rm -f "session-manager-plugin.deb"
                                ;;
                            *)
                                echo "Skipping AWS Session Manager Plugin installation"
                                ;;
                    esac

                    read -r -p "Would you like to install Kubernetes? [y/N] " response
                    case "$response" in
                            [yY][eE][sS]|[yY])
                                sudo apt-get install -y kubectl
                                ;;
                            *)
                                echo "Skipping Kubernetes installation"
                                ;;
                    esac

                    read -r -p "Would you like to install Helm? [y/N] " response
                    case "$response" in
                            [yY][eE][sS]|[yY])
                                sudo apt-get install -y helm
                                ;;
                            *)
                                echo "Skipping Helm installation"
                                ;;
                    esac

                    read -r -p "Would you like to install Github CLI? [y/N] " response
                    case "$response" in
                            [yY][eE][sS]|[yY])
                                sudo apt-get install -y gh
                                ;;
                            *)
                                echo "Skipping Github CLI installation"
                                ;;
                    esac
                elif [[ -x "$(command -v pacman)" ]]; then
                    echo "No repositories for pacman yet"
                    # TODO: Set up yay.
                fi
                ;;
        *)
                echo "Skipping unofficial package repository installation"
                ;;
esac

read -r -p "Would you like to attempt an install of bspwm? [y/N] " response
case "$response" in
        [yY][eE][sS]|[yY])
                if [[ -x "$(command -v dnf)" ]]; then
                        # TODO: Fill the rest in.
                        sudo dnf install \
                            @base-x \
                            bspwm \
                            copyq \
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
                            copyq \
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
                            xorg \
                            yad \
                            -y

                        echo "You will need to build polybar from source: https://github.com/polybar/polybar/wiki/Compiling"
                        echo "python-xcbgen may need to be changed to python3-xcbgen"
                        sudo apt install -y build-essential git cmake cmake-data pkg-config python3-sphinx python3-packaging libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev i3-wm libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev

                        echo "You will need to build picom from source: https://github.com/yshui/picom#build"
                        sudo apt install -y libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev
                elif [[ -x "$(command -v pacman)" ]]; then
                        sudo pacman -Syu "$AUTOMATED_PACMAN_FLAGS" \
                            bspwm \
                            copyq \
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
                            variety \
                            xarchiver \
                            xorg-server \
                            yad \
                            --needed

                        if [[ -x "$(command -v yay)" ]]; then
                                yay -Syu "$AUTOMATED_PACMAN_FLAGS" \
                                    ly \
                                    nsxiv \
                                    --needed
                        fi
                elif [[ -x "$(command -v pkg)" ]]; then
                        sudo pkg install \
                            Kvantum-qt5 \
                            bspwm \
                            copyq \
                            dunst \
                            gtk-murrine-engine \
                            lxappearance \
                            ly \
                            materia-gtk-theme \
                            ncurses \
                            nitrogen \
                            nsxiv \
                            papirus-icon-theme \
                            pcmanfm-gtk3 \
                            picom \
                            pidof \
                            polybar \
                            qt6ct \
                            rofi \
                            sxhkd \
                            variety \
                            xarchiver \
                            xorg \
                            yad

                            # Could not find these:
                            #materia-kde \
                            #network-manager-applet \
                            #nm-connection-editor \
                fi

                #if [[ -x "$(command -v pip3)" ]]; then
                        #pip3 install --user \
                #fi

                # copy service files
                #mkdir -p ~/.config/systemd/user/
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

read -r -p "Would you like to attempt an install of workstation utilities? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        if [[ -x "$(command -v dnf)" ]]; then
            sudo dnf install \
                brave-browser \
                firefox \
                flameshot \
                google-noto-emoji-color-fonts \
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
        elif [[ -x "$(command -v brew)" ]]; then
            brew install \
                ffmpeg \
                minikube \
                p7zip \
                qalculate-gtk \
                qemu \
                rar \
                yt-dlp

            brew install --cask \
                brave-browser \
                docker \
                flameshot \
                inkscape \
                iterm2 \
                joplin \
                libreoffice \
                mpv \
                nextcloud \
                utm \
                veracrypt \
                vlc \
                wireshark
        elif [[ -x "$(command -v apt)" ]]; then
            sudo apt install \
                flameshot \
                fonts-noto-color-emoji \
                gparted \
                inkscape \
                libreoffice \
                mpv \
                nextcloud-desktop \
                p7zip-full \
                qalculate-gtk \
                unrar \
                zathura \
                -y

            # TODO: Add ppa for veracrypt on Ubuntu
            # TODO: Add ppa for Brave on Ubuntu
        elif [[ -x "$(command -v pacman)" ]]; then
            sudo pacman -Syu "$AUTOMATED_PACMAN_FLAGS" \
                flameshot \
                girara \
                gnome-keyring \
                inkscape \
                libreoffice-fresh \
                mpv \
                nextcloud-client \
                noto-fonts-emoji \
                p7zip \
                qalculate-gtk \
                unrar \
                veracrypt \
                zathura \
                zathura-pdf-mupdf \
                --needed
            if [[ -x "$(command -v yay)" ]]; then
                    yay -Syu "$AUTOMATED_PACMAN_FLAGS" \
                        brave-bin \
                        yt-dlp \
                        --needed
            fi
        elif [[ -x "$(command -v pkg)" ]]; then
            sudo pkg install \
                flameshot \
                girara \
                gnome-keyring \
                inkscape \
                libreoffice \
                mpv \
                nextcloudclient \
                noto-emoji \
                qalculate-gtk \
                unrar \
                veracrypt \
                yt-dlp \
                zathura \
                zathura-pdf-mupdf
        fi

        if [[ ! -x "$(command -v brew)" ]]; then
            if [ -s /usr/share/applications/brave.desktop ]; then
                xdg-settings set default-web-browser brave.desktop
            elif [ -s /usr/share/applications/brave-browser.desktop ]; then
                xdg-settings set default-web-browser brave-browser.desktop
            fi

            # Install NordVPN CLI tool.
            sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)

            # Install/update Joplin
            curl https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
        fi

        if [[ ! -x "$(command -v veracrypt)" ]]; then
            if [ -n "${AUTOMATED}" ]; then
                response='n'
            else
                read -r -p "You must manually download and install VeraCrypt. Would you like to go there now? [y/N] " response
            fi
            case "$response" in
                [yY][eE][sS]|[yY])
                    xdg-open 'https://veracrypt.eu/en/Downloads.html'
                    ;;
                *)
                    echo "Skipping VeraCrypt installation"
                    ;;
            esac
        fi

        ;;
    *)
        echo "Skipping workstation utility installation"
        ;;
esac


read -r -p "Would you like to attempt an install of Suckless Terminal (st)? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        if [[ -x "$(command -v dnf)" ]]; then
            sudo dnf install \
                fontconfig-devel \
                freetype-devel \
                libX11-devel \
                libXft-devel \
                -y
        fi

        # TODO: The other package managers
        #elif [[ -x "$(command -v brew)" ]]; then
            #brew install \
        #elif [[ -x "$(command -v apt)" ]]; then
            #sudo apt install \
        #elif [[ -x "$(command -v pacman)" ]]; then
            #sudo pacman -Syu "$AUTOMATED_PACMAN_FLAGS" \
                #--needed
        #elif [[ -x "$(command -v pkg)" ]]; then
            #sudo pkg install \
        #fi

        if [[ ! -d "${MISC_DIR}/../lukesmithxyz-st/" ]]; then
            git clone https://github.com/LukeSmithxyz/st.git "${MISC_DIR}/../lukesmithxyz-st/"
        fi
        (cd "${MISC_DIR}/../lukesmithxyz-st" && make && sudo make install)
        sudo install -Dm644 "${MISC_DIR}/scripts/st.desktop" /usr/share/applications/st.desktop
        xrdb "${MISC_DIR}/.Xdefaults"
        ;;
    *)
        echo "Skipping Suckless Terminal (st) installation"
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
                                sudo pacman -Syu --needed "$AUTOMATED_PACMAN_FLAGS" \
                                    msr-tools \
                                    nyx \
                                    tor

                                if [[ -x "$(command -v yay)" ]]; then
                                        yay -Syu --needed "$AUTOMATED_PACMAN_FLAGS" \
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
            {
                printf "[user]\n\tname = Max O'Cull\n\temail = max.ocull@protonmail.com\n";
                printf "[alias]\n\tlogline = log --graph --pretty=format:'";
                echo -n '%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset';
                printf "' --abbrev-commit\n";
            } > "${HOME}/.gitconfig"
        fi

        # Use Neovim's difftool
        git config --global diff.tool nvimdiff
        git config --global diff.algorithm histogram
        git config --global merge.tool nvimdiff
        git config --global --add difftool.prompt false

        # Automatically set up remotes if they don't exist when pushing.
        git config --global push.autoSetupRemote

        # Merge by default.
        git config --global pull.rebase false

        # Use `main` as default branch... so Github stops complaining.
        git config --global init.defaultBranch main

        # When you setup a GPG subkey for this machine, you'll use these:
        # git config --global user.signingkey 5E745B2A9C8F64736FA2CA73F8362D782F70AEAB
        # git config --global commit.gpgsign true

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

read -r -p "Would you like to setup Rust? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

        # For Neovim
        rustup component add rust-analyzer
        ;;
    *)
        echo "Skipping Rust setup"
        ;;
esac

read -r -p "Would you like to setup Krew? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        (
            set -x; cd "$(mktemp -d)" &&
            OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
            ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
            KREW="krew-${OS}_${ARCH}" &&
            curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
            tar zxvf "${KREW}.tar.gz" &&
            ./"${KREW}" install krew
        )
        ;;
    *)
        echo "Skipping Krew setup"
        ;;
esac

read -r -p "Would you like to setup Protobuf libraries? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        (
            version="27.2"
            file="protoc-${version}-linux-x86_64.zip"
            curl -LO "https://github.com/protocolbuffers/protobuf/releases/download/v${version}/${file}"
            unzip "${file}" -d "${HOME}/.local"
            rm -f "${file}"
        )
        ;;
    *)
        echo "Skipping Protobuf setup"
        ;;
esac

read -r -p "Would you like to setup Mikrotik's WinBox? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
            mkdir -p "${HOME}/.local/share/mikrotik/"
            echo "Downloading ..."
            curl -fsSL 'https://mt.lv/winbox64' -o "${HOME}/.local/share/mikrotik/winbox"

            # Make a script to execute it.
            echo "#!/bin/sh" > "${HOME}/.local/bin/winbox"
            echo "wine64 ${HOME}/.local/share/mikrotik/winbox" >> "${HOME}/.local/bin/winbox"
            chmod +x "${HOME}/.local/bin/winbox"
            echo "Succesfully installed, use \`winbox\` to open"
        ;;
    *)
        echo "Skipping WinBox setup"
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

        sudo rm -f "/etc/dnf/dnf.conf"
        sudo cp -f "${MISC_DIR}/config/dnf.conf" "/etc/dnf/dnf.conf"

        # NOTE: Skipped mkinitcpio because it's system dependent... use Chezmoi!
        ;;
    *)
        echo "Skipping installing configurations with root"
        ;;
esac

read -r -p "Would you like to setup system permissions? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])

        if [[ -x "$(command -v pw)" ]]; then
            sudo pw groupmod video -m "$USER"
            sudo pw groupmod docker -m "$USER"
            sudo pw groupmod wireshark -m "$USER"
            sudo pw groupmod wheel -m "$USER"
            sudo pw groupmod tty -m "$USER"
            sudo pw groupmod nordvpn -m "$USER"
        else
            # TODO: Check that these are correct groupadd commands.
            sudo groupadd -r docker
            sudo usermod -a -G docker "$USER"

            sudo groupadd -r wireshark
            sudo usermod -a -G wireshark "$USER"

            sudo groupadd -r tty
            sudo usermod -a -G tty "$USER"

            sudo groupadd -r nordvpn
            sudo usermod -a -G nordvpn "$USER"
        fi
        ;;
    *)
        echo "Skipping permission setup"
        ;;
esac

read -r -p "Would you like to install fonts? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        if [[ -x "$(command -v yay)" ]]; then
                yay -Syu "$AUTOMATED_PACMAN_FLAGS" \
                    all-repository-fonts \
                    ttf-ms-fonts \
                    --needed
        fi
        ./scripts/font-install.sh

        # Set fonts for Gnome.
        if [[ "$XDG_CURRENT_DESKTOP" == "GNOME" ]]; then
            gsettings set org.gnome.desktop.interface font-name 'FreeSans 11'
            gsettings set org.gnome.desktop.interface document-font-name 'FreeSans 11'
            gsettings set org.gnome.desktop.interface monospace-font-name 'Hack Nerd Font Mono 11'
        fi
        ;;
    *)
        echo "Skipping font installation"
        ;;
esac
