#!/usr/bin/env bash
set -euo pipefail

if [[ ! -d "${HOME}/.tmux/plugins/tpm" ]] && command -v git > /dev/null 2>&1; then
    mkdir -p "${HOME}/.tmux/plugins"
    git clone "https://github.com/tmux-plugins/tpm" "${HOME}/.tmux/plugins/tpm"
fi
