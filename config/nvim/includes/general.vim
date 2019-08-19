" vim: foldmethod=marker
" General {{{
" Make controls more comfortable for line wrapping.
set backspace=eol,start,indent
set whichwrap+=<,>,h,l,[,]

" Detect line endings, but prefer Unix endings.
set fileformats=unix,dos,mac

" Allow switching to other buffers without requiring a save.
set hidden

" Attempt to fix colors and improve performance cheaply.
set termguicolors
set lazyredraw
set guioptions=M

" Faster cursorhold events and swapfile writing.
set updatetime=250

" Enable some mouse control.
set mouse=a

" Setup backup(, swap, undo) files.
set directory=$HOME/.cache/nvim/swap/
set backupdir=$HOME/.cache/nvim/backup/
set undodir=$HOME/.cache/nvim/undo/
set undofile

if !isdirectory(&backupdir)
    call mkdir(&backupdir, "p")
endif

if !isdirectory(&directory)
    call mkdir(&directory, "p")
endif

if !isdirectory(&undodir)
    call mkdir(&undodir, "p")
endif
" }}}

" File Format {{{
set encoding=utf-8
filetype plugin indent on
syntax on

" Default formatting when not detected.
set autoindent
set smartindent
set smarttab
set shiftround
set softtabstop=4
set tabstop=4
set shiftwidth=4

" Default to TABS when not detected.
"set noexpandtab

" Default to SPACES when not detected
set expandtab

" Expand the modeline so we can read all the tags at the beginning.
set modeline
set modelines=5

" Folds
set foldmethod=indent
set foldnestmax=3

" Open splits on the top, and right sides.
"set splitright

" }}}

" Aesthetics {{{
" Show line numbers.
" NOTE: Controlled by a plugin. Disable relativenumber to improve performance.
set number
"set relativenumber

" Both the standard and Github's line length.
set colorcolumn=80,125

" Highlight the cursor's line.
" NOTE: Disable for performance improvement.
set cursorline

" Blink matching enclosures.
set showmatch
set matchtime=2

" Keep lines above or below the cursor at all times
set scrolloff=7

" Increase command bar height (for Echodoc).
" Disable showmode since Airline does it for us.
"set cmdheight=2
set noshowmode

" Try to set the default font.
set guifont=Hack\ Nerd\ Font\ 9

" Use my custom Galactic colorscheme.
colorscheme galactic

" This will repair colors in Tmux/Screen sessions.
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
"set t_8b=[48;2;%lu;%lu;%lum
"set t_8f=[38;2;%lu;%lu;%lum
" }}}

" Tools {{{
" In autocmpletion, show the option that has the most matches, and display
" even if there is only a single option.
set completeopt=menuone,longest,preview

" Wildmode
set wildmenu
set wildmode=list,longest,full

" RegEx search settings.
set ignorecase
set smartcase
set hlsearch
set incsearch

" Use the system clipboard.
set clipboard+=unnamedplus
" }}}
