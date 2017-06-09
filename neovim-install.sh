#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CLEAR='\033[0m'

if ! [ $(id -u) = 0 ]; then
	echo -e "${RED}Superuser permissions are required to run this script.${CLEAR}"
	exit 1
fi

echo -e "${BLUE}Checking for the local package manager...${CLEAR}"
APT_GET_INSTALLED=$(which apt-get)
PACMAN_INSTALLED=$(which pacman)
YUM_INSTALLED=$(which yum)
NPM_INSTALLED=$(which npm)
CARGO_INSTALLED=$(which cargo)

if [[ ! -z $APT_GET_INSTALLED ]]; then
	echo -e "${GREEN}Found apt-get...${CLEAR}"
	add-apt-repository ppa:neovim-ppa/unstable
	apt-get update
	apt-get upgrade
	apt-get install neovim

	if [[ ! -z $NPM_INSTALLED ]]; then
		apt-get install npm
	fi

	if [[ ! -z $CARGO_INSTALLED ]]; then
		# ...	
	fi
elif [[ ! -z $PACMAN_INSTALLED ]]; then
	echo -e "${GREEN}Found pacman...${CLEAR}"
	pacman -Syu
	pacman -S git neovim python-pip python2-pip ctags clang

	if [[ ! -z $NPM_INSTALLED ]]; then
		pacman -S nodejs npm
	fi

	if [[ ! -z $CARGO_INSTALLED ]]; then
		pacman -S rust cargo
	fi
elif [[ ! -z $YUM_INSTALLED ]]; then
	echo -e "${GREEN}Found yum...${CLEAR}"
	yum update

	if [[ ! -z $NPM_INSTALLED ]]; then
		# install nodejs, npm
	fi

	if [[ ! -z $CARGO_INSTALLED ]]; then
		# ...
	fi
else
	echo -e "${RED}Your package manager is not supported by the installer.${CLEAR}"
	exit 1;
fi

# TODO: Dynamically update clang paths.

# TODO: Install Powerline fonts.
#	Also set a default Powerline font.

cargo install racer

mkdir -p /usr/local/src/rust/
git clone --depth=1 https://github.com/rust-lang/rust.git /usr/local/src/rust/

# TODO: Update rust source code paths.

pip2 install neovim
pip3 install neovim
neovim -c "PlugInstall" -c "qa"

