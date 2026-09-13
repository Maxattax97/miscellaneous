#!/usr/bin/env zsh

export DOTFILES_CONTAINER=1
export ZSHRC_ENTER_TMUX=0
export ZSHRC_LOAD_COMPLETIONS=0
export ZSHRC_LOAD_PLUGINS=0

source "${0:A:h}/../dot_zshrc"

zshrc_source_idempotency "${0:A:h}/../dot_zshrc"
