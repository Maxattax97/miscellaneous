#!/usr/bin/env zsh
# shellcheck shell=bash

DOTFILES_PATH="${HOME}/src/miscellaneous"

config_help=false
config_benchmark=false
if [[ -z "$zshrc_low_power" ]]; then
    # Allow low power mode to propagte up TMUX.
    zshrc_low_power=false
fi
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
            export zshrc_low_power=true
            echo "Low power mode enabled."
            ;;
        *vt100*)
            export zshrc_low_power=true
            echo "Low power mode enabled."
            ;;
    esac
}

zshrc_enter_tmux() {
    if [[ -n "$(command -v tmux)" ]]; then
        local session_count=$(tmux ls 2>/dev/null | wc -l)
        if type tmuxp > /dev/null 2>&1; then
            if [[ "$session_count" -eq "0" ]]; then
                # Load the tmuxp configuration for the current host, and attach
                # if it already exists.
                local host_config="${HOME}/.tmuxp/$(hostname).yaml"
                if [ -s "${host_config}" ]; then
                    tmuxp load -y "${host_config}"
                else
                    tmuxp load -y "${HOME}/.tmuxp/main.yaml"
                fi
            elif [[ -n "$TMUX" ]]; then
                # If we are already in a tmux session, just display the banner for this shell.
                zshrc_display_banner
            fi
        else
            local session_count=$(tmux ls 2>/dev/null | wc -l)
            if [[ "$session_count" -eq "0" ]]; then
                tmux -2 new-session -s "Main"
            else
                # Make sure we are not already in a tmux session
                if [[ -z "$TMUX" ]]; then
                    # Session id is date and time to prevent conflict
                    # TODO: Make session number more... meaningful?
                    local session_id="$(date +%H%M%S)"

                    # Create a new session (without attaching it) and link to base session
                    # to share windows
                    tmux -2 new-session -d -t Main -s "$session_id"

                    # Attach to the new session & kill it once orphaned
                    tmux -2 attach-session -t "$session_id" \; set-option destroy-unattached
                else
                    zshrc_display_banner
                fi
            fi
        fi
    else
        zshrc_display_banner
    fi
}

# Adapted from oh-my-zsh: https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/termsupport.zsh
zshrc_auto_window_title() {
    if [ -z "$DISABLE_AUTO_TITLE" ]; then
        DISABLE_AUTO_TITLE=false
    fi

    function title {
        emulate -L zsh
        setopt prompt_subst

        [[ "$EMACS" == *term* ]] && return

        # if $2 is unset use $1 as default
        # if it is set and empty, leave it as is
        : ${2=$1}

        case "$TERM" in
            cygwin|xterm*|putty*|rxvt*|ansi)
                if [[ "$TMUX_PANE" == "%0" || "$TMUX_PANE" == "%1" ]]; then
                    print -Pn "\ekSYS\e\\" # set screen hardstatus
                elif [[ "$TMUX_PANE" == "%2" || "$TMUX_PANE" == "%3" ]]; then
                    print -Pn "\ekCOM\e\\" # set screen hardstatus
                else
                    print -Pn "\e]2;$2:q\a" # set window name
                    print -Pn "\e]1;$1:q\a" # set tab name
                fi
                ;;
            screen*|tmux*)
                if [[ "$TMUX_PANE" == "%0" || "$TMUX_PANE" == "%1" ]]; then
                    print -Pn "\ekSYS\e\\" # set screen hardstatus
                elif [[ "$TMUX_PANE" == "%2" || "$TMUX_PANE" == "%3" ]]; then
                    print -Pn "\ekCOM\e\\" # set screen hardstatus
                else
                    print -Pn "\ek$1:q\e\\" # set screen hardstatus
                fi
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
    # shellcheck disable=SC2296
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

    # Partial completions: ~/L/P/B -> ~/Library/Preferences/ByHost
    zstyle ':completion:*' list-suffixes
    zstyle ':completion:*' expand prefix suffix

    # Makefile completion
    zstyle ':completion:*:make:*:targets' call-command true # outputs all possible results for make targets
    zstyle ':completion:*:make:*' tag-order targets
    zstyle ':completion:*' group-name ''
    zstyle ':completion:*:descriptions' format '%B%d%b'

    zmodload -i zsh/complist

    WORDCHARS=''

    unsetopt menu_complete   # do not autoselect the first completion entry
    unsetopt flowcontrol
    setopt auto_menu         # show completion menu on successive tab press
    setopt complete_in_word
    setopt always_to_end
    setopt shwordsplit # https://unix.stackexchange.com/questions/19530/expanding-variables-in-zsh

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

    # Complete IP addresses from host files.
    zstyle ':completion:*' use-ip true

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

    zstyle :compinstall filename '~/.zshrc'

    if type rustup > /dev/null 2>&1; then
        if [[ ! -s "${HOME}/.zsh_completions/_rustup" ]]; then
            rustup completions zsh > "${HOME}/.zsh_completions/_rustup"
        fi

        if type cargo > /dev/null 2>&1 && [[ ! -s "${HOME}/.zsh_completions/_cargo" ]]; then
            rustup completions zsh cargo > "${HOME}/.zsh_completions/_cargo"
        fi
    fi

    # Load `awscli`'s completions if available.
    # NOTE: These are bash completions!
    local aws_completer_path="$(command -v aws_completer)"
    if [ -x $aws_completer_path ]; then
        complete -C "$aws_completer_path" aws
    fi

    if type gh > /dev/null 2>&1; then
        if [[ ! -s "${HOME}/.zsh_completions/_gh" ]]; then
            gh completion -s zsh > "${HOME}/.zsh_completions/_gh"
        fi
    fi

    if type activate-global-python-argcomplete > /dev/null 2>&1; then
        if [[ ! -s "${HOME}/.zsh_completions/_python-argcomplete" ]]; then
            activate-global-python-argcomplete --dest "${HOME}/.zsh_completions/"
        fi
    fi

    if type rg > /dev/null 2>&1; then
        if [ ! -s "${HOME}/.zsh_completions/_rg" ]; then
            rg --generate=complete-zsh > "${HOME}/.zsh_completions/_rg"
        fi
    fi

    if type helm > /dev/null 2>&1; then
        if [ ! -s "${HOME}/.zsh_completions/_helm" ]; then
            helm completion zsh > "${HOME}/.zsh_completions/_helm"
        fi
    fi

    # Takes a lot of extra time ...
    #if type molecule > /dev/null 2>&1; then
        # Because it may be in a venv, we will have to do this on-demand.
        #eval "$(_MOLECULE_COMPLETE=zsh_source molecule)"

        #if [ ! -s "${HOME}/.zsh_completions/_molecule" ]; then
            #_MOLECULE_COMPLETE=zsh_source molecule > "${HOME}/.zsh_completions/_molecule"
        #fi
    #fi
}

