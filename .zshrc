### CONFIGURATION ###
config_help=true

### CONSTANTS ###

## Color Codes

## Dynamically set term to the right prefix.
case $TERM in
    konsole|xterm|screen|tmux|rxvt-unicode)
        export TERM="$TERM-256color";;
esac

# gen_color <red> <green> <blue> <fg=1 | bg=0> <style>
gen_color() {
    if [[ "${4:=1}" -eq 1 ]]; then
        # Foreground
        printf "\e[38;%s;%s;%s;%sm" "${5:=2}" "${1:=255}" "${2:=255}" "${3:=255}"
    else
        # Background
        printf "\e[48;%s;%s;%s;%sm" "${5:=2}" "${1:=255}" "${2:=255}" "${3:=255}"
    fi
}

color_main_ui_fg="$(gen_color 255 255 255 1)"
color_main_ui_bg="$(gen_color 255 255 255 0)"
color_main_text_fg="$(gen_color 48 48 48 1)"
color_main_text_bg="$(gen_color 48 48 48 0)"

## Characters
pl_solid_left_triangle='\uE0B0'
pl_hollow_left_triangle='\uE0B1'
pl_solid_right_triangle='uE0B2'
pl_hollow_right_triangle='uE0B3'

pl_solid_left_round='\uE0B4'
pl_hollow_left_round='\uE0B5'
pl_solid_right_round='uE0B6'
pl_hollow_right_round='uE0B7'

pl_solid_left_bot_ledge='\uE0B8'
pl_hollow_left_bot_ledge='\uE0B9'
pl_solid_right_bot_ledge='uE0Ba'
pl_hollow_right_bot_ledge='uE0Bb'

pl_solid_left_top_ledge='\uE0Bc'
pl_hollow_left_top_ledge='\uE0Bd'
pl_solid_right_top_ledge='uE0Be'
pl_hollow_right_top_ledge='uE0Bf'

### ZSH INSTALLER ###
# The following lines were added by compinstall

zstyle ':completion:*' auto-description '\ %d'
zstyle ':completion:*' completer _list _expand _complete _ignored _match _correct _approximate _prefix
zstyle ':completion:*' format '> Completing %d ...'
zstyle ':completion:*' insert-unambiguous true
zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}
#zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 4
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

autoload -Uz promptinit
promptinit

autoload -Uz edit-command-line

if [[ config_help ]]; then
    autoload -Uz run-help
    alias help=run-help

    autoload -Uz run-help-git
    autoload -Uz run-help-ip
    autoload -Uz run-help-openssl
    autoload -Uz run-help-p4
    autoload -Uz run-help-sudo
    autoload -Uz run-help-svk
    autoload -Uz run-help-svn
fi

zstyle ':completion:*' rehash true

# man zshoptions
setopt correct
#setopt correctall
setopt clobber
setopt interactivecomments
setopt nomatch
setopt extendedglob
setopt listpacked
setopt menucomplete
setopt sharehistory

# Vim Bindings
bindkey -v
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey '^[[Z' reverse-menu-complete

zle-keymap-select () {
    zle reset-prompt
    zle -R
}

zle -N zle-keymap-select

export KEYTIMEOUT=1

### PROMPT ###
POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_PROMPT_ON_NEWLINE=false
#POWERLEVEL9K_RPROMPT_ON_NEWLINE=false

# Intriguing elements
# detect_virt ssh vi_mode background_jobs load ram icons_test
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(time detect_virt ssh_joined context ip load ram_joined battery_joined vcs newline os_icon vi_mode dir dir_writable)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(background_jobs command_execution_time)

POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=""
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=""

POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=5
POWERLEVEL9K_VI_INSERT_MODE_STRING="I"
POWERLEVEL9K_VI_COMMAND_MODE_STRING="N"

# Colors
POWERLEVEL9K_COLOR_SCHEME="dark"
PL9K_TEXT_COLOR="232"
PL9K_TEXT_INVERSE_COLOR="255"
PL9K_BLUE="033"
PL9K_GREEN="046"
PL9K_RED="196"
PL9K_ORANGE="214"

POWERLEVEL9K_TIME_BACKGROUND="255"
POWERLEVEL9K_TIME_FOREGROUND="${PL9K_TEXT_COLOR}"

POWERLEVEL9K_DETECT_VIRT_BACKGROUND="252"
POWERLEVEL9K_DETECT_VIRT_FOREGROUND="${PL9K_TEXT_COLOR}"

POWERLEVEL9K_SSH_BACKGROUND="249"
POWERLEVEL9K_SSH_FOREGROUND="${PL9K_TEXT_COLOR}"

POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND="246"
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="${PL9K_TEXT_COLOR}"
POWERLEVEL9K_CONTEXT_REMOTE_BACKGROUND="246"
POWERLEVEL9K_CONTEXT_REMOTE_FOREGROUND="${PL9K_ORANGE}"
POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND="246"
POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND="${PL9K_RED}"

