"""""""""""""""""""
" NEOVIM SETTINGS "
"""""""""""""""""""
set nocompatible
set encoding=utf-8
syntax on
filetype on
filetype plugin on
filetype indent on

"" Format
set autoindent smartindent softtabstop=4 tabstop=4 shiftwidth=4
""" Use Tabs
set noexpandtab
""" Use Spaces
" set expandtab

"" Features
set number
set whichwrap+=<,>,h,l,[,]
set cursorline

"" Graphical
set termguicolors
set lazyredraw
set ttyfast

"" Additional Filetypes
autocmd BufRead,BufNewFile *.aatstest set filetype=json

"" Enable python
let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

"" Use system clipboard
set clipboard+=unnamedplus

""""""""""""""""
" LOAD PLUGINS "
""""""""""""""""
call plug#begin('~/.local/share/nvim/plugged')

"" Modules
Plug 'w0rp/ale'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-fugitive'
" Plug 'mhinz/vim-signify' " SLOW, BUGGY
Plug 'scrooloose/nerdcommenter'
Plug 'sbdchd/neoformat'
Plug 'bling/vim-bufferline'
Plug 'farmergreg/vim-lastplace'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'sirver/ultisnips' " REQUIRES SOME FURTHER CONFIGURATION & SNIPPETS
Plug 'honza/vim-snippets'
Plug 'ervandew/supertab'
Plug 'godlygeek/tabular'
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
" Plug 'scrooloose/syntastic'
" Plug 'valloric/youcompleteme'
" Plug 'rdnetto/YCM-Generator', {'branch': 'stable'}

"" Syntax / File Support
Plug 'sheerun/vim-polyglot'
" Plug 'elzr/vim-json'
" Plug 'pangloss/vim-javascript'

"" Autocompletion
Plug 'zchee/deoplete-clang'
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
Plug 'sebastianmarkow/deoplete-rust'
Plug 'shougo/neoinclude.vim'
Plug 'zchee/deoplete-jedi'
Plug 'shougo/neco-vim'
Plug 'artur-shaik/vim-javacomplete2'
" Plug 'tweekmonster/deoplete-clang2'
" Plug 'c9s/perlomni.vim'

"" Themes
Plug 'lifepillar/vim-solarized8'
Plug 'mhartington/oceanic-next'
Plug 'dikiaap/minimalist'
Plug 'flazz/vim-colorschemes'
Plug 'felixhummel/setcolors.vim'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'

"" Under Investigation
" Plug 'metakirby5/codi' " INVESTIGATE REPL DEPENDENCIES
" Plug 'mhinz/vim-startify'
" Plug 'Shougo/denite.nvim'
" Plug 'bagrat/vim-workspace'
" Plug 'Xuyuanp/nerdtree-git-plugin'
" Plug 'vim-scripts/dbext.vim'
" Debuggers, diagnostics, R language, 

call plug#end()

""""""""""
" THEMES "
""""""""""
"" Font
set guifont=DejaVuSansMono\ Nerd\ Font\ 9
"set guifont=Ubuntu\ Mono\ derivative\ Powerline\ Regular

"" Colorscheme
colorscheme solarized8_dark
" colorscheme OceanicNext
" colorscheme minimalist
" hi Normal guibg=NONE ctermbg=NONE
" hi NonText guibg= NONE ctermbg=NONE

"" Airline
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
" let g:airline_theme='oceanicnext'
" let g:airline_theme='powerlineish'
" let g:airline_theme='minimalist'

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

"" Bufferline
let g:airline#extensions#bufferline#enabled = 1
let g:bufferline_echo = 0 " This will keep your messages from getting quickly hidden.

""""""""""""
" DEOPLETE "
""""""""""""
let g:deoplete#enable_at_startup = 1

" Deoplete tab-complete
" inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

"" Deoplete per-autocompleter settings
""" Clang
let g:deoplete#sources#clang#libclang_path = '/usr/lib/i386-linux-gnu/libclang-4.0.so.1'
let g:deoplete#sources#clang#clang_header = '/usr/lib/llvm-4.0/lib/clang/4.0.0/include'

""" TernJS
let g:tern_request_timeout = 1
" let g:tern_show_signature_in_pum = '0'

""" Rust
let g:deoplete#sources#rust#racer_binary='/home/bats/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path='/home/bats/src/rust/src'

""" Java
autocmd FileType java setlocal omnifunc=javacomplete#Complete

"""""""
" ALE "
"""""""
" Add an error indicator to Ale
let g:ale_sign_column_always = 1

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction

set statusline=%{LinterStatus()}

"""""""""""
" SIGNIFY "
""""""""""
" acurev
let g:signify_vcs_list = [ 'git', 'perforce', 'hg', 'svn','bzr', 'cvs', 'darcs', 'fossil', 'hg', 'rcs', 'svn', 'tfs' ]
let g:signify_realtime = 1
" let g:signify_cursorhold_insert = 1
" let g:signify_cursorhold_normal = 1
" let g:signify_update_on_bufenter = 0
" let g:signify_update_on_focusgained = 1

"""""""""""""
" GITGUTTER "
"""""""""""""
" Set GitGutter's update time to 250ms
set updatetime=250

"""""""""""""
" ULTISNIPS "
"""""""""""""
let g:UltiSnipsSnippetsDir = '~/.config/nvim/my-snippets'
" let g:UltiSnipsExpandTrigger = "<tab>"
" let g:UltiSnipsListSnippets = "<c-tab>"
" let g:UltiSnipsJumpForwardTrigger = "<c-j>"
" let g:UltiSnipsJumpBackwardTrigger = "<c-k>"



""""""""""""
" SUPERTAB "
""""""""""""
" let g:SuperTabDefaultCompletionType = "<C-n>"

"""""""""""""""""""""""""
" SYNTAX / FILE SUPPORT "
"""""""""""""""""""""""""
" Enable JSDoc syntax highlighting
let g:javascript_plugin_jsdoc = 1

" Ale alias for .aatstest
" let g:ale_linters = {'aatstest': ['jsonlint']}
" call ale#linter#Define('aatstest', g:aatstest)
" let ale_linter_aliases = {'json': ['json', 'aatstest']}

"""""""""""""""""""""""""""
" STARTUP / MISCELLANEOUS "
"""""""""""""""""""""""""""
" Enable NERDTree and Tagbar, recenter the cursor as well
autocmd vimenter * NERDTree
autocmd VimEnter * wincmd p
autocmd vimenter * Tagbar