zshrc_autoload() {
    # Used to debug the fpath variable.
    pretty_fpath() {
        old_IFS=$IFS     # Save the current IFS (Internal Field Separator)
        IFS=' '          # Set the delimiter to ':'
        # shellcheck disable=SC2086
        set -- $fpath     # Split PATH into positional parameters
        IFS=$old_IFS     # Restore the original IFS

        echo "Precedence order of directories in fpath:"
        index=1
        while [ $# -gt 0 ]; do
            dir=$1
            shift
            if [ -n "$dir" ]; then
                echo "$index) $dir"
                index=$((index + 1))
            fi
        done
    }

    # Setup the ZSH completions directory before we initialize completions.
    mkdir -p "${HOME}/.zsh_completions"
    fpath+="${HOME}/.zsh_completions"

    if type brew > /dev/null 2>&1; then
        fpath+="$(brew --prefix)/share/zsh/site-functions"
    fi

    if [ -d "/usr/share/zsh/functions/Completion/Unix" ]; then
        fpath+="/usr/share/zsh/functions/Completion/Unix"
    fi

    if [ -d "/usr/share/zsh/vendor-completions" ]; then
        fpath+="/usr/share/zsh/vendor-completions"
    fi

    autoload -Uz compinit && compinit
    autoload -Uz bashcompinit && bashcompinit # TODO: I don't think this is working right.
    autoload -Uz promptinit && promptinit
    autoload -Uz add-zsh-hook

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
    # NOTE: This will append a path which points to a fzf binary which is
    # provided outside of the package manager. This is ideal behavior because
    # it offers preference to a distribution managed fzf binary.
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
    # The average command is 20.092 characters long.
    HISTSIZE=10000 # How much is saved to file.
    SAVEHIST=10000 # How much is kept in memory.

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

        zplug "mfaerevaag/wd", as:command, use:"wd.sh", hook-load:"wd() { . $ZPLUG_REPOS/mfaerevaag/wd/wd.sh }"
        # For some reason, the hook doesn't always work...
        wd() {
            . $ZPLUG_REPOS/mfaerevaag/wd/wd.sh
        }
        # Add zsh completion for this plugin.
        if [[ -d "${HOME}/.zplug/repos/mfaerevaag/wd/" ]]; then
            fpath+="${HOME}/.zplug/repos/mfaerevaag/wd/"
        fi


        zplug "arzzen/calc.plugin.zsh"
        zplug "chrissicool/zsh-256color"
        zplug "hlissner/zsh-autopair", defer:2

        # Improved bash compatibility
        # zplug "chrissicool/zsh-bash"

        #zplug "stackexchange/blackbox"
        zplug "tarrasch/zsh-command-not-found"

        zplug "junegunn/fzf", as:command, rename-to:fzf, \
            hook-build:"rm ~/.fzf.zsh; ./install --all && source ${HOME}/.fzf.zsh"

        # Install fzf or fzy
        zplug "b4b4r07/enhancd", use:init.sh, hook-load:"ENHANCD_ENABLE_DOUBLE_DOT=false"

        # git log = glo; git diff = gd; git add = ga; git ignore = gi
        zplug "wfxr/forgit", defer:1

        export NVM_LAZY_LOAD=true
        export NVM_CACHE_LOAD=true
        # zplug "lukechilds/zsh-nvm"
        zplug "maxattax97/zsh-nvm"

        zplug "gko/ssh-connect", as:command, use:"ssh-connect.sh", hook-load:". $ZPLUG_REPOS/gko/ssh-connect/ssh-connect.sh"
        alias sshc='ssh-connect'

        if ( ! "$zshrc_low_power" ); then
            #zplug "bhilburn/powerlevel9k", at:master, use:powerlevel9k.zsh-theme
            zplug "romkatv/powerlevel10k", as:theme, depth:1
        fi

        # zplug "ael-code/zsh-colored-man-pages"

        # zplug "supercrabtree/k"

        # zplug "psprint/zsh-navigation-tools" # deleted
        # zplug "z-shell/zsh-navigation-tools" # alternate
        zplug "zdharma-continuum/zsh-navigation-tools"

        # Must load last.
        # zplug "zsh-users/zsh-syntax-highlighting"
        # zplug "zdharma/fast-syntax-highlighting", defer:3
        zplug "zdharma-continuum/fast-syntax-highlighting", defer:3

        # Really annoying and doesn't seem to work right?
        #zplug "hkupty/ssh-agent"

        zplug "plugins/thefuck", from:oh-my-zsh
        bindkey "^f" fuck-command-line

        zplug "MichaelAquilina/zsh-autoswitch-virtualenv"

        if ! zplug check; then
            zplug install
        fi

        zplug load
    else
        echo "Failed to load zplug plugins."
    fi
}

zshrc_extensions() {
    if type navi > /dev/null 2>&1; then
        eval "$(navi widget zsh)"
    fi

    if type keychain > /dev/null 2>&1; then
        eval "$(keychain --eval -q)"
    fi

    #if [[ -z "${SSH_AGENT_PID}" ]]; then
        #eval $(ssh-agent -t 10m) 1>/dev/null

        # Add a key:
        #               ssh-add ~/.ssh/id_rsa
        # List currently loaded keys:
        #               ssh-add -L
    #fi
}

zshrc_display_banner() {
    if ( ! "$zshrc_low_power" ); then
        if type fastfetch > /dev/null 2>&1; then
            fastfetch
        elif type neofetch > /dev/null 2>&1; then
            neofetch --disable "packages"
        elif type screenfetch > /dev/null 2>&1; then
            screenfetch -d '-pkgs,wm,de,res,gtk;+disk' -E
            echo
        fi

        if type mikaelasay > /dev/null 2>&1 && [[ "$CHASSIS" != "laptop" ]]; then
            mikaelasay
            echo
        fi
    else
        echo "Entering low power mode ..."
        echo
    fi
}

# Prepend or postpend a path to the $PATH variable if it exists and is not
# already in the $PATH. This is a derivative of POSIX shell's pathmunge
# (usually found in /etc/profile)
zshrc_add_path() {
    if [ -d "$1" ]; then
        case ":${PATH}:" in
            *:"$1":*)
                ;;
            *)
                if [ "$2" = "after" ] ; then
                    PATH=$PATH:$1
                else
                    # Includes "before" and is the default
                    PATH=$1:$PATH
                fi
        esac
    fi
}

