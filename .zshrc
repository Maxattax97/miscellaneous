# The following lines were added by compinstall

zstyle ':completion:*' auto-description '\ %d'
zstyle ':completion:*' completer _list _expand _complete _ignored _match _correct _approximate _prefix
zstyle ':completion:*' format '> Completing %d ...'
zstyle ':completion:*' insert-unambiguous true
zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}
#zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 3
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/home/max/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=10000
setopt appendhistory autocd beep extendedglob nomatch notify
bindkey -v
# End of lines configured by zsh-newuser-install

### INCLUDES ###
if [[ -e "$HOME/.batsrc" ]]; then
    source "$HOME/.batsrc"
fi

### ZPLUG PACKAGES ###
if [[ ! -d "$HOME/.zplug" ]]; then
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

source ~/.zplug/init.zsh

zplug "zplug/zplug", hook-build: "zplug --self-manage"

zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"

zplug 'mfaerevaag/wd', as:command, use:"wd.sh", hook-load:"wd() { . $ZPLUG_REPOS/mfaerevaag/wd/wd.sh }"

# Must load last.
zplug "zsh-users/zsh-syntax-highlighting"

if ! zplug check; then
    zplug install
fi

zplug load

### BASH IMPORT ###
enable_banner="yes"

export EDITOR=/usr/bin/nano # For lightweight purposes.

# For heavyweight purposes.
if [[ -x "$(command -v nvim)" ]]; then
    export VISUAL="/usr/bin/nvim"
elif [[ -x "$(command -v vim)" ]]; then
    export VISUAL="/usr/bin/vim"
    alias nvim="vim"
else
    export VISUAL="/usr/bin/nano"
fi

export PAGER='less'
export MANPAGER='less'

if [[ -x "$(command -v firefox)" ]]; then
    export BROWSER="firefox '%' &"
elif [[ -x "$(command -v chromium)" ]]; then
    export BROWSER="chromium '%' &"
elif [[ -x "$(command -v google-chrome-stable)" ]]; then
    export BROWSER="google-chrome-stable '%' &"
fi

add-path() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

add-path "$HOME/bin/"
add-path "/sbin/"
add-path "/usr/sbin/"

export PROMPT_DIRTRIM=3 # Show the last 3 directories in the prompt.

# Dynamically set term to the right prefix.
case $TERM in
    konsole|xterm|screen|tmux|rxvt-unicode)
        TERM="$TERM-256color";;
esac

# Colors
RED='\e[0;31m'
LIGHTRED='\e[1;31m'
YELLOW='\e[1;33m'
GREEN='\e[0;32m'
LIGHTGREEN='\e[1;32m'
CYAN='\e[0;36m'
LIGHTCYAN='\e[1;36m'
BLUE='\e[0;34m'
LIGHTBLUE='\e[1;34m'
PURPLE='\e[0;35m'
LIGHTPURPLE='\e[1;35m'
BROWN='\e[0;33m'
BLACK='\e[0;30m'
DARKGREY='\e[1;30m'
LIGHTGREY='\e[0;37m'
WHITE='\e[1;37m'
NC='\e[0m' # "No color"
RESET=$NC
BLINK='\e[5m'
BOLD='\e[1m'

# Settings
time_indicator=yes
resource_indicator=yes
enable_banner=yes

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

#_shrunkPrompt='\[\033[00m\]\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$\[$(tput sgr0)\]\[\033[00m\] '
#PS1='\[\033[00m\]'
#if [ "$time_indicator" = yes ]; then
    #PS1=${PS1}'\[\033[00;37m\][\[\033[01;30m\]\t\[\033[00;37m\]]'
#fi
#PS1=${PS1}' \[\033[01;32m\]\u\[\033[01;30m\]@\[\033[00;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$\[$(tput sgr0)\]\[\033[00m\] '
#_normalPrompt=${PS1}

unset time_indicator resource_indicator color_prompt force_color_prompt

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Fix tmux 256 colors:
alias tmux='tmux -2'

# Clear color codes before clearing:
alias clear='echo -e "\e[0m" && clear'

# Typical rsync command
alias relocate='rsync -avzh --info=progress2'

