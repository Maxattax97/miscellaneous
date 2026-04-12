# `dotfiles`

[![Build Status](https://github.com/Maxattax97/miscellaneous/actions/workflows/ci.yaml/badge.svg?branch=master)](https://github.com/Maxattax97/miscellaneous/actions/workflows/ci.yaml)

## Screenshots

![btop, ctop, tmux, man, neofetch](assets/btop.png)

![zathura, pcmanfm, qalculate](assets/zathura.png)

![neovim](assets/neovim.png)

![sxiv, rofi, dunst, chatgpt, st](assets/sxiv.png)

![weechat, newsboat](assets/weechat.png)

![rofi](assets/rofi.png)

## Installation

Directly with `chezmoi`:

```bash
chezmoi init --apply git@github.com:Maxattax97/miscellaneous.git
```

Or, if you prefer to clone the repo yourself first, the bootstrap script now just
sets this checkout as your `chezmoi` source and applies it:

```bash
./install.sh
```

### `zsh`

Open a fresh shell and let the zsh plugins automatically install. You may have to restart your shell, sometimes it breaks.

```bash
zsh
```

### `tmux`

In tmux, you must install your plugins with the key combination `Ctrl-a I`.

### `nvim`

Open neovim to have it automatically install plugins. It will also automatically update every week.

```bash
nvim
```

## Updating

If you initialized from the remote repo, update with:

```bash
chezmoi update
```

If you are working from a local clone, pull your changes and re-apply them:

```bash
git pull
chezmoi apply
```

## Overview

This repository contains configurations for:

- `bash`
- `bspwm`
- `btop`
- `chrony`
- `copyq`
- `dunst`
- `lcov`
- `mpd`
- `ncmpcpp`
- `neovim`
- `newsboat`
- `pacman`
- `pcmanfm`
- `picom`
- `polybar`
- `radare`
- `rofi`
- `sxhkd`
- `tmux`
- `variety`
- `weechat`
- `x11`
- `zathura`
- `zsh`

## `lcov`

![lcov](assets/lcov.png)

## Credits

Environment inspired by [Bresilla](https://github.com/bresilla/dotfiles/).

Check out my site at [maxocull.com](https://www.maxocull.com/)!