POWERLEVEL9K_IP_BACKGROUND="243"
POWERLEVEL9K_IP_FOREGROUND="${PL9K_TEXT_COLOR}"

POWERLEVEL9K_LOAD_NORMAL_BACKGROUND="240"
POWERLEVEL9K_LOAD_NORMAL_FOREGROUND="${PL9K_TEXT_COLOR}"
POWERLEVEL9K_LOAD_WARNING_BACKGROUND="240"
POWERLEVEL9K_LOAD_WARNING_FOREGROUND="${PL9K_ORANGE}"
POWERLEVEL9K_LOAD_CRITICAL_BACKGROUND="240"
POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND="${PL9K_RED}"

POWERLEVEL9K_RAM_BACKGROUND="240"
POWERLEVEL9K_RAM_FOREGROUND="${PL9K_TEXT_COLOR}"

POWERLEVEL9K_BATTERY_CHARGED_BACKGROUND="240"
POWERLEVEL9K_BATTERY_CHARGED_FOREGROUND="${PL9K_TEXT_COLOR}"
POWERLEVEL9K_BATTERY_DISCONNECTED_BACKGROUND="240"
POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND="${PL9K_BLUE}"
POWERLEVEL9K_BATTERY_CHARGING_BACKGROUND="240"
POWERLEVEL9K_BATTERY_CHARGING_FOREGROUND="${PL9K_GREEN}"
POWERLEVEL9K_BATTERY_LOW_BACKGROUND="240"
POWERLEVEL9K_BATTERY_LOW_FOREGROUND="${PL9K_RED}"

POWERLEVEL9K_VCS_CLEAN_BACKGROUND="237"
POWERLEVEL9K_VCS_CLEAN_FOREGROUND="${PL9K_TEXT_INVERSE_COLOR}"
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="237"
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="${PL9K_BLUE}"
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="237"
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="${PL9K_GREEN}"

POWERLEVEL9K_OS_ICON_BACKGROUND="252"
POWERLEVEL9K_OS_ICON_FOREGROUND="${PL9K_TEXT_COLOR}"

POWERLEVEL9K_VI_MODE_NORMAL_BACKGROUND="237"
POWERLEVEL9K_VI_MODE_NORMAL_FOREGROUND="${PL9K_BLUE}"
POWERLEVEL9K_VI_MODE_INSERT_BACKGROUND="237"
POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND="${PL9K_TEXT_COLOR}"

POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="234"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="${PL9K_TEXT_INVERSE_COLOR}"
POWERLEVEL9K_DIR_HOME_BACKGROUND="234"
POWERLEVEL9K_DIR_HOME_FOREGROUND="${PL9K_TEXT_INVERSE_COLOR}"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="234"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="${PL9K_TEXT_INVERSE_COLOR}"

POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND="243"
POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND="${PL9K_RED}"

POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="240"
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="${PL9K_TEXT_COLOR}"

POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND="237"
POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND="${PL9K_TEXT_COLOR}"

### ZPLUG PACKAGES ###
if [[ ! -d "$HOME/.zplug" ]]; then
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

source "$HOME/.zplug/init.zsh"

zplug "zplug/zplug", hook-build: "zplug --self-manage"

zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "mfaerevaag/wd", as:command, use:"wd.sh", hook-load:"wd() { . $ZPLUG_REPOS/mfaerevaag/wd/wd.sh }"
zplug "arzzen/calc.plugin.zsh"
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

# Candidates list
# fzf,

# Must load last.
zplug "zsh-users/zsh-syntax-highlighting"

if ! zplug check; then
    zplug install
fi

zplug load

### BANNER ###
if [[ -x "$(command -v screenfetch)" ]]; then
    screenfetch -d '-pkgs,wm,de,res,gtk;+disk' -E
fi

### LIBRARY ###
wifi_signal() {
    local signal=$(nmcli -t device wifi | grep '^*' | awk -F':' '{print $6}')
    local color="yellow"
    [[ $signal -gt 75 ]] && color="green"
    [[ $signal -lt 50 ]] && color="red"
    echo -n "%F{$color}\uf1eb" # \uf1eb is 
}

add-path() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

add-path "$HOME/bin/"
add-path "/sbin/"
add-path "/usr/sbin/"

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

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable color support of ls and also add handy aliases
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

if [[ -d "$HOME/.neovim-studio/" ]] && [[ -z "${NEOVIM_STUDIO_PROFILE_SOURCED}" ]]; then
    source "$HOME/.profile"

    if [[ -z "${NEOVIM_STUDIO_PROFILE_SOURCED}" ]]; then
        # Doesn't exist within the profile.
        export NEOVIM_STUDIO_PROFILE_SOURCED=1
    fi
fi

