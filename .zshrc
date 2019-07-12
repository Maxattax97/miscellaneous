config_help=false
config_benchmark=false
zshrc_low_power=false
zshrc_dropping_mode=false

zshrc_benchmark_start() {
    if ( $config_benchmark ); then
        zmodload zsh/zprof
    fi
}

zshrc_benchmark_stop() {
    if ( $config_benchmark ); then
        zprof > "${HOME}/.zprof.log"
        echo "ZSH profiling log saved to ${HOME}/.zprof.log"
    fi
}

zshrc_probe() {
    case $TERM in
        *linux*)
            zshrc_low_power=true
            echo "Low power mode enabled."
            ;;
        *vt100*)
            zshrc_low_power=true
            echo "Low power mode enabled."
            ;;
    esac
}

zshrc_enter_tmux() {
    if [[ -n "$DISPLAY" ]] && [[ -x "$(command -v tmux)" ]]; then
        local session_count=$(tmux ls | grep "^Main" | wc -l)
        if [[ "$session_count" == "0" ]]; then
            # echo "Launching tmux base session $base_session ..."
            tmux -2 new-session -s Main \; \
                send-keys 'forever gotop' C-m \;
        else
            # Make sure we are not already in a tmux session
            if [[ -z "$TMUX" ]]; then
                # Session id is date and time to prevent conflict
                local session_id="$(date +%H%M%S)"

                # Create a new session (without attaching it) and link to base session
                # to share windows
                tmux -2 new-session -d -t Main -s "$session_id"
                # if [[ "$2" == "1" ]]; then
                #     # Create a new window in that session
                #     tmux new-window
                # fi

                # Attach to the new session & kill it once orphaned
                tmux -2 attach-session -t "$session_id" \; set-option destroy-unattached
            else
                zshrc_display_banner
            fi
        fi

        # test -z "$TMUX" && (tmux attach || tmux new-session -s "Main")
    else
        zshrc_display_banner
    fi
}

# Adapted from oh-my-zsh: https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/termsupport.zsh
zshrc_auto_window_title() {
    DISABLE_AUTO_TITLE=false

    function title {
        emulate -L zsh
        setopt prompt_subst

        [[ "$EMACS" == *term* ]] && return

        # if $2 is unset use $1 as default
        # if it is set and empty, leave it as is
        : ${2=$1}

        case "$TERM" in
            cygwin|xterm*|putty*|rxvt*|ansi)
                print -Pn "\e]2;$2:q\a" # set window name
                print -Pn "\e]1;$1:q\a" # set tab name
                ;;
            screen*|tmux*)
                print -Pn "\ek$1:q\e\\" # set screen hardstatus
                ;;
            *)
                if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
                    print -Pn "\e]2;$2:q\a" # set window name
                    print -Pn "\e]1;$1:q\a" # set tab name
                else
                    # Try to use terminfo to set the title
                    # If the feature is available set title
                    if [[ -n "$terminfo[fsl]" ]] && [[ -n "$terminfo[tsl]" ]]; then
                        echoti tsl
                        print -Pn "$1"
                        echoti fsl
                    fi
                fi
                ;;
        esac
    }

    ZSH_THEME_TERM_TAB_TITLE_IDLE="%15<..<%~%<<" #15 char left truncated PWD
    ZSH_THEME_TERM_TITLE_IDLE="%n@%m: %~"
    # Avoid duplication of directory in terminals with independent dir display
    if [[ "$TERM_PROGRAM" == Apple_Terminal ]]; then
        ZSH_THEME_TERM_TITLE_IDLE="%n@%m"
    fi

    # Runs before showing the prompt
    function omz_termsupport_precmd {
        emulate -L zsh

        if [[ "$DISABLE_AUTO_TITLE" == true ]]; then
            return
        fi

        title $ZSH_THEME_TERM_TAB_TITLE_IDLE $ZSH_THEME_TERM_TITLE_IDLE
    }

    # Runs before executing the command
    function omz_termsupport_preexec {
        emulate -L zsh
        setopt extended_glob

        if [[ "$DISABLE_AUTO_TITLE" == true ]]; then
            return
        fi

        # cmd name only, or if this is sudo or ssh, the next cmd
        local CMD=${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}
        local LINE="${2:gs/%/%%}"

        title '$CMD' '%100>...>$LINE%<<'
    }

    precmd_functions+=(omz_termsupport_precmd)
    preexec_functions+=(omz_termsupport_preexec)


    # Keep Apple Terminal.app's current working directory updated
    # Based on this answer: https://superuser.com/a/315029
    # With extra fixes to handle multibyte chars and non-UTF-8 locales

    if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]] && [[ -z "$INSIDE_EMACS" ]]; then
        # Emits the control sequence to notify Terminal.app of the cwd
        # Identifies the directory using a file: URI scheme, including
        # the host name to disambiguate local vs. remote paths.
        function update_terminalapp_cwd() {
            emulate -L zsh

            # Percent-encode the pathname.
            local URL_PATH="$(omz_urlencode -P $PWD)"
            [[ $? != 0 ]] && return 1

            # Undocumented Terminal.app-specific control sequence
            printf '\e]7;%s\a' "file://$HOST$URL_PATH"
        }

        # Use a precmd hook instead of a chpwd hook to avoid contaminating output
        precmd_functions+=(update_terminalapp_cwd)
        # Run once to get initial cwd set
        update_terminalapp_cwd
    fi
}

