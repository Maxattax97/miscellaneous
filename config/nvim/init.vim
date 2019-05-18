if &compatible
    set nocompatible
endif

set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" INSTALL: pip2 install neovim
" INSTALL: pip3 install neovim
" INSTALL: npm install -g neovim
" INSTALL: gem install neovim   # Non root?
" :checkhealth
if dein#load_state('~/.cache/dein')
    call dein#begin('~/.cache/dein')

    " I am not 100% certain as to why I need both of these.
    call dein#add('~/.cache/dein/repos/repos/github.com/Shougo/dein.vim')
    call dein#add('Shougo/dein.vim')

    source ~/.config/nvim/includes/plugins.vim

    call dein#end()
    call dein#save_state()
endif

filetype plugin indent on
syntax enable

"" Automatically install new plugins.
if dein#check_install()
    call dein#install()
endif

" TODO: Automated weekly updates.

source ~/.config/nvim/includes/language_servers.vim
source ~/.config/nvim/includes/general.vim
source ~/.config/nvim/includes/plugin_paths.vim
source ~/.config/nvim/includes/plugin_settings.vim
source ~/.config/nvim/includes/bindings.vim
source ~/.config/nvim/includes/autocommands.vim
source ~/.config/nvim/includes/themes.vim
