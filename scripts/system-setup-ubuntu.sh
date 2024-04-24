#!/usr/bin/env bash

echo "Setting up PPA's ..."
# Google Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
# Resilio
# ...
# Elementary Tweaks
sudo add-apt-repository ppa:philip.scott/elementary-tweaks
# Spotify
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
# Slack (ScudCloud - FLOSS)
sudo apt-add-repository -y ppa:rael-gc/scudcloud
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
# Oibaf drivers
sudo apt-add-repository ppa:oibaf/graphics-drivers
# Neovim
sudo add-apt-repository ppa:neovim-ppa/stable

echo "Updating apt-cache ..."
sudo apt-get update

echo "Upgrading to latest packages ..."
sudo apt-get dist-upgrade -y

# enable power-savers
# Detect if laptop
sudo apt-get install tlp

# Detect Distro for install method

echo "Installing driver packages ..."
sudo apt-get install exfat-* ntfs-3g ntfs-config

echo "Installing miscellaneous packages ..."
sudo apt-get install gnupg htop tmux iperf inxi network-manager-openvpn openvpn p7zip-full rsync ttf-mscorefonts-installer ttf-ubuntu-font-family software-properties-common python3-software-properties python-software-properties python-dev python-pip python3-dev python3-pip

echo "Installing development packages ..."
sudo apt-get install build-essential git mono-complete nodejs openjdk-8-jdk openjdk-8-jre valgrind nano neovim

echo "Installing forensic tools ..."
sudo apt-get install aircrack-ng binwalk foremost nmap rarcrack steghide wireshark

echo "Installing GUI-based packages ..."
sudo apt-get install google-chrome-stable audacity blender filezilla gimp gparted hexchat okular qbittorrent remmina scudcloud libreoffice

# Pantheon-based
sudo apt install elementary-tweaks
# ksysguard

echo "Installing packages with DRM ..."
sudo apt-get install steam spotify-client

# Install Everything
# sudo apt install tlp exfat-* ntfs-3g ntfs-config gnupg htop tmux iperf inxi network-manager-openvpn openvpn p7zip-full rsync ttf-mscorefonts-installer ttf-ubuntu-font-family software-properties-common python3-software-properties python-software-properties build-essential git mono-complete nodejs openjdk-8-jdk openjdk-8-jre valgrind nano neovim aircrack-ng binwalk foremost nmap rarcrack steghide wireshark google-chrome-stable audacity blender filezilla gimp gparted hexchat okular qbittorrent remmina elementary-tweaks steam spotify-client python-dev python-pip python3-dev python3-pip scudcloud

echo "Cleaning up ..."
sudo apt-get autoremove -y
sudo apt-get clean

# TODO
# dropbox
    # Elementary: https://github.com/zant95/elementary-dropbox

# KVM
# rescuetime
# spotify blocklist https://www.youtube.com/watch?v=QX86UkSLgRk