# Adapted from oh-my-zsh: https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/completion.zsh
zshrc_setup_completion() {
    # zstyle ':completion:*' auto-description '\ %d'

    # Removed: _list
    # Was ruining menucomplete
    # zstyle ':completion:*' completer _expand _complete _ignored _match _correct _approximate _prefix
    # zstyle ':completion:*' format '> Completing %d ...'
    # zstyle ':completion:*' insert-unambiguous true
    zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}
    # zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
    # zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'l:|=* r:|=*'
    # zstyle ':completion:*' max-errors 4
    # zstyle ':completion:*' menu select=1
    # zstyle ':completion:*' original true
    # zstyle ':completion:*' preserve-prefix '//[^/]##/'
    # zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
    zstyle ':completion:*' squeeze-slashes true
    # zstyle ':completion:*' verbose true
    # zstyle ':completion:*' rehash true

    zmodload -i zsh/complist

    WORDCHARS=''

    unsetopt menu_complete   # do not autoselect the first completion entry
    unsetopt flowcontrol
    setopt auto_menu         # show completion menu on successive tab press
    setopt complete_in_word
    setopt always_to_end

    # should this be in keybindings?
    bindkey -M menuselect '^o' accept-and-infer-next-history
    zstyle ':completion:*:*:*:*:*' menu select

    # case insensitive (all), partial-word and substring completion
    # if [[ "$CASE_SENSITIVE" = true ]]; then
    #     zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'
    # else
    #     if [[ "$HYPHEN_INSENSITIVE" = true ]]; then
            zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
    #     else
    #         zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
    #     fi
    # fi
    # unset CASE_SENSITIVE HYPHEN_INSENSITIVE

    # Complete . and .. special directories
    zstyle ':completion:*' special-dirs true

    # zstyle ':completion:*' list-colors ''
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

    # if [[ "$OSTYPE" = solaris* ]]; then
    #     zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm"
    # else
        zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
    # fi

    # disable named-directories autocompletion
    zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

    # Use caching so that commands like apt and dpkg complete are useable
    zstyle ':completion::complete:*' use-cache 1
    zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR

    # Don't complete uninteresting users
    zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'

    # ... unless we really want to.
    zstyle '*' single-ignored show

    # if [[ $COMPLETION_WAITING_DOTS = true ]]; then
        expand-or-complete-with-dots() {
            # toggle line-wrapping off and back on again
            [[ -n "$terminfo[rmam]" && -n "$terminfo[smam]" ]] && echoti rmam
            print -Pn "%{%F{red}......%f%}"
            [[ -n "$terminfo[rmam]" && -n "$terminfo[smam]" ]] && echoti smam

            zle expand-or-complete
            zle redisplay
        }
        zle -N expand-or-complete-with-dots
        bindkey "^I" expand-or-complete-with-dots
    # fi


    zstyle :compinstall filename '/home/max/.zshrc'
}

zshrc_autoload() {
    autoload -Uz compinit
    compinit

    autoload -Uz promptinit
    promptinit

    autoload -Uz edit-command-line

    if ( $config_help ); then
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
}