zshrc_set_path() {
    # Used to debug the PATH variable.
    pretty_path() {
        old_IFS=$IFS     # Save the current IFS (Internal Field Separator)
        IFS=':'          # Set the delimiter to ':'
        # shellcheck disable=SC2086
        set -- $PATH     # Split PATH into positional parameters
        IFS=$old_IFS     # Restore the original IFS

        echo "Precedence order of directories in PATH:"
        index=1
        while [ $# -gt 0 ]; do
            dir=$1
            shift
            if [ -n "$dir" ]; then
                echo "$index) $dir"
                index=$((index + 1))
            fi
        done
    }

    if [ -s "${HOME}/.profile" ]; then
        echo "Your profile is not empty and is being sourced!"
    fi

    if [ -s "${HOME}/.zshenv" ]; then
        echo "Your .zshenv is not empty and is being sourced!"
    fi

    # The sbin paths are processed after the general bin paths.
    zshrc_add_path "/usr/local/bin" after
    zshrc_add_path "/usr/local/sbin" after

    zshrc_add_path "/usr/bin" after
    zshrc_add_path "/usr/sbin" after

    zshrc_add_path "/bin" after
    zshrc_add_path "/sbin" after

    # Override macOS's outdated curl version. This has to be prefixed so it overrides the /usr/bin/curl path.
    if type brew > /dev/null 2>&1; then
        if [ -s "$(brew --prefix)/opt/curl/bin/curl" ]; then
            zshrc_add_path "$(brew --prefix)/opt/curl/bin:${PATH}" before
        fi

        if [ -d "$(brew --prefix)/opt/make/libexec/gnubin" ]; then
            zshrc_add_path "$(brew --prefix)/opt/make/libexec/gnubin:${PATH}" before
        fi

        if [ -d "$(brew --prefix)/opt/binutils/bin" ]; then
            zshrc_add_path "$(brew --prefix)/opt/binutils/bin:${PATH}" before
            LDFLAGS="-L$(brew --prefix)/opt/binutils/lib"
            export LDFLAGS
            CPPFLAGS="-I$(brew --prefix)/opt/binutils/include"
            export CPPFLAGS
        fi

        if type gsed > /dev/null 2>&1; then
            # Make the gsed application universal for this system!
            if [ ! -e "${HOME}/.local/bin/sed" ]; then
                mkdir -p "${HOME}/.local/bin"
                ln -s "$(command -v gsed)" "${HOME}/.local/bin/sed"
                echo "NOTE: GNU gsed is now linked to sed in ${HOME}/.local/bin; you are no longer using BSD sed!"
            fi
        fi
    fi

    zshrc_add_path "${HOME}/.local/bin" before

    # Override system-installed Rust/Cargo.
    if [ -s "$HOME/.cargo/env" ]; then
        . "$HOME/.cargo/env"
    fi

    # Override system-installed packages with the Go variety.
    zshrc_add_path "/usr/local/go/bin" before

    if [ -n "$GOPATH" ]; then
        zshrc_add_path "${GOPATH}/bin" before
    fi

    if [ -n "$GOROOT" ]; then
        zshrc_add_path "${GOROOT}/bin" before
    fi

    # Dynamically add the ruby gem paths.
    if type gem > /dev/null 2>&1; then
        # Sometimes this path doesn't exist.
        local user_gem_path=$(gem env user_gemdir 2>/dev/null)
        if [ $? -eq 0 ]; then
            zshrc_add_path "${user_gem_path}/bin" before
        fi

        local gem_path=$(gem env gemdir 2>/dev/null)
        if [ $? -eq 0 ]; then
            zshrc_add_path "${gem_path}/bin" before
        fi
    fi

    zshrc_add_path "${HOME}/.config/yarn/global/node_modules/.bin" before
    zshrc_add_path "${HOME}/.yarn/bin" before

    # Miscellaneous paths
    zshrc_add_path "${HOME}/.SpaceVim/bin" before

    zshrc_add_path "${HOME}/.anaconda2/bin" before
    zshrc_add_path "${HOME}/anaconda2/bin" before

    zshrc_add_path "${HOME}/src/cquery/build/release/bin" before
    zshrc_add_path "${HOME}/src/depot_tools" before

    zshrc_add_path "${HOME}/.adb-fastboot/platform-tools" before

    zshrc_add_path "${HOME}/bin/balena-cli" before

    zshrc_add_path "${KREW_ROOT:-$HOME/.krew}/bin" before

    # Always wins, these are mine.
    zshrc_add_path "${HOME}/bin" before
}

zshrc_load_library() {
    # Join a telnet based movie theater.
    starwars() {
        telnet towel.blinkenlights.nl
    }

    mirrorweb() {
        wget --mirror --page-requisites --no-parent --adjust-extension --convert-links --recursive --level=inf --continue --no-clobber $@
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

    weather() {
        curl "wttr.in/$1?m"
    }

    # Aliases, functions, commands, etc.

    # From https://github.com/xvoland/Extract/blob/master/extract.sh
    # TODO: Add support for cpio, ar, iso
    # TODO: Add progress bar, remove verbose flag
    decompress() {
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
    alias inflate='decompress'

    compress() {
        if [ -z "$1" ] || [ -z "$2" ]; then
            # display usage if no parameters given
            echo "Usage: squeeze <path/to/input> <path/to/output>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|tar.bz2|tar.gz|tar.xz|lzop|lz|lz4>"
            return 1
        else
            input=$1
            output=$2
            # Add support for single files (in addition to directories).
            if [ -d "$input" ] || [ -f "$input" ] ; then
                case "${output}" in
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
                        tar --lzma -cf "$output" "$input"
                        ;;
                    *.bz2)
                        tar -cjf "$output" "$input"
                        ;;
                    *.rar)
                        rar a "$output" "$input"
                        ;;
                    *.gz)
                        tar -czf "$output" "$input"
                        ;;
                    *.zip)
                        zip -r "$output" "$input"
                        ;;
                    *.Z)
                        tar -cZf "$output" "$input"
                        ;;
                    *.7z)
                        7z a "$output" "$input"
                        ;;
                    *.xz)
                        tar -cJf "$output" "$input"
                        ;;
                    *.lzop)
                        lzop -o "$output" "$input"
                        ;;
                    *.lz)
                        lzip -o "$output" "$input"
                        ;;
                    *.lz4)
                        lz4 -z "$input" "$output"
                        ;;
                    *.tar.zst|*.tzst)
                        tar --zstd -cf "$output" "$input"
                        ;;
                    *.zst)
                        zstd "$input" -o "$output"
                        ;;
                    *)
                        echo "squeeze: '$output' - unknown archive method"
                        return 1
                        ;;
                esac
            else
                echo "'$input' - file or directory does not exist"
                return 1
            fi
        fi
    }
    alias squeeze='compress'

    # Host the current directory via HTTP
    hostdir() {
        if type "npx" > /dev/null 2>&1; then
            npx http-server
        elif type "python3" > /dev/null 2>&1; then
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
                echo "Network access has been restored!"
                notify-send --urgency=normal --icon=gtk-network "Online" "Internet access has been restored."
                tone 500 400; tone 1000 400; tone 2000 400
                failing=false
            else
                printf "."
                sleep 1
            fi
        done
    }

    waitoffline() {
        local target=${1:-8.8.8.8}
        echo "Waiting for system go offline ..."
        succeeding=true
        while "$succeeding"; do
            ping "$target" -c 1 -W 2 > /dev/null 2>&1
            success="$?"
            if [ "$success" -ne 0 ]; then
                printf "\n"
                echo "Network access has been lost!"
                notify-send --urgency=normal --icon=gtk-network "Offline" "Network access has been lost."
                tone 2000 400; tone 1000 400; tone 500 400
                succeeding=false
            else
                printf "."
                sleep 1
            fi
        done
    }

    dockerclean() {
        echo "Cleaning Docker images and containers ..."
        sudo docker system prune --all
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
        local target_user="$1"
        local target_host="$2"
        local target_port="${3:-22}"

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

    cycle() {
        delay=$1
        case $delay in
            ''|*[!0-9]*) echo "You must specify a numeric delay" && return ;;
            *) echo good ;;
        esac
        shift
        cmd_with_args=$@

        while true; do
            clear
            $cmd_with_args
            sleep $delay
        done
    }

    jules() {
        chat_id="${1:-$(uuidgen)}"
        action="Starting"

        if [ -n "$1" ]; then
            action="Resuming"
        fi

        echo "${action} chat \`${chat_id}\`"
        sgpt --role "jules" --model "gpt-4-1106-preview" --repl "${chat_id}"
    }

    d2h() {
        if [ $# -eq 0 ]; then
            while IFS= read -r dec; do
                printf "0x%x\n" "$dec"
            done
        else
            for dec in "$@"; do
                printf "0x%x\n" "$dec"
            done
        fi
    }

    h2d() {
        if [ $# -eq 0 ]; then
            while IFS= read -r hex; do
                case "$hex" in
                    0x*|0X*)
                        ;;
                    *)
                        hex="0x$hex"
                        printf "%s -> " "$hex" > /dev/stderr
                        ;;
                esac
                printf "%d\n" "$hex"
            done
        else
            for hex in "$@"; do
                case "$hex" in
                    0x*|0X*)
                        ;;
                    *)
                        hex="0x$hex"
                        printf "%s -> " "$hex" > /dev/stderr
                        ;;
                esac
                printf "%d\n" "$hex"
            done
        fi
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

            # something is really effed up and screws up my syntax here, so
            # this comment fixes that:
            # ''$(\'''
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

    # Go to the root of the current git repository.
    groot() {
        cd "$(git rev-parse --show-toplevel)"
    }

    power-sleep() {
        sudo sh -c 'echo "freeze" > /sys/power/state'
    }

    power-hibernate() {
        # TODO: This wont work with a swap *file*.
        local device="$(lsblk -b | grep -i 'swap' | awk '{ printf $4 " " $2 "\n" }' | sort -n -r | awk '{ printf $2 "\n" }' | head -n 1)"
        if [ -n "$device" ]; then
            sudo sh -c "echo $device > /sys/power/resume"
            sudo sh -c 'echo "disk" > /sys/power/state'
        else
            echo "Could not find a valid swap device, check lsblk, aborting"
        fi
    }

    enhance() {
        mogrify -auto-gamma -auto-level -normalize $@
    }

    scale() {
        scale=$1
        shift
        mogrify -scale $scale $@
    }

    poor_mans_scp_upload() {
        local source_file="$1"
        local target_user_at_host="$2"
        local target_file="$3"

        tar czf - "$source_file" | ssh "$target_user_at_host" tar xzf - -C "$target_file"
    }

    poor_mans_scp_download() {
        local remote_user_at_host="$1"
        local remote_source_file="$2"
        local local_dest_file="$3"

        # shellcheck disable=SC2029
        ssh "$remote_user_at_host" "tar czf - ${remote_source_file}" | tar xzvf - -C "$(dirname "$local_dest_file")"
    }

    unix_epoch_seconds() {
        date +%s
    }

    unix_epoch_milliseconds() {
        date +%s%3N
    }

    unix_epoch_parse() {
        # TODO: Make this parse seconds, milliseconds, nanoseconds based on size of input.
        # https://unix.stackexchange.com/a/2993
        if date --version 2>&1 | grep -q 'GNU coreutils'; then
            date -u -d "@$1" --iso-8601=ns
        else
            # *BSD
            date -u -r "$1" +"%Y-%m-%dT%H:%M:%S%:z"
        fi
    }

    web_repo() {
        local repo_url="$(git config --get remote.origin.url)"

        if [[ -z "$repo_url" ]]; then
            echo "Not a git repository or no remote.origin.url found"
            return 1
        fi

        # Transform SSH URLs to HTTPS URLs
        if [[ "$repo_url" == git@* ]]; then
            repo_url=$(echo "$repo_url" | sed -e 's|:|/|' -e 's|^git@|https://|')
        fi

        # Used for both SSH and HTTPS URLs
        repo_url=$(echo "$repo_url" | sed -e 's|\.git$||')

        echo "Navigating to: $repo_url ..."
        case "$OSTYPE" in
            darwin*)  open "$repo_url" ;;  # MacOS
            linux*)   xdg-open "$repo_url" ;;  # Linux
            cygwin* | msys* | mingw*) start "$repo_url" ;;  # Windows
            *)        echo "Unsupported OS: $OSTYPE" ;;
        esac
    }

    troubleshoot() {
        dir=${1:-.}
        search=${2:-"warn|err|fatal|crit|panic|fail|segfault|exception"}

        # Check if directory path is provided
        if [ -z "$dir" ]; then
            echo "Usage: troubleshoot <directory path>"
            return 1
        fi

        # Check if the directory exists
        if [ ! -d "$dir" ]; then
            echo "Error: Directory does not exist"
            return 1
        fi

        # Regex pattern to match common timestamp formats
        timestamp_pattern='[0-9]{4}-[0-9]{2}-[0-9]{2}([T ])[0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]+(Z)?'

        # Search recursively in the directory for log files and process them
        grep -RiIE "$search" "$dir" | \
            sed -E "s/$timestamp_pattern//g" | \
            sort | \
            uniq -ic | \
            sort -n
    }

    zshrc_source_idempotency() {
        # Path to your shell configuration file
        CONFIG_FILE="$HOME/.zshrc"

        # Function to capture the current state of environment variables and functions
        zshrc_capture_state() {
            env > "$1"
            declare -f >> "$1"
            alias >> "$1"
        }

        # Capture the initial state
        local pre_state_file="$(mktemp)"
        zshrc_capture_state "$pre_state_file"

        # Source the configuration file
        source "$CONFIG_FILE"

        # Capture the state after sourcing
        local post_state_file="$(mktemp)"
        zshrc_capture_state "$post_state_file"

        # Compare the environment variables and functions before and after sourcing
        diff_states=$(diff --color=always "$pre_state_file" "$post_state_file")

        # Clean up temporary files
        rm "$pre_state_file" "$post_state_file"

        # Check if there are any differences
        if [ -z "$diff_states" ]; then
            echo "Re-sourcing the shell configuration is idempotent!"
            return 0
        else
            echo "Re-sourcing the shell configuration is NOT idempotent:"
            echo "$diff_states"
            return 1
        fi
    }

    wait_release() {
        local latest_release_tag="$(gh release list --json tagName --jq '.[0].tagName')"

        echo "Current latest release: $latest_release_tag"

        while true; do
            sleep 10

            # Fetch the latest release tag again
            local new_release_tag="$(gh release list --json tagName --jq '.[0].tagName')"

            if [ "$new_release_tag" != "$latest_release_tag" ]; then
                echo "" # Insert a newline before the next print
                echo "New release detected: $new_release_tag"
                break
            else
                printf "."
            fi
        done
    }

    clipboards() {
        if [ -x "$(command -v xsel)" ]; then
            echo "xsel:"
            echo "Primary: \"$(xsel --output --primary)\""
            echo "Secondary: \"$(xsel --output --secondary)\""
            echo "Clipboard: \"$(xsel --output --clipboard)\""
        fi

        if [ -x "$(command -v xclip)" ]; then
            echo "\nxclip:"
            echo "Primary: \"$(xclip -out -selection primary)\""
            echo "Secondary: \"$(xclip -out -selection secondary)\""
            echo "Clipboard: \"$(xclip -out -selection clipboard)\""
            echo "Buffer-cut: \"$(xclip -out -selection buffer-cut)\""
        fi
    }

    tstamp() {
        if date --version 2>&1 | grep -q 'GNU coreutils'; then
            cmd='date -u --iso-8601=ns'
        else
            # *BSD
            cmd='date -u +"%Y-%m-%dT%H:%M:%S%:z"'
        fi
        while IFS= read -r line; do
            printf "[\033[0;34m%s\033[0m] %s\n" "$($cmd)" "$line";
        done
    }

    color_codes() {
        # Define the text attributes and colors
        attributes=(
            "0"  "1"  "4"  "5"  "7"
        )
        colors=(
            "30" "31" "32" "33" "34" "35" "36" "37"
        )

        # Loop through each attribute and color, displaying them horizontally
        for attribute in "${attributes[@]}"; do
            for color in "${colors[@]}"; do
                echo -en "\033[${attribute};${color}m ${attribute};${color} \033[0m\t"
            done
            echo ""
        done

        # Reset to default
        echo -e "\033[0mDefault Text"
        echo "Example: \\\\033[1;34mBold Blue Text\\\\033[0m (Reset)"
    }

    random_string() {
        local length="${1:-16}"
        tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w "$length" | head -n 1
    }

    ssh-copy-id-mikrotik() {
        local userAtHost="$1"
        local user=$(echo "$userAtHost" | cut -d "@" -f 1)
        local key_filename="key_$(random_string 5).txt"

        ssh "$userAtHost" "/file add name=${key_filename} contents=\"$(cat ~/.ssh/id_rsa.pub)\"; /user ssh-keys import user=${user} public-key-file=${key_filename}; /file remove ${key_filename};"
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
        alias sl="sudo ls --color=auto"
        #alias dir='dir --color=auto'
        #alias vdir='vdir --color=auto'

        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'

        alias pacman='pacman --color=auto'
        alias yay='yay --color=auto'
    else
        alias sl="sudo ls"
    fi

    alias e="$EDITOR"
    alias se="sudoedit"

    # some more ls aliases
    alias l='ls -l --all --human-readable --time-style=long-iso --group-directories-first --color=auto'

    # Fix tmux 256 colors:
    #if type tmux-next > /dev/null 2>&1; then
    #alias tmux='tmux-next -2'
    #else
    alias tmux='tmux -2'
    #fi

    # Clear color codes before clearing:
    alias clear='echo -e "\e[0m" && clear'

    # Typical rsync command
    alias relocate='rsync -avzh --info=progress2'
    alias network-relocate='rsync -azP --delete --info=progress2'

    # Add progress indicator because I always forget.
    alias ddd='sudo dd iflag=nocache oflag=nocache,sync bs=16M status=progress'

    if type gpg2 > /dev/null 2>&1; then
        alias gpg='gpg2 --with-subkey-fingerprints'
        alias gpgls='gpg2 --list-secret-keys --with-subkey-fingerprints'
    fi

    alias please='sudo'

    # Docker commands
    alias dcp='docker-compose -f /opt/docker-compose.yml '
    alias dcpull='docker-compose -f /opt/docker-compose.yml pull --parallel'
    alias dclogs='docker-compose -f /opt/docker-compose.yml logs -tf --tail="50" '
    alias dtail='docker logs -tf --tail="50" "$@"'

    # Clipboard
    alias clip='xsel --clipboard --trim -i'

    # btop > htop > top
    if type htop > /dev/null 2>&1; then
        alias top='htop'
    fi

    if type btop > /dev/null 2>&1; then
        alias top='btop'
        alias htop='btop'
    fi

    if type rofi > /dev/null 2>&1; then
        alias dmenu="rofi -dmenu"
    fi

    # "Recursive Cat"
    # Used for feeding file data into an LLM
    # Ignores hidden files. (like git)
    alias rcat='find . -not -path "*/.*" -type f -exec sh -c '\''for file; do printf "\033[0;92m=== BEGIN $file ===\033[0m\n"; cat "$file"; printf "\n\033[0;91m=== END $file ===\033[0m\n"; done'\'' sh {} +'

    alias awsp="source _awsp"

    if type bat > /dev/null 2>&1; then
        alias bat='bat --theme=base16'
        alias cat='bat'
    fi

    # Git aliases
    alias G='git'

    alias Ga='git add'

    alias Gc='git commit'
    alias Gcm='git commit -m'
    alias Gca='git commit --amend'

    alias Gcl='git clone'

    alias Gcom='git checkout main'
    alias Gco='git checkout'
    alias Gcob='git checkout -b'

    alias Gd='git diff'
    alias Gds='git diff --staged'

    alias Gp='git pull && git push'
    alias Gpl='git pull'
    alias Gpu='git push'

    alias Gs='git status'
    alias Gl='git logline' # This uses a custom Git alias (i.e. gitconfig).
    alias Gbd='git branch -D'
    alias Glast='git show HEAD'
    alias Grs='git restore --staged'

    alias kernlog='sudo dmesg --time-format iso --kernel -H --color=always -w | less +F'

    alias Eupdate='sudo emerge --sync'
    alias Eupgrade='sudo emerge --ask --tree --update --verbose --deep --newuse @world'
    alias Einstall='sudo emerge --ask --verbose --tree --noreplace'
    alias Eclean='sudo emerge --ask --depclean'
}

