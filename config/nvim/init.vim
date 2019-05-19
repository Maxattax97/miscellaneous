if &compatible
    set nocompatible
endif

set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" INSTALL: curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | sh -s ~/.cache/dein
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

" Automatically install new plugins.
if dein#check_install()
    call dein#install()

    " Uninstall unused plugins.
    "call map(dein#check_clean(), "delete(v:val, 'rf')")
endif

" TODO: Automated weekly updates.

source ~/.config/nvim/includes/language_servers.vim
source ~/.config/nvim/includes/general.vim
source ~/.config/nvim/includes/plugin_settings.vim
source ~/.config/nvim/includes/bindings.vim
source ~/.config/nvim/includes/autocommands.vim