zshrc_source() {
    # Now using zshrc_batsdevrc.
    #if [[ -e "$HOME/.batsrc" ]]; then
        #source "$HOME/.batsrc"
    #fi

    if [[ -d "$HOME/.neovim-studio/" ]] && [[ -z "${NEOVIM_STUDIO_PROFILE_SOURCED}" ]]; then
        source "$HOME/.profile"

        if [[ -z "${NEOVIM_STUDIO_PROFILE_SOURCED}" ]]; then
            # Doesn't exist within the profile.
            export NEOVIM_STUDIO_PROFILE_SOURCED=1
        fi
    fi

    if [ -f "${HOME}/.zplug/repos/junegunn/fzf/shell/key-bindings.zsh" ]; then
        # fzf searches for this, so leave it as it is.
        [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    fi

    if [[ -e "$HOME/src/robobenklein-config/zsh/plunks/rtabfunc.zsh" ]]; then
        source "$HOME/src/robobenklein-config/zsh/plunks/rtabfunc.zsh"
    fi

    if [ -s "$HOME/.luaver/luaver" ]; then
        source "$HOME/.luaver/luaver"
    fi
}

zshrc_set_options() {
    HISTFILE=~/.histfile
    HISTSIZE=1000
    SAVEHIST=10000

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
    setopt appendhistory
    setopt autocd
    setopt beep
    setopt notify

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
}

zshrc_powerlevel9k() {
    POWERLEVEL9K_MODE="nerdfont-complete"
    POWERLEVEL9K_PROMPT_ON_NEWLINE=false
    #POWERLEVEL9K_RPROMPT_ON_NEWLINE=false

    # Intriguing elements:
    # detect_virt

    # Featureful but slow variant:
    # POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(time context ip load ram_joined battery_joined vcs newline os_icon ssh vi_mode dir dir_writable)
    # POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(background_jobs command_execution_time)

    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(time virtualenv vcs newline os_icon ssh dir dir_writable)
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(background_jobs command_execution_time)

    POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
    POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=""
    POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=""

    POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=5
    POWERLEVEL9K_VI_INSERT_MODE_STRING="I"
    POWERLEVEL9K_VI_COMMAND_MODE_STRING="N"

    POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
    POWERLEVEL9K_SHORTEN_DELIMITER=""
    POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

    # Colors
    POWERLEVEL9K_COLOR_SCHEME="dark"
    PL9K_TEXT_COLOR="232"
    PL9K_TEXT_INVERSE_COLOR="255"
    PL9K_BLUE="033"
    # PL9K_BLUE="075"
    # PL9K_GREEN="046"
    PL9K_GREEN="071"
    # PL9K_RED="196"
    PL9K_RED="202"
    # PL9K_ORANGE="214"
    PL9K_ORANGE="172"

    POWERLEVEL9K_TIME_BACKGROUND="255"
    POWERLEVEL9K_TIME_FOREGROUND="${PL9K_TEXT_COLOR}"

    POWERLEVEL9K_DETECT_VIRT_BACKGROUND="249"
    POWERLEVEL9K_DETECT_VIRT_FOREGROUND="${PL9K_TEXT_COLOR}"

    POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND="246"
    POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="${PL9K_TEXT_COLOR}"
    POWERLEVEL9K_CONTEXT_SUDO_BACKGROUND="246"
    POWERLEVEL9K_CONTEXT_SUDO_FOREGROUND="${PL9K_TEXT_COLOR}"
    POWERLEVEL9K_CONTEXT_REMOTE_BACKGROUND="246"
    POWERLEVEL9K_CONTEXT_REMOTE_FOREGROUND="${PL9K_TEXT_COLOR}"
    POWERLEVEL9K_CONTEXT_REMOTE_SUDO_BACKGROUND="246"
    POWERLEVEL9K_CONTEXT_REMOTE_SUDO_FOREGROUND="${PL9K_TEXT_COLOR}"
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
    POWERLEVEL9K_BATTERY_CHARGED_FOREGROUND="${PL9K_TEXT_INVERSE_COLOR}"
    POWERLEVEL9K_BATTERY_DISCONNECTED_BACKGROUND="240"
    POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND="${PL9K_BLUE}"
    POWERLEVEL9K_BATTERY_CHARGING_BACKGROUND="240"
    POWERLEVEL9K_BATTERY_CHARGING_FOREGROUND="${PL9K_GREEN}"
    POWERLEVEL9K_BATTERY_LOW_BACKGROUND="240"
    POWERLEVEL9K_BATTERY_LOW_FOREGROUND="${PL9K_RED}"

    POWERLEVEL9K_VIRTUALENV_BACKGROUND="240"
    POWERLEVEL9K_VIRTUALENV_FOREGROUND="${PL9K_TEXT_INVERSE_COLOR}"

    POWERLEVEL9K_VCS_CLEAN_BACKGROUND="237"
    POWERLEVEL9K_VCS_CLEAN_FOREGROUND="${PL9K_TEXT_INVERSE_COLOR}"
    POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="237"
    POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="${PL9K_BLUE}"
    POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="237"
    POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="${PL9K_GREEN}"

    POWERLEVEL9K_OS_ICON_BACKGROUND="252"
    POWERLEVEL9K_OS_ICON_FOREGROUND="${PL9K_TEXT_COLOR}"

    POWERLEVEL9K_SSH_BACKGROUND="243"
    POWERLEVEL9K_SSH_FOREGROUND="${PL9K_TEXT_COLOR}"

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

    if (( ${+functions[rtab]} )); then
        # POWERLEVEL9K_CUSTOM_RTAB_DIR="echo \${RTAB_PWD}"
        POWERLEVEL9K_CUSTOM_RTAB_DIR="echo \$(rtab -l -t)"
        POWERLEVEL9K_CUSTOM_RTAB_DIR_FOREGROUND="${POWERLEVEL9K_DIR_DEFAULT_FOREGROUND}"
        POWERLEVEL9K_CUSTOM_RTAB_DIR_BACKGROUND="${POWERLEVEL9K_DIR_DEFAULT_BACKGROUND}"
        # TODO: Make this dynamically replace dir with custom_rtab_dir
        POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(time vcs newline os_icon ssh custom_rtab_dir dir_writable)
        # typeset -a chpwd_functions
        # chpwd_functions+=(_rtab_pwd_update)
        # function _rtab_pwd_update() {
            # export RTAB_PWD=$(rtab -l -t)
        # }
        # _rtab_pwd_update
    fi

    # typeset -gA p10k_opts
    # p10k_opts=(
        # p10ks_cwd ';;;;rtab;-t;-l'
    # )

    POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="240"
    POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="${PL9K_TEXT_COLOR}"

    POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND="237"
    POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND="${PL9K_TEXT_COLOR}"

    if ( $zshrc_low_power ); then
        POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=$']'
        POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=$'['
    fi
}

zshrc_raw_prompt() {
    prompt adam2
}

zshrc_zplug() {
    if [[ ! -d "$HOME/.zplug" ]]; then
        curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
    fi

    if [[ -d "$HOME/.zplug" ]]; then
        source "$HOME/.zplug/init.zsh"

        zplug "zplug/zplug", hook-build: "zplug --self-manage"

        zplug "zsh-users/zsh-history-substring-search"
        zplug "zsh-users/zsh-autosuggestions"
        zplug "zsh-users/zsh-completions"
        zplug "mfaerevaag/wd", as:command, use:"wd.sh", \
            hook-load:"wd() { . $ZPLUG_REPOS/mfaerevaag/wd/wd.sh }"
        zplug "arzzen/calc.plugin.zsh"
        zplug "chrissicool/zsh-256color"
        zplug "hlissner/zsh-autopair", defer:2

        # Improved bash compatibility
        # zplug "chrissicool/zsh-bash"

        zplug "stackexchange/blackbox"
        zplug "tarrasch/zsh-command-not-found"

        zplug "junegunn/fzf", as:command, rename-to:fzf, \
            hook-build:"rm ~/.fzf.zsh; ./install --all && source ${HOME}/.fzf.zsh"

        # Install fzf or fzy
        zplug "b4b4r07/enhancd", use:init.sh, hook-load:"ENHANCD_DISABLE_DOT=1"

        # git log = glo; git diff = gd; git add = ga; git ignore = gi
        zplug "wfxr/forgit", defer:1

        export NVM_LAZY_LOAD=true
        export NVM_CACHE_LOAD=true
        # zplug "lukechilds/zsh-nvm"
        zplug "maxattax97/zsh-nvm"

        zplug "gko/ssh-connect", as:command

        if ( ! "$zshrc_low_power" ); then
            zplug "bhilburn/powerlevel9k", at:master, use:powerlevel9k.zsh-theme
        fi

        # zplug "ael-code/zsh-colored-man-pages"

        zplug "supercrabtree/k"

        zplug "psprint/zsh-navigation-tools"

        # Must load last.
        # zplug "zsh-users/zsh-syntax-highlighting"
        zplug "zdharma/fast-syntax-highlighting", defer:3

        if ! zplug check; then
            zplug install
        fi

        zplug load
    else
        echo "Failed to load zplug plugins."
    fi
}

zshrc_display_banner() {
    if ( ! "$zshrc_low_power" ); then
        if [[ -x "$(command -v neofetch)" ]]; then
            neofetch --disable "packages"
        elif [[ -x "$(command -v screenfetch)" ]]; then
            screenfetch -d '-pkgs,wm,de,res,gtk;+disk' -E
            echo
        fi

        if [[ -x "$(command -v mikaelasay)" ]] && [[ "$CHASSIS" != "laptop" ]]; then
            mikaelasay
            echo
        fi
    else
        echo "Entering low power mode ..."
        echo
    fi
}

zshrc_set_path() {
    add_path() {
        if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
            export PATH="${PATH:+"$PATH:"}$1"
        fi
    }

    add_path "${HOME}/bin/"
    add_path "${HOME}/.local/bin/"
    add_path "/sbin/"
    add_path "/usr/sbin/"
    add_path "${HOME}/.SpaceVim/bin/"
    add_path "${HOME}/src/depot_tools/"
    add_path "${HOME}/.anaconda2/bin/"
    add_path "${HOME}/anaconda2/bin/"
    add_path "${HOME}/src/cquery/build/release/bin/"
    add_path "${HOME}/.adb-fastboot/platform-tools/"
    add_path "${HOME}/.cargo/bin/"
    add_path "/usr/local/go/bin/"
    add_path "${HOME}/.gem/ruby/2.6.0/bin/"
    add_path "/usr/lib/gem/ruby/2.6.0/bin/"
    add_path "$HOME/.yarn/bin"
    add_path "$HOME/.config/yarn/global/node_modules/.bin"

    if [ -n "$GOPATH" ]; then
        add_path "${GOPATH}/bin/"
    else
        add_path "${HOME}/go/bin/"
    fi
}

zshrc_load_library() {
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

    # Login and play/watch Nethack from anywhere.
    nethack() {
        telnet nethack.alt.org
    }

    # Aliases, functions, commands, etc.

    # From https://github.com/xvoland/Extract/blob/master/extract.sh
    # TODO: Add support for cpio, ar, iso
    # TODO: Add progress bar, remove verbose flag
    inflate() {
        if [ -z "$1" ]; then
            # display usage if no parameters given
            echo "Usage: inflate <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
            echo "       inflate <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
            return 1
        else
            for n in $@
            do
            if [ -f "$n" ] ; then
                case "${n%,}" in
                    *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                        tar xvf "$n"
                        ;;
                    *.lzma)
                        unlzma ./"$n"
                        ;;
                    *.bz2)
                        bunzip2 ./"$n"
                        ;;
                    *.rar)
                        unrar x -ad ./"$n"
                        ;;
                    *.gz)
                        gunzip ./"$n"
                        ;;
                    *.zip)
                        unzip ./"$n"
                        ;;
                    *.z)
                        uncompress ./"$n"
                        ;;
                    *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                        7z x ./"$n"
                        ;;
                    *.xz)
                        unxz ./"$n"
                        ;;
                    *.exe)
                        cabextract ./"$n"
                        ;;
                    *)
                        echo "inflate: '$n' - unknown archive method"
                        return 1
                        ;;
                esac
            else
                echo "'$n' - file does not exist"
                return 1
            fi
            done
        fi
    }

    squeeze() {
        if [ -z "$1" ]; then
            # display usage if no parameters given
            echo "Usage: squeeze <path/directory> <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|tar.bz2|tar.gz|tar.xz>"
            return 1
        else
            input=$1
            output=$2
            # TODO: Add support for single files (in addition to directories).
            if [ -d "$input" ] || [ -f "$input" ] ; then
                case "${output%,}" in
                    *.tar)
                        tar cf "$output" "$input"
                        ;;
                    *.tar.gz|*.tgz)
                        tar zcf "$output" "$input"
                        ;;
                    *.tar.bz2|*.tbz2)
                        tar jcf "$output" "$input"
                        ;;
                    *.tar.xz|*.txz)
                        tar Jcf "$output" "$input"
                        ;;
                    *.tar.lzma|*.tlzma)
                        tar cf "$output" --lzma "$input"
                        ;;
                    *.bz2)
                        bzip2 ./"$n"
                        ;;
                    # TODO: Finish these below.
                    *.rar)
                        rar x -ad ./"$n"
                        ;;
                    *.gz)
                        gzip ./"$n"
                        ;;
                    *.zip)
                        zip ./"$n"
                        ;;
                    *.z)
                        compress ./"$n"
                        ;;
                    *.7z)
                        7z a ./"$n"
                        ;;
                    *.xz)
                        xz ./"$n"
                        ;;
                    *)
                        echo "squeeze: '$output' - unknown archive method"
                        return 1
                        ;;
                esac
            else
                echo "'$input' - file does not exist"
                return 1
            fi
        fi
    }

    # Host the current directory via HTTP
    hostdir() {
        if type "python3" > /dev/null 2>&1; then
            python3 -m http.server
        elif type "python" > /dev/null 2>&1; then
            python -m SimpleHTTPServer
        fi
    }

    # Type a string of text letter by letter.
    typewriter() {
        local message="$1"
        local i=0
        while [ "$i" -lt "${#message}" ]; do
            echo -n "${message:$i:1}"
            sleep 0.05
            i="$((i + 1))"
        done

        printf "\n"
    }

    translate() {
        gawk -f <(curl -Ls git.io/translate) -- -shell
    }

    repair_nvidia() {
        if type "zypper" > /dev/null 2>&1; then
            sudo zypper in -f nvidia-gfxG05-kmp-default
        fi
    }

    mapscii() {
        telnet mapscii.me
    }

    bomb() {
        bomb | bomb &
    }

    tone() {
        (speaker-test --frequency $1 --test sine > /dev/null 2>&1) &
        pid=$!
        sleep 0.${2}s
        kill -13 $pid
    }

    waitonline() {
        local target=${1:-8.8.8.8}
        echo "Waiting for online access ..."
        failing=true
        while "$failing"; do
            ping "$target" -c 1 -W 2 > /dev/null 2>&1
            success="$?"
            if [ "$success" -eq 0 ]; then
                printf "\n"
                echo "Internet access has been restored!"
                notify-send --urgency=normal --icon=gtk-network "Online" "Internet access has been restored."
                tone 500 400; tone 1000 400; tone 2000 400
                failing=false
            else
                printf "."
                sleep 1
            fi
        done
    }

    dockerclean() {
        echo "Cleaning Docker images and containers ..."
        sudo docker rm $(sudo docker ps -a -q)
        sudo docker rmi $(docker images -q)
        echo "Docker cleaned."
    }

    aes256encrypt() {
        if [ -e "$1" ]; then
            openssl enc -in "${1}" -out "${1}.aes256" -e -aes256
        else
            echo "Cannot find file ${1}" 1>&2
        fi
    }

    aes256decrypt() {
        if [ -e "$1" ]; then
            openssl enc -in "${1}" -out "${1}.decrypted" -d -aes256
        else
            echo "Cannot find file ${1}" 1>&2
        fi
    }

    infect() {
        local target_host="$1"
        local target_port="${2:-22}"
        local target_user="${3}"

        local host_user_str=""
        if [ -n "$target_user" ]; then
            host_user_str="$target_user@"
        fi

        mkdir -p /tmp/infect
        cp ~/.zshrc /tmp/infect/
        cp ~/.bashrc /tmp/infect/
        cp ~/.tmux.conf /tmp/infect/
        cp -r ~/.config/nvim/ /tmp/infect/
        cp -r ~/.config/ranger/ /tmp/infect/
        cp ~/src/miscellaneous/scripts/infect.sh /tmp/.infect.sh
        echo "source ~/.config/nvim/init.vim" > /tmp/infect/.vimrc

        tar -C /tmp/infect -czf /tmp/.infect.tar.gz .

        scp -P "${target_port}" /tmp/.infect.tar.gz /tmp/.infect.sh "${target_host}:~/"
        ssh "${target_user}${target_host}" -p "${target_port}" "/home/${target_user:-${USER}}/.infect.sh"
    }

    # TODO: bats.infect for those annoying low level AATS RMCU's.


    forever() {
        cmd_base="$1"
        cmd_args=$@

        while true; do
            $cmd_args
            exit_code=$?
            if [ "$exit_code" != 0 ]; then
                echo "$1 has crashed, restarting ..."
                sleep 1
            else
                echo "Exiting due to success exit code"
                return
            fi
        done
    }

    d2h() {
        for dec in "${@:-$(</dev/stdin)}"; do
            printf "0x%x\n" "${dec}"
        done
    }

    h2d() {
        for hex in "${@:-$(</dev/stdin)}"; do
            if [[ "${hex:0:2}" != "0x" ]]; then
                hex="0x${hex}"
                printf "$hex -> " > /dev/stderr
            fi
            printf "%d\n" "${hex}"
        done
    }

    alias x2d='h2d'
    alias d2x='d2h'

    # TODO: Make this filter (but not destroy) any input.
    humanize() {
        for B in "${@:-$(</dev/stdin)}"; do
            if [[ "${hex:0:2}" != "0x" ]]; then
                B="$(h2d "${B}")"
            fi
            [ $B -lt 1024 ] && echo ${B} B && break
            KB=$(((B+512)/1024))
            [ $KB -lt 1024 ] && echo ${KB} KiB && break
            MB=$(((KB+512)/1024))
            [ $MB -lt 1024 ] && echo ${MB} MiB && break
            GB=$(((MB+512)/1024))
            [ $GB -lt 1024 ] && echo ${GB} GiB && break
            echo $(((GB+512)/1024)) TiB
        done
    }

    dehumanize() {
        for v in "${@:-$(</dev/stdin)}"; do
            echo $v | awk \
            'BEGIN{IGNORECASE = 1}
            function printpower(n,b,p) {printf "%u\n", n*b^p; next}
            /[0-9]$/{print $1;next};
            /K(iB)?$/{printpower($1,  2, 10)};
            /M(iB)?$/{printpower($1,  2, 20)};
            /G(iB)?$/{printpower($1,  2, 30)};
            /T(iB)?$/{printpower($1,  2, 40)};
            /KB$/{    printpower($1, 10,  3)};
            /MB$/{    printpower($1, 10,  6)};
            /GB$/{    printpower($1, 10,  9)};
            /TB$/{    printpower($1, 10, 12)}'
        done
    }
}