# Aliases, functions, commands, etc.
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1    ;;
            *.tar.gz)    tar xvzf $1    ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar x $1       ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xvf $1     ;;
            *.tbz2)      tar xvjf $1    ;;
            *.tgz)       tar xvzf $1    ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "Unknown filetype for '$1'" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

colors () {
    echo    'Usage: ${LIGHTPURPLE}Your text ${BLINK}here${RESET}'
    echo -e "     > ${LIGHTPURPLE}Your text ${BLINK}here${RESET}"
    echo -e "Special colors: ${BLINK}BLINK ${NC}NC ${BOLD}BOLD ${RESET}RESET"
    echo -e "Normal colors: ${RED}RED ${LIGHTRED}LIGHTRED ${YELLOW}YELLOW ${GREEN}GREEN ${LIGHTGREEN}LIGHTGREEN ${CYAN}CYAN ${LIGHTCYAN} ${BLUE}BLUE ${LIGHTBLUE}LIGHTBLUE ${PURPLE}PURPLE ${LIGHTPURPLE}LIGHTPURPLE ${BROWN}BROWN ${BLACK}BLACK ${DARKGREY}DARKGREY ${LIGHTGREY}LIGHTGREY ${WHITE}WHITE"
}

# Join a telnet based movie theater.
starwars() {
    telnet towel.blinkenlights.nl
}

# Download and run a curl based Party Parrot animation.
parrot() {
    curl parrot.live
}

# Duplicate of parrot()
party() {
    parrot
}

# Ascend the directories X times.
up() {
    DEEP=$1
    [ -z "${DEEP}" ] && {
        DEEP=1
    }
    for i in $(seq 1 ${DEEP})
        do cd ../
    done;
}

_shrunk=no
shrink() {
    if [ "$_shrunk" = no ]; then
        _shrunk=yes
        PS1=${_shrunkPrompt}
    else
        _shrunk=no
        PS1=${_normalPrompt}
    fi
}
alias grow='shrink'

fix-keys() {
    sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com "$(sudo apt update 2>&1 | grep -o '[0-9A-Z]\{16\}$' | xargs)"
}

if [ -d "$HOME/anaconda3/bin/" ]; then
    export PATH="$HOME/anaconda3/bin:$PATH"
fi

if [[ -d "$HOME/.anaconda3/bin" ]]; then
    export PATH="$HOME/.anaconda3/bin:$PATH"
fi

if [ -d "$HOME/.neovim-studio/" ] && [ -z "${NEOVIM_STUDIO_PROFILE_SOURCED}" ]; then
    source "$HOME/.profile"

    if [ -z "${NEOVIM_STUDIO_PROFILE_SOURCED}" ]; then
        # Doesn't exist within the profile.
        export NEOVIM_STUDIO_PROFILE_SOURCED=1
    fi
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if [[ -d "$HOME/bin" ]]; then
	export PATH="$PATH:$HOME/bin"
fi

# NVIDIA CUDA
if [[ -d "/usr/local/cuda/bin" ]]; then
    export PATH="/usr/local/cuda/bin:$PATH"
    export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
    # TODO: Set this to dynamically select 32bit path if on a 32bit system.
fi

if [[ -d "$HOME/.rbenv/" ]]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
fi

# Banner
if [ "$enable_banner" = yes ]; then
    #clear; clear
    if command -v screenfetch; then
        screenfetch -w -d '-pkgs,wm,de,res,gtk;+disk' -E

        # Fix older versions.
        if [[ "$?" -ne 0 ]]; then
            clear
            screenfetch -d '-pkgs,wm,de,res,gtk;+disk' -E
        fi
    else
        echo -e "${LIGHTBLUE}${BOLD}Welcome back, $USER!${RESET}"
        if hash fortune 2>/dev/null; then
            fortune -s
        fi
        echo ""
    fi
fi
unset enable_banner

bkg=white

ZSH_THEME_GIT_PROMPT_PREFIX=" [%{%B%F{blue}%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{%f%k%b%K{${bkg}}%B%F{green}%}]"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{%F{red}%}*%{%f%k%b%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

PROMPT="[%F{white}%*%f] %F{green}%n%f@%F{blue}%M%f%F{gray}:%f%F{magenta}%~%f\$ "
