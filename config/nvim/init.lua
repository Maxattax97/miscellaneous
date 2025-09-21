-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("legacy.preload") -- replaces preload.vim

require("config.lazy")

-- Load legacy, ported vim scripts
require("legacy.options") -- replaces general.vim
require("legacy.keymaps") -- replaces bindings.vim
require("legacy.autocmds") -- replaces autocommands.vim
require("legacy.lsp") -- replaces language_servers.vim
require("legacy.settings") -- replaces plugin_settings.vim