zshrc_set_aliases() {
    # Add an "alert" alias for long running commands.  Use like so:
    #   sleep 10; alert
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

    # Enable color support of ls and also add handy aliases.
    export CLICOLOR=1 # For macOS VM's ... Dumb it's not enabled by default.
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
    #if [[ -x "$(command -v tmux-next)" ]]; then
        #alias tmux='tmux-next -2'
    #else
        alias tmux='tmux -2'
    #fi

    # Clear color codes before clearing:
    alias clear='echo -e "\e[0m" && clear'

    # Typical rsync command
    alias relocate='rsync -avzh --info=progress2'

    # Add progress indicator because I always forget.
    alias dd='dd status=progress'
    alias sudo dd='sudo dd status=progress'

    alias gpg='gpg2 --with-subkey-fingerprints'
}

zshrc_set_default_programs() {

    # For heavyweight purposes.
    if [[ -x "$(command -v nvim)" ]]; then
        export VISUAL="/usr/bin/nvim"
        if [[ -d "${HOME}/.SpaceVim" ]]; then
            alias vim="nvim"
        fi
    elif [[ -x "$(command -v vim)" ]]; then
        export VISUAL="/usr/bin/vim"
        alias nvim="vim"
    else
        export VISUAL="/usr/bin/nano"
    fi

    # For lightweight purposes.
    export EDITOR="$VISUAL"

    export PAGER="less"
    export MANPAGER="less"

    if [[ -x "$(command -v firefox)" ]]; then
        export BROWSER="firefox"
    elif [[ -x "$(command -v chromium)" ]]; then
        export BROWSER="chromium"
    elif [[ -x "$(command -v google-chrome-stable)" ]]; then
        export BROWSER="google-chrome-stable"
    fi

    if [[ -x "$(command -v urxvt-256color)" ]]; then
        export TERMINAL="$(which urxvt-256color)"
    elif [[ -x "$(command -v konsole)" ]]; then
        export TERMINAL="$(which konsole)"
    fi

    export P4IGNORE="/home/max/Perforce/mocull/Engineering/Software/Linux/Code/.p4ignore"
}

