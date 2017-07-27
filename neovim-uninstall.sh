#!/bin/bash

# Feature list: https://stackoverflow.com/questions/208193/why-should-i-use-an-ide

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CLEAR='\033[0m'

if ! [ "$(id -u)" = 0 ]; then
	echo -e "${RED}Superuser permissions are required to run this script.${CLEAR}"
	exit 1
fi

cd "$HOME" || exit # These are for safety.
clear; clear

echo -e "${BLUE}Checking for the local package manager...${CLEAR}"
APT_GET_INSTALLED=$(which apt-get)
PACMAN_INSTALLED=$(which pacman)
YUM_INSTALLED=$(which yum)
NPM_INSTALLED=$(which npm)
CARGO_INSTALLED=$(which cargo)

if [[ ! -z $APT_GET_INSTALLED ]]; then
	echo -e "${GREEN}Found apt-get...${CLEAR}"
	add-apt-repository ppa:neovim-ppa/unstable

	# PPA for Crystal
	apt-key adv --keyserver keys.gnupg.net --recv-keys 09617FD37CC06B54
	echo "deb https://dist.crystal-lang.org/apt crystal main" > /etc/apt/sources.list.d/crystal.list
	
	apt-get update
	apt-get upgrade
	apt-get install neovim \
		gawk shellcheck cppcheck mono-complete mono-msc tidy luarocks # Linters

	if [[ ! -z $NPM_INSTALLED ]]; then
		apt-get install git npm 
	fi

	if [[ ! -z $CARGO_INSTALLED ]]; then
		echo "Not yet implemented."
	fi
elif [[ ! -z $PACMAN_INSTALLED ]]; then
	echo -e "${GREEN}Found pacman...${CLEAR}"
	pacman -Syu
	pacman -S --needed git neovim python-pip python2-pip ctags clang \
		gawk shellcheck cppcheck mono ruby crystal dmd stack ghc elixir go tidy luarocks nim \ # For Linter support
		dcd # For autocmplete support

	if [[ ! -z $NPM_INSTALLED ]]; then
		pacman -S git nodejs npm xsel --needed
	fi

	if [[ ! -z $CARGO_INSTALLED ]]; then
		pacman -S rust cargo
	fi
elif [[ ! -z $YUM_INSTALLED ]]; then
	echo -e "${GREEN}Found yum...${CLEAR}"
	yum update
	# yum -y install epel-release
	yum install cppcheck ShellCheck 

	# DNF?

	if [[ ! -z $NPM_INSTALLED ]]; then
		echo "Not yet implemented."
	fi

	if [[ ! -z $CARGO_INSTALLED ]]; then
		echo "Not yet implemented."
	fi
else
	echo -e "${RED}Your package manager is not supported by the installer.${CLEAR}"
	exit 1;
fi

stack setup # Install the Haskell toolchain
stack install Cabal

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# TODO: Dynamically update clang paths.
# Includes:
#		find /lib*/ -path "*/lib/clang/*/includes/"
# LibClang:
#		find /lib*/ -name "libclang*.so*"

# TODO: Install Powerline fonts.
#	Also set a default Powerline font.
mkdir -p /usr/share/fonts
cd /usr/share/fonts && curl -fLo "DejaVu Sans Mono Nerd Font Complete.ttf" https://raw.githubusercontent.com/ryanoasis/nerd-fonts/1.0.0/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono.ttf
fc-cache -fv

cargo install racer

mkdir -p /usr/local/src/rust/
git clone --depth=1 https://github.com/rust-lang/rust.git /usr/local/src/rust/

# TODO: Update rust source code paths.

pip2 install neovim
pip3 install neovim
# TODO: Ruby provider.

# TODO: Symlink/copy the nvimrc to ~/.config/nvim

# Install linters 
npm install -g coffeescript coffeelint csslint stylelint elm eslint jscs jshint flow-remove-types flow-bin standard jsonlint
pip install proselint cmakelint cython
pip2 install ansible-lint
gem install foodcritic erubi haml_lint mdl
go get -u github.com/golang/lint/golint
go get -u github.com/alecthomas/gometalinter # Unstable version
cabal install hlint
luarocks install luacheck

# TODO: Examine Standard more closely, seems a little fanatical...

# Build from source
# Hadolint
mkdir -p /usr/local/src/hadolint/
git clone https://github.com/lukasmartinelli/hadolint /usr/local/src/hadolint/
cd /usr/local/src/hadolint/; check
stack build

# Credo
mkdir -p /usr/local/src/credo/
git clone https://github.com/rrrene/credo /usr/local/src/credo/
cd /usr/local/src/credo/; check
mix deps.get
mix archive.build
mix archive.install

# Dogma
# Skip for now, we have Credo

# TODO: erlc, checkstyle, kotlinc, mlint
# Bookmark: NIX

cd "$HOME"; check

nvim -c "PlugInstall" -c "qa"

echo "${GREEN}Installation complete.${CLEAR}"
echo "Please set your terminal profile to use \"DejaVuSansMono Nerd Font\" or a similar Powerline font."