zshrc_set_default_programs() {
    # For heavyweight purposes.
    if type nvim > /dev/null 2>&1; then
        export VISUAL="$(which nvim)"
        if [[ -d "${HOME}/.SpaceVim" ]]; then
            alias vim="nvim"
        fi
    elif type vim > /dev/null 2>&1; then
        export VISUAL="$(which vim)"
        alias nvim="vim"
    elif type vi > /dev/null 2>&1; then
        export VISUAL="$(which vi)"
        alias nvim="vi"
    elif type nano > /dev/null 2>&1; then
        export VISUAL="$(which nano)"
    fi

    # For lightweight purposes.
    export EDITOR="$VISUAL"

    export PAGER="less"
    export MANPAGER="less"

    if type brave > /dev/null 2>&1; then
        export BROWSER="$(which brave)"
    elif type brave-browser > /dev/null 2>&1; then
        export BROWSER="$(which brave-browser)"
    elif type firefox > /dev/null 2>&1; then
        export BROWSER="$(which firefox)"
    elif type chromium > /dev/null 2>&1; then
        export BROWSER="$(which chromium)"
    elif type google-chrome-stable > /dev/null 2>&1; then
        export BROWSER="$(which google-chrome-stable)"
    fi

    if type st > /dev/null 2>&1; then
        export TERMINAL="$(which st)"
    elif type urxvt-256color > /dev/null 2>&1; then
        export TERMINAL="$(which urxvt-256color)"
    elif type konsole > /dev/null 2>&1; then
        export TERMINAL="$(which konsole)"
    fi

    export P4IGNORE="~/Perforce/mocull/Engineering/Software/Linux/Code/.p4ignore"

    if type fastfetch > /dev/null 2>&1; then
        alias neofetch="fastfetch"
        alias screenfetch="fastfetch"
        alias fetch="fastfetch"
    elif type neofetch > /dev/null 2>&1; then
        alias fastfetch="neofetch"
        alias screenfetch="neofetch"
        alias fetch="neofetch"
    elif type screenfetch > /dev/null 2>&1; then
        alias fastfetch="screenfetch"
        alias neofetch="screenfetch"
        alias fetch="screenfetch"
    fi
}