zshrc_set_environment_variables() {

    if [[ "$(uname)" != "Darwin" ]]; then
        CPU_CORES="$(grep "^core id" /proc/cpuinfo | sort -u | wc -l)"
        CPU_THREADS="$(grep "^processor" /proc/cpuinfo | sort -u | wc -l)"
    fi

    if [[ -d "${HOME}/Perforce/mocull/Engineering/Software/Linux/Code/AATSV4/Lib" ]]; then
        export NODE_PATH="${NODE_PATH}:${HOME}/Perforce/mocull/Engineering/Software/Linux/Code/AATSV4/Lib"
    fi

    if [[ -s "${HOME}/Perforce/mocull/Engineering/Software/Linux/Code/.p4ignore" ]]; then
        export P4IGNORE="${HOME}/Perforce/mocull/Engineering/Software/Linux/Code/.p4ignore"
    fi

    # >>> conda init >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$(CONDA_REPORT_ERRORS=false '/home/max/.anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
    if [ $? -eq 0 ]; then
        \eval "$__conda_setup"
    else
        if [ -f "${HOME}/.anaconda3/etc/profile.d/conda.sh" ]; then
            . "${HOME}/.anaconda3/etc/profile.d/conda.sh"
            CONDA_CHANGEPS1=false conda activate base
        else
            \export PATH="${PATH}:${HOME}/.anaconda3/bin"
            \export PATH="${PATH}:${HOME}/anaconda3/bin"
        fi
    fi
    unset __conda_setup
    # <<< conda init <<<

    if [[ -d "/usr/lib/oracle/12.1/client64" ]]; then
        export ORACLE_HOME="/usr/lib/oracle/12.1/client64"
        export PATH="${PATH}:${ORACLE_HOME}/bin"
        export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${ORACLE_HOME}/lib"
    fi

    # Gentoo users say number of threads + 1 -- this fills out the maximal amount of CPU usage.
    # Number of cores alone leaves enough CPU to process other things... like a desktop environment.
    export MAKEFLAGS="${MAKEFLAGS} -j${CPU_THREADS}"
    export NUMCPU="${CPU_THREADS}"

    # Get the physical form factor of the machine.
    if [[ "$(uname)" != "Darwin" ]]; then
        local chassis_type="$(cat /sys/class/dmi/id/chassis_type)"
        local chassis_name=""

        case "$chassis_type" in
            8|9|10|14)
                chassis_name="laptop"
                ;;
            3|4|5|6|7|12|13|16|17|18|19|20|21|22|23|24)
                chassis_name="desktop"
                ;;
            *)
                chassis_name="unknown"
                ;;
        esac
    fi

    export CHASSIS="$chassis_name"
}

