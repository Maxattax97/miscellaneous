# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Exports
export EDITOR=/usr/bin/nano # For lightweight purposes.
export VISUAL=/usr/bin/nvim # For heavyweight purposes.
export PAGER='less'
export MANPAGER='less'
export BROWSER="google-chrome-stable '%' &"
export PATH=$PATH:$HOME/bin/
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

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

shopt -s histappend # append to the history file, don't overwrite it
shopt -s cdspell # automatically correct typos in directories when using cd
shopt -s nocaseglob # case insensitive directory search

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

_shrunkPrompt=""
_normalPrompt=""

if [ "$color_prompt" = yes ]; then
    _shrunkPrompt='\[\033[00m\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$\[$(tput sgr0)\]\[\033[00m\] '

    #PS1="${RESET}${debian_chroot:+($debian_chroot)}${LIGHTGREY}[${DARKGREY}\T${LIGHTGREY}] ${LIGHTGREEN}\u${DARKGREY}@${GREEN}\h${RESET}:${LIGHTBLUE}\w${RESET}\\$\[$(tput sgr0)\]${RESET} " # This string will not work, but is a more human readable version
    #PS1='\[\033[00m\]${debian_chroot:+($debian_chroot)}\[\033[00;37m\][\[\033[01;30m\]\T\[\033[00;37m\]] \[\033[01;32m\]\u\[\033[01;30m\]@\[\033[00;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$\[$(tput sgr0)\]\[\033[00m\] '

    # [C|R|H|S] = [CPU|RAM|HDD|SSH]

    PS1='\[\033[00m\]${debian_chroot:+($debian_chroot)}'
    if [ "$time_indicator" = yes ]; then
        PS1=${PS1}'\[\033[00;37m\][\[\033[01;30m\]\t\[\033[00;37m\]]'
    fi
#     if [ "$resource_indicator" = yes ]; then
#         sep="\[${LIGHTGREY}\]"
#         connectionSecurity=""
#         cpuLoad=""
#         ramLoad=""
#         hddLoad=""
#
#
#         # CPU Load
#         nCpu=$(grep -c 'processor' /proc/cpuinfo)
#         sLoad=$(( 100 * $nCpu ))
#         local mLoad=$(( 200 *${nCpu} ))
#         local lLoad=$(( 400*${nCpu} ))
#
#         load() {
#             local SYSLOAD=$(cut -d " " -f1 /proc/loadavg | tr -d '.')
#             echo $((10#$SYSLOAD))
#         }
#
#         # Returns a color indicating system load.
#         load_color() {
#             local SYSLOAD=$(load)
#             if [ ${SYSLOAD} -gt ${lLoad} ]; then
#                 echo -en "\[${RED}\]"
#             elif [ ${SYSLOAD} -gt ${MLOAD} ]; then
#                 echo -en "\[${LIGHTRED}\]"
#             elif [ ${SYSLOAD} -gt ${SLOAD} ]; then
#                 echo -en "\[${YELLOW}\]"
#             else
#                 echo -en "\[${GREEN}\]"
#             fi
#         }
#
#         cpuLoad=$(load_color)
#
#         # CPU Load
#         function load()
#         {
#             local SYSLOAD=$(cut -d " " -f1 /proc/loadavg | tr -d '.')
#             # System load of the current host.
#             echo $((10#$SYSLOAD))       # Convert to decimal.
#         }
#
#         local nCpu=$(grep -c 'processor' /proc/cpuinfo)
#         local sLoad=$(( 100*${nCpu} ))
#         local mLoad=$(( 200*${nCpu} ))
#         local lLoad=$(( 400*${nCpu} ))
#
#         local SYSLOAD=$(cut -d " " -f1 /proc/loadavg | tr -d '.')
#         SYSLOAD=$(( 10#$SYSLOAD ))
#
#         if [ ${SYSLOAD} -gt ${lLoad} ]; then
#             cpuLoad="\[${RED}\]"
#         elif [ ${SYSLOAD} -gt ${mLoad} ]; then
#             cpuLoad="\[${LIGHTRED}\]"
#         elif [ ${SYSLOAD} -gt ${sLoad} ]; then
#             cpuLoad="\[${YELLOW}\]"
#         else
#             cpuLoad="\[${GREEN}\]"
#         fi
#
#         # RAM Load
#         ramPercent=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
#         ramPercent=$(( 10#
#         if [ ${ramPercent} -gt ${lLoad} ]; then
#             cpuLoad="\[${RED}\]"
#         elif [ ${SYSLOAD} -gt ${mLoad} ]; then
#             cpuLoad="\[${LIGHTRED}\]"
#         elif [ ${SYSLOAD} -gt ${sLoad} ]; then
#             cpuLoad="\[${YELLOW}\]"
#         else
#             cpuLoad="\[${GREEN}\]"
#         fi
#
#         # Free HDD space
#
#         # Secure Connection
#         if [ -n "${SSH_CONNECTION}" ]; then
#             connectionSecurity="\[${GREEN}\]"        # Connected remotely via ssh (secure).
#         elif [[ "${DISPLAY%%:0*}" != "" ]]; then
#             connectionSecurity="\[${RED}\]"          # Connected remotely not via ssh (insecure).
#         else
#             connectionSecurity="\[${CYAN}\]"         # Connected on local machine.
#         fi
#
#
#         PS1=${PS1}"\[\033[00;37m\][\[\033[01;30m\]${cpuLoad}C${sep}|${ramLoad}R${sep}|H${sep}|${connectionSecurity}S\[\033[00;37m\]]"
#     fi
    PS1=${PS1}' \[\033[01;32m\]\u\[\033[01;30m\]@\[\033[00;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$\[$(tput sgr0)\]\[\033[00m\] '

    _normalPrompt=${PS1}

    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ ' # Ubuntu's original
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset time_indicator resource_indicator color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

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

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
        function command_not_found_handle {
                # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
                   /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found/command-not-found ]; then
                   /usr/share/command-not-found/command-not-found -- "$1"
                   return $?
				elif [ -x /usr/share/doc/pkgfile/command-not-found.bash ]; then
					# For Arch based systems (pacman -S pkgfile command-not-found)
					/usr/share/doc/pkgfile/command-not-found.bash -- "$1"
					return $?
                else
                   printf "%s: command not found\n" "$1" >&2
                   return 127
                fi
        }
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

# Display the last two directories relative to the working directory.

#export PS1="\[\033[0;32m\]\u@\h \[\033[33m\]\$(pwd)\[\033[0m\] \$ ";

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

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

# Banner
if [ "$enable_banner" = yes ]; then
    #clear; clear
    if hash screenfetch 2>/dev/null; then
        screenfetch -E
    else
        echo -e "${LIGHTBLUE}${BOLD}Welcome back, $USER!${RESET}"
        if hash fortune 2>/dev/null; then
            fortune -s
        fi
        echo ""
    fi
fi
unset enable_banner

if [ -d "/home/$USER/anaconda3/bin/" ]; then
    export PATH="/home/$USER/anaconda3/bin:$PATH"
fi
