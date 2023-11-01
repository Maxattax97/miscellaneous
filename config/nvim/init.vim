" vim: set foldmethod=marker:
if &compatible
    set nocompatible
endif

source ~/.config/nvim/includes/preload.vim

" INSTALL: curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | sh -s ~/.cache/dein
" INSTALL: pip2 install neovim
" INSTALL: pip3 install neovim
" INSTALL: npm install -g neovim
" INSTALL: gem install neovim   # Non root?
" :checkhealth
let $CACHE = expand('~/.cache')

if !($CACHE->isdirectory())
    call mkdir($CACHE, 'p')
endif

if &runtimepath !~# '/dein.vim'
    let s:dir = 'dein.vim'->fnamemodify(':p')

    if !(s:dir->isdirectory())
        let s:dir = $CACHE .. '/dein/repos/github.com/Shougo/dein.vim'

        if !(s:dir->isdirectory())
            execute '!git clone https://github.com/Shougo/dein.vim' s:dir
        endif
    endif

    execute 'set runtimepath^='
        \ .. s:dir->fnamemodify(':p')->substitute('[/\\]$', '', '')
endif

" Set dein base path (required)
let s:dein_base = '~/.cache/dein/'

" Set dein source path (required)
let s:dein_src = '~/.cache/dein/repos/github.com/Shougo/dein.vim'

" Set dein runtime path (required)
execute 'set runtimepath+=' .. s:dein_src

" Call dein initialization (required)
call dein#begin(s:dein_base)

call dein#add(s:dein_src)

source ~/.config/nvim/includes/plugins.vim

" Finish dein initialization (required)
call dein#end()

filetype plugin indent on

if has('syntax')
    syntax on
endif

let s:target_file = expand("~/.cache/nvim/last_update")

if filereadable(s:target_file)
  let s:file_age = localtime() - getftime(s:target_file)
else
    let s:file_age = 999999
endif

" Check if the file is older than one week (604800 seconds)
if s:file_age > 604800
    " Automatically install new plugins.
    if dein#check_install()
        call dein#install()
    endif

    call dein#update()

    " Automatically remove unused new plugins.
    if len(dein#check_clean())
        call dein#recache_runtimepath()
        call map(dein#check_clean(), "delete(v:val, 'rf')")
    endif

    " Touch the file with a new timestamp
    call writefile([], s:target_file)
endif

source ~/.config/nvim/includes/language_servers.vim
source ~/.config/nvim/includes/general.vim
source ~/.config/nvim/includes/plugin_settings.vim
source ~/.config/nvim/includes/bindings.vim
source ~/.config/nvim/includes/autocommands.vim