zshrc_batsdevrc() {
    if [[ -s "$HOME/Perforce/mocull/Engineering/Software/Linux/Code/batsdevrc" ]]; then
        # Proxy all functions through bash because Zsh doesn't play nice when sourcing them.

        bats_run() {
            echo "> source $HOME/Perforce/mocull/Engineering/Software/Linux/Code/batsdevrc && $*"
            bash -c "source $HOME/Perforce/mocull/Engineering/Software/Linux/Code/batsdevrc && $*"
        }

        bats.p4v() {
            bats_run "bats.p4v $*"
        }

        bats.update-docker-containers() {
            bats_run "bats.update-docker-containers $*"
        }

        bats.docker-run-aatsv4() {
            bats_run "bats.docker-run-aatsv4 $*"
        }

        bats.docker-build() {
            bats_run "bats.docker-build $*"
        }

        bats.docker-run() {
            bats_run "bats.docker-run $*"
        }

        bats.docker-run-x86() {
            bats_run "bats.docker-run-x86 $*"
        }

        bats.docker-run-arm() {
            bats_run "bats.docker-run-arm $*"
        }

        bats.docker-run-crosstoolchains() {
            bats_run "bats.docker-run-crosstoolchains $*"
        }

        bats.docker-run-crossarm() {
            bats_run "bats.docker-run-crossarm $*"
        }

        bats.docker-run-node() {
            bats_run "bats.docker-run-node $*"
        }

        bats.docker-run-x86ubuntu() {
            bats_run "bats.docker-run-x86ubuntu $*"
        }

        bats.docker-run-automatedtesting() {
            bats_run "bats.docker-run-automatedtesting $*"
        }

        bats.build() {
            bats_run "bats.build $*"
        }

        bats.radiokeys() {
            bats_run "bats.radiokeys $*"
        }

        bats.compile-all() {
            bats_run "bats.compile-all $*"
        }

        bats.compile-x86() {
            bats_run "bats.compile-x86 $*"
        }

        bats.compile-arm() {
            bats_run "bats.compile-arm $*"
        }

        bats._portknock() {
            bats_run "bats._portknock $*"
        }

        bats._passwordseed() {
            bats_run "bats._passwordseed $*"
        }

        bats._rootpasswordfromseed() {
            bats_run "bats._rootpasswordfromseed $*"
        }

        bats._devpasswordfromseed() {
            bats_run "bats._devpasswordfromseed $*"
        }

        bats.ssh() {
            bats_run "bats.ssh $*"
        }

        bats.scp() {
            bats_run "bats.scp $*"
        }

        bats.pw() {
            bats_run "bats.pw $*"
        }

        bats.portforwardssh() {
            bats_run "bats.portforwardssh $*"
        }

        bats.http-server() {
            bats_run "bats.http-server $*"
        }

        bats.https-server() {
            bats_run "bats.https-server $*"
        }

        bats.http-get() {
            bats_run "bats.http-get $*"
        }

        bats.https-get() {
            bats_run "bats.https-get $*"
        }

        bats.usbserial() {
            bats_run "bats.usbserial $*"
        }
    fi
}

zshrc_drop_mode() {
    zshrc_low_power=true
    zshrc_dropping_mode=true
    zshrc_init
}

zshrc_init() {
    zshrc_benchmark_start

    if ( ! $zshrc_dropping_mode ); then
        zshrc_probe
    fi

    zshrc_set_environment_variables
    zshrc_enter_tmux
    #zshrc_display_banner

    zshrc_source
    zshrc_batsdevrc
    zshrc_set_path
    zshrc_set_aliases
    zshrc_set_default_programs
    zshrc_load_library

    zshrc_auto_window_title
    zshrc_setup_completion
    zshrc_set_options
    zshrc_autoload
    if ( ! $zshrc_low_power ); then
        zshrc_powerlevel9k
    else
        zshrc_raw_prompt
    fi

    if ( ! $zshrc_dropping_mode ); then
        zshrc_zplug
    fi

    if ( $zshrc_dropping_mode ); then
        zshrc_dropping_mode=false
    fi

    zshrc_benchmark_stop
}

zshrc_init
