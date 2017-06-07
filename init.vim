set nocompatible
set encoding=utf-8
set termguicolors
syntax on
filetype on
filetype plugin on
filetype indent on

set number
set whichwrap+=<,>,h,l,[,]

set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4

set cursorline

set lazyredraw
set ttyfast

" Enable python
let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

call plug#begin('~/.local/share/nvim/plugged')

" Plug 'scrooloose/syntastic'
Plug 'w0rp/ale'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Plug 'valloric/youcompleteme'
" Plug 'rdnetto/YCM-Generator', {'branch': 'stable'}
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'pangloss/vim-javascript'
Plug 'flazz/vim-colorschemes'
Plug 'felixhummel/setcolors.vim'
Plug 'dikiaap/minimalist'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdcommenter'

" Autocompletion Plugins
Plug 'zchee/deoplete-clang'
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
Plug 'sebastianmarkow/deoplete-rust'
" Plug 'tweekmonster/deoplete-clang2'

call plug#end()

" Start up Deoplete
let g:deoplete#enable_at_startup = 1

" Load Deoplete's completion plugins
"" Clang
let g:deoplete#sources#clang#libclang_path = '/usr/lib/i386-linux-gnu/libclang-4.0.so.1'
let g:deoplete#sources#clang#clang_header = '/usr/lib/llvm-4.0/lib/clang/4.0.0/include'
"" TernJS
let g:tern_request_timeout = 1
" let g:tern_show_signature_in_pum = '0'
"" Rust
let g:deoplete#sources#rust#racer_binary='/home/bats/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path='/home/bats/src/rust/src'

" Java Omni-completion
" autocmd FileType java setlocal omnifunc=javacomplete#Complete

" Setup themes
" set guifont=Ubuntu\ Mono\ derivative\ Powerline\ Regular

colorscheme minimalist

" let g:airline_theme='powerlineish'
let g:airline_theme='minimalist'
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" hi Normal guibg=NONE ctermbg=NONE
" hi NonText guibg= NONE ctermbg=NONE

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

" Set GitGutter's update time to 250ms
set updatetime=250

" Enable JSDoc syntax highlighting
let g:javascript_plugin_jsdoc = 1

" Deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" Enable NERDTree and Tagbar, recenter the cursor as well
autocmd vimenter * NERDTree
autocmd VimEnter * wincmd p
autocmd vimenter * Tagbar