zshrc_set_environment_variables() {
    # We can't use `brew --prefix` here because brew isn't in our path yet.
    if [ -s "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    # macOS and some other distros don't use traditional Linux ls colors.
    export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

    # Enable colors for less by default. Disable mouse because while scrolling is nice, it's not worth losing copy-paste.
    # --LINE-NUMBERS
    # --mouse
    export LESS='--RAW-CONTROL-CHARS --ignore-case --quit-if-one-screen --status-column --tabs=4 --wheel-lines=3'

    if [[ "$(uname)" == "Linux" ]]; then
        CPU_CORES="$(grep "^core id" /proc/cpuinfo | sort -u | wc -l)"
        CPU_THREADS="$(grep "^processor" /proc/cpuinfo | sort -u | wc -l)"
    fi

    if [[ "$(uname)" =~ .*BSD.* ]] || [[ "$(uname)" == "Darwin" ]]; then
        CPU_CORES="$(sysctl -n hw.ncpu)"
        local threads_per_core="$(sysctl -n hw.smt_threads 2>/dev/null || echo 1)"
        CPU_THREADS=$((threads_per_core * CPU_CORES))
    fi

    if [[ -z "${CPU_CORES}" ]] || [[ -z "${CPU_THREADS}" ]]; then
        echo "Failed to detect number of cores/threads."
    fi

    if [[ -d "${HOME}/Perforce/mocull/Engineering/Software/Linux/Code/AATSV4/Lib" ]]; then
        export PERFORCE_WORKSPACE="${HOME}/Perforce/mocull/"
        export _code_path="${PERFORCE_WORKSPACE}/Engineering/Software/Linux/Code"
        #export NODE_PATH="${NODE_PATH}:${HOME}/Perforce/mocull/Engineering/Software/Linux/Code/AATSV4/Lib"
        export NODE_PATH="${_code_path}/node_modules_dev/node_modules:${_code_path}/AATSV4/Lib:${_code_path}/AATSV4/node_modules"
        export PATH="${_code_path}/node_modules_dev/node_modules/.bin:${PATH}"
    fi

    if [[ -s "${HOME}/Perforce/mocull/Engineering/Software/Linux/Code/.p4ignore" ]]; then
        export P4IGNORE="${HOME}/Perforce/mocull/Engineering/Software/Linux/Code/.p4ignore"
    fi

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
        if [[ -f "/sys/class/dmi/id/chassis_type" ]] ; then
            local chassis_type="$(cat /sys/class/dmi/id/chassis_type)"
            local chassis_name=""
        fi

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

    if [[ -d "${HOME}/go" ]]; then
        export GOPATH="${HOME}/go"
    fi

    # TODO: Won't work on Arch, needed to install other things.
    #if [[ -d "${GOPATH}" ]]; then
    #temp_go_path=("${GOPATH}/go-"*);
    #if [[ -d "${temp_go_path[-1]}" ]]; then
    #export GOROOT=${temp_go_path[-1]}
    #if [[ -d "${temp_go_path[2]}" ]]; then
    #echo "WARNING: There is more than one version of golang installed (${temp_go_path[@]}), selected ${GOROOT} ..."
    #fi
    #fi
    #fi

    export CHASSIS="$chassis_name"

    # Fix GPG TTY for MacOS, otherwise you can't do signed commits
    # https://stackoverflow.com/a/57591830
    if [[ "$(uname)" =~ .*BSD.* ]] || [[ "$(uname)" == "Darwin" ]]; then
        GPG_TTY=$(tty)
        export GPG_TTY
    fi

    # Python on Linux uses ~/.local
    # Python on macOS uses ~/Library/Python/X.Y/lib/python/site-packages
    # ... this is madness, unify them.
    export PYTHONUSERBASE="$HOME/.local"
}

zshrc_aura_shrc() {
    export AURA_DEVELOPMENT_TOOLS_PATH="${HOME}/aura/ns/aura-development-tools"
    export AURA_VPN_CONFIG="${HOME}/Documents/OpenVPN/aura_profile-5075079927914878174.ovpn"

    if [[ -s "$AURA_DEVELOPMENT_TOOLS_PATH"/aura_shrc ]]; then
        source "$AURA_DEVELOPMENT_TOOLS_PATH"/aura_shrc
    fi
}

zshrc_update_or_append() {
    file="$1"
    content="$(cat "$2")"

    static_marker="# MOCULL STATIC"
    start_marker="##### MOCULL AUTOGENERATED ### DO NOT EDIT #####"
    end_marker="##### END MOCULL AUTOGENERATED ### DO NOT EDIT #####"

    if [ -s "$file" ]; then
        # If the file does not contain the static marker, then we can
        # automatically update it
        if ! grep -q "$static_marker" "$file"; then
            if ! grep -q "$start_marker" "$file"; then
                # Append a newline before the start marker we are about to
                # insert
                echo "" >> "$file"
            else
                # Remove existing section, if present
                sed -i "/^${start_marker}$/,/^${end_marker}$/d" "$file"
            fi
        else
            # Exit early so we don't append the content
            return
        fi
    fi

    # Add content
    (echo "$start_marker"; echo "$content"; echo "$end_marker")>> "$file"
}

zshrc_setup_repo() {
    local repo_dir="${PWD}"

    local templates="${DOTFILES_PATH}/templates"
    FILE_CARGO_TOML_CLIPPY_LINTS="${templates}/Cargo.clippy.toml"
    FILE_GITATTRIBUTES="${templates}/gitattributes"
    FILE_GITIGNORE="${templates}/gitignore"
    FILE_PRE_COMMIT_CONFIG_PYTHON="${templates}/pre-commit-config.python.yaml"
    FILE_PRE_COMMIT_CONFIG_RUST="${templates}/pre-commit-config.rust.yaml"
    FILE_PRE_COMMIT_CONFIG_HELM="${templates}/pre-commit-config.helm.yaml"
    FILE_PRE_COMMIT_CONFIG_GENERAL="${templates}/pre-commit-config.general.yaml"
    FILE_PYPROJECT="${templates}/pyproject.toml"
    FILE_FLAKE8="${templates}/flake8"
    FILE_YAMLLINT="${templates}/yamllint.yml"
    FILE_EDITORCONFIG="${templates}/editorconfig"

    # Update .gitignore
    zshrc_update_or_append "$repo_dir/.gitignore" "$FILE_GITIGNORE"

    # Update .gitattributes
    zshrc_update_or_append "$repo_dir/.gitattributes" "$FILE_GITATTRIBUTES"

    # Update .yamllint.yml since all projects can use YAML
    zshrc_update_or_append "$repo_dir/.yamllint.yml" "$FILE_YAMLLINT"

    # Every repo gets this.
    zshrc_update_or_append "$repo_dir/.editorconfig" "$FILE_EDITORCONFIG"

    # Update .pre-commit-config.yaml based on project type
    if [ -s "$repo_dir/Cargo.toml" ]; then
        zshrc_update_or_append "$repo_dir/.pre-commit-config.yaml" "$FILE_PRE_COMMIT_CONFIG_RUST"
    elif [ -s "$repo_dir/requirements.txt" ] || [ -n "$(find . -name '*.py' -print -quit)" ]; then
        zshrc_update_or_append "$repo_dir/.pre-commit-config.yaml" "$FILE_PRE_COMMIT_CONFIG_PYTHON"
        zshrc_update_or_append "$repo_dir/pyproject.toml" "$FILE_PYPROJECT"
        zshrc_update_or_append "$repo_dir/.flake8" "$FILE_FLAKE8"
    elif [ -n "$(find "$repo_dir" -iname "chart*.y*ml")" ]; then
        zshrc_update_or_append "$repo_dir/.pre-commit-config.yaml" "$FILE_PRE_COMMIT_CONFIG_HELM"
    else
        zshrc_update_or_append "$repo_dir/.pre-commit-config.yaml" "$FILE_PRE_COMMIT_CONFIG_GENERAL"
    fi

    # Install pre-commit hooks if .pre-commit-config.yaml exists and the hooks do not.
    if [ -s "$repo_dir/.pre-commit-config.yaml" ] && [ ! -s "${repo_dir}/.git/hooks/pre-commit" ]; then
        pre-commit install
    fi

    # If we have Cargo.toml, then add clippy lints
    if [ -s "$repo_dir/Cargo.toml" ]; then
        zshrc_update_or_append "$repo_dir/Cargo.toml" "$FILE_CARGO_TOML_CLIPPY_LINTS"
    fi

    # Install git LFS if not already installed and pull objects
    if [ -s "$repo_dir/.gitattributes" ] && \
        ! grep -q "git-lfs" "$repo_dir/.git/hooks/pre-push"; then

        git lfs install --local
        git lfs pull
    fi
}

zshrc_check_directory() {
    if [ -d "${PWD}/.git" ]; then
        # Is the root of a git repo.
        if git remote -v | grep -qE "(Maxattax97|maxocull\\.com|alanocull\\.com)"; then
            zshrc_setup_repo
            echo "Personal repository detected and updated"
        fi
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
    zshrc_set_path
    zshrc_enter_tmux
    #zshrc_display_banner

    zshrc_autoload
    zshrc_source
    zshrc_set_default_programs
    zshrc_set_aliases
    zshrc_load_library

    zshrc_auto_window_title
    zshrc_set_options

    if ( ! $zshrc_low_power ); then
        # Do this for now instead of `export TERM=xterm-256color` to avoid
        # annoying ZSH message. using xterm will break vim colors, and change
        # functionality of many other programs to not work.
        POWERLEVEL9K_IGNORE_TERM_COLORS=true
        zshrc_powerlevel9k
    else
        zshrc_raw_prompt
    fi

    zshrc_aura_shrc

    if ( ! $zshrc_dropping_mode ); then
        zshrc_zplug
        zshrc_extensions
    fi

    # Load this after plugins so that we can get completions too.
    zshrc_setup_completion

    if ( $zshrc_dropping_mode ); then
        zshrc_dropping_mode=false
    fi

    # Hook for checking the current directory.
    add-zsh-hook chpwd zshrc_check_directory

    zshrc_benchmark_stop
}

zshrc_init
