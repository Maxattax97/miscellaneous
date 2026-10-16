#!/usr/bin/env zsh
# shellcheck shell=bash
# ShellCheck has no Zsh parser; this test uses Zsh path modifiers.
# shellcheck disable=SC2296

set -eu
setopt noclobber

# Load only the template helpers, without running interactive shell setup.
eval "$(sed -n '/^zshrc_update_or_append() {/,/^zshrc_setup_repo() {/p' "${0:A:h}/../.zshrc" | sed '$d')"

test_dir=$(mktemp -d)
trap 'rm -rf -- "$test_dir"' EXIT
print -r -- 'template content' > "$test_dir/template"

# A new destination must be created even when the caller enables noclobber.
zshrc_update_or_append "$test_dir/config" "$test_dir/template"
[[ -f "$test_dir/config" ]]
grep -Fxq 'template content' "$test_dir/config"
zshrc_update_or_append "$test_dir/config" "$test_dir/template"
[[ $(grep -Fxc 'template content' "$test_dir/config") == 1 ]]
[[ -o noclobber ]]

print -r -- 'template guards passed with noclobber enabled'
