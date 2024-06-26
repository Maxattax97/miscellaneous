"""""""""""""""""""
" NEOVIM SETTINGS "
"""""""""""""""""""
set nocompatible
set encoding=utf-8
syntax on
filetype on
filetype plugin on
filetype indent on

"" Default formatting when not detected
set autoindent smartindent softtabstop=4 tabstop=4 shiftwidth=4
""" Default to tabs when not detected
" set noexpandtab
" set list lcs=tab:\┊\
" let g:indentLine_char = '┊'
""" Default to spaces when not detected
set expandtab

"" Features
set number
set backspace=eol,start,indent
set whichwrap+=<,>,h,l,[,]
set colorcolumn=80,125 " Comfortable _and_ Github's line length
set cursorline " Slow
set relativenumber " Slow
set encoding=utf8
set fileformats=unix,dos,mac
set completeopt=longest,menuone " Preview mode causes flickering
set mouse=a " Enable mouse control (includes scrolling).

"" Match braces
set showmatch
set matchtime=2

" Keep lines above or below the cursor at all times
set scrolloff=5

"" Increase command height for echodoc
set cmdheight=2

"" Wildmode
set wildmenu
set wildmode=list:longest,full

"" Hide buffers when abandoned
set hidden

"" Regex settings
set ignorecase
set smartcase
set hlsearch
set incsearch

"" Folds
set foldmethod=indent
set foldnestmax=3

"" Graphical
" let $NVIM_TUI_ENABLE_CURSOR_SHAPE=0
set termguicolors
set lazyredraw
set guioptions=M " Improves load time by ~50ms
" set synmaxcol=125
" syntax sync minlines=255

map <F6> :make<CR>
nnoremap <c-z> <nop>
nnoremap <F5> :source $MYVIMRC<CR>

set directory=$HOME/.cache/nvim/swap/
set backupdir=$HOME/.cache/nvim/backup/
set undodir=$HOME/.cache/nvim/undo/

if !isdirectory(&backupdir)
    call mkdir(&backupdir, "p")
endif

if !isdirectory(&directory)
    call mkdir(&directory, "p")
endif

if !isdirectory(&undodir)
    call mkdir(&undodir, "p")
endif

"" Additional Filetypes
augroup neovim_studio_filetypes
    autocmd!
    autocmd BufRead,BufNewFile *.aatstest set filetype=json
    autocmd BufRead,BufNewFile *.colortemplate set filetype=colortemplate
augroup END

"" Enable python
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

"" Use system clipboard
set clipboard+=unnamedplus

"" Add other settings to this file to make Neovim Studio more comfortable
"source $NEOVIM_STUDIO_DIR/includes/general.vim

""""""""""""""""
" LOAD PLUGINS "
""""""""""""""""
if !isdirectory('~/.cache/dein')
    echom "Installing Dein ..."
    system('curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | sh -s ~/.cache/dein')
endif

call plug#begin('~/.local/share/nvim/plugged')

"" Add additional plugins to this file
"source $NEOVIM_STUDIO_DIR/includes/plugins.vim

"" Modules
"" Eclim was manually installed.
Plug 'w0rp/ale'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdcommenter'
Plug 'sbdchd/neoformat'
Plug 'bling/vim-bufferline'
Plug 'farmergreg/vim-lastplace'

Plug 'sirver/ultisnips' " REQUIRES SOME FURTHER CONFIGURATION & SNIPPETS
Plug 'honza/vim-snippets'
Plug 'ervandew/supertab'
Plug 'godlygeek/tabular'
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-css-color'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'mhinz/vim-startify'
Plug 'chiel92/vim-autoformat'
Plug 'tpope/vim-surround'
Plug 'luochen1990/rainbow'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'shougo/echodoc.vim'
Plug 'tpope/vim-sleuth'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-unimpaired'
Plug 'shougo/denite.nvim'
Plug 'tpope/vim-abolish'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
" Plug 'ctrlpvim/ctrlp.vim'
 Plug 'mhinz/vim-signify' " Disabled, might re-enable later.

"" Syntax / File Support
Plug 'sheerun/vim-polyglot'
Plug 'vim-perl/vim-perl', { 'for': 'perl', 'do': 'make clean carp dancer highlight-all-pragmas moose test-more try-tiny' }
" Plug 'elzr/vim-json'
" Plug 'pangloss/vim-javascript'

"" Autocompletion
Plug 'zchee/deoplete-clang'
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
Plug 'ternjs/tern_for_vim'
Plug 'wokalski/autocomplete-flow'
Plug 'sebastianmarkow/deoplete-rust'
Plug 'shougo/neoinclude.vim'
Plug 'zchee/deoplete-jedi'
Plug 'shougo/neco-vim'
Plug 'landaire/deoplete-d'
Plug 'othree/csscomplete.vim'
Plug 'othree/html5.vim'
Plug 'othree/xml.vim'
Plug 'c9s/perlomni.vim'
"Plug 'cquery-project/cquery'
" Plug 'artur-shaik/vim-javacomplete2'
" Plug 'tweekmonster/deoplete-clang2'

"" Themes
Plug 'maxattax97/vim-galactic'
Plug 'lifepillar/vim-solarized8'
Plug 'mhartington/oceanic-next'
Plug 'dikiaap/minimalist'
Plug 'flazz/vim-colorschemes'
Plug 'felixhummel/setcolors.vim'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'nathanaelkane/vim-indent-guides'

"" Under Investigation
" Plug ''
" Plug 'idanarye/vim-dutyl' " Requires DMD and DCD
" Plug 'metakirby5/codi' " INVESTIGATE REPL DEPENDENCIES
" Plug 'Shougo/denite.nvim'
" Plug 'bagrat/vim-workspace'
" Plug 'vim-scripts/dbext.vim'
    " OR Plug 'nathanaelkane/vim-indent-guides'
" Plug 'raimondi/delimitmate'
" Plug 'terryma/vim-multiple-cursors'
" Plug 'sjl/gundo.vim'
" Plug 'tpope/vim-unimpaired'
" Plug 'tpope/vim-sensible'
" Plug 'janko-m/vim-test'
    " WITH Plug 'tpope/dispatch'
" Plug 'editorconfig/editorconfig-vim'
" Plug 'thinca/vim-quickrun'
" Plug 'bronson/vim-trailing-whitespace'
" Plug 'plugin/vim-paste-easy'
" Plug 'godlygeek/csapprox'
" Plug 'gregsexton/matchtag'
" Plug 'mattn/emmet-vim'
" Plug 'yuttie/comfortable-motion.vim' " Debatable, could slow down productivity
" Debuggers, diagnostics, R language, syntaxes, autocompletes, formatters
" Consider switching to Dein
" Test over an SSH Connection

call plug#end()

""""""""""
" THEMES "
""""""""""
"" Font
set guifont=Hack\ Nerd\ Font\ 9

"" Colorscheme
colorscheme galactic

"" This will repair colors in Tmux.
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" colorscheme OceanicNext
" colorscheme minimalist
" hi Normal guibg=NONE ctermbg=NONE
" hi NonText guibg= NONE ctermbg=NONE

"" Airline
let g:airline_theme='galactic'
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

"" Tmuxline
let g:airline#extensions#tmuxline#enabled = 0 " Airline breaks tmuxline for some reason.
let g:tmuxline_theme = 'vim_statusline_3'
let g:tmuxline_preset = 'tmux'

"" Indent Lines
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

""""""""
" GOYO "
""""""""

autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

""""""""""""
" NERDTREE "
""""""""""""
"" This setting causes issues because new windows do not open as expected in afterward.
" let g:nerdtree_tabs_open_on_console_startup = 1

""""""""""""
" DEOPLETE "
""""""""""""
let g:deoplete#enable_at_startup = 1

"" Deoplete per-autocompleter settings
""" Clang
"source $NEOVIM_STUDIO_DIR/includes/clang.vim
" let g:deoplete#sources#clang#libclang_path = '/lib/libclang.so' " '/usr/lib/i386-linux-gnu/libclang-4.0.so.1'
" let g:deoplete#sources#clang#clang_header = '/lib/clang/4.0.0/include' " '/usr/lib/llvm-4.0/lib/clang/4.0.0/include'

""" TernJS
let g:tern_request_timeout = 1
" let g:tern_show_signature_in_pum = '0'
let g:deoplete#sources#ternjs#depths = 1
let g:deoplete#sources#ternjs#types = 1
let g:deoplete#sources#ternjs#docs = 1
let g:tern#command = ["tern"]
let g:tern#arguments = ["--persistent"]

""" Rust
"source $NEOVIM_STUDIO_DIR/includes/rust.vim
" let g:deoplete#sources#rust#racer_binary=system('echo "${HOME}/.cargo/bin/racer"')
" let g:deoplete#sources#rust#rust_source_path=system('echo "${NEOVIM_STUDIO_DIR}/rust/src"')

""" Java
" autocmd FileType java setlocal omnifunc=javacomplete#Complete

""" D Lang
"" These have been appended to $PATH
" let g:deoplete#sources#d#dcd_client_binary = ''
" let g:deoplete#sources#d#dcd_server_binary = ''
let g:deoplete#sources#d#dcd_server_autostart = 1

""" Omnifunctions
let g:deoplete#omni#functions = {}

let g:EclimCompletionMethod = 'omnifunc'
let g:deoplete#omni#functions.java = 'eclim#java#complete#CodeComplete'

let g:deoplete#omni#functions.javascript = [
    \ 'tern#Complete',
    \ 'autocomplete_flow#Complete',
    \ 'javascriptcomplete#CompleteJS'
\]
let g:deoplete#omni#functions.css = 'csscomplete#CompleteCSS'
let g:deoplete#omni#functions.html = [
    \ 'htmlcomplete#CompleteTags',
    \ 'xmlcomplete#CompleteTags'
\]
let g:deoplete#omni#functions.xml = 'xmlcomplete#CompleteTags'
let g:deoplete#omni#functions.perl = 'perlomni#PerlComplete'

""""""""""""""""""""
" LANGUAGE SERVERS "
""""""""""""""""""""

"let g:LanguageClient_serverCommands = {
    "\ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    "\ 'javascript.jsx': ['flow-language-server', '--stdio'],
    "\ 'javascript': ['flow-language-server', '--stdio'],
    "\ }
" \ 'javascript': ['node', '/home/max/.neovim-studio/language-servers/javascript-typescript-langserver/lib/language-server-stdio'],
"nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
"nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
"nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

"""""""
" ALE "
"""""""
"" Add an error indicator to Ale
" let g:ale_sign_column_always = 1

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

"nmap <silent> <leader>e <Plug>(ale_next_wrap)
"nmap <silent> <leader>q <Plug>(ale_previous_wrap)

"""""""""""
" SIGNIFY "
"""""""""""
" accurev
" Don't do git since we have GitGutter as well.
let g:signify_vcs_list = [ 'perforce' ] ", 'hg', 'svn','bzr', 'cvs', 'darcs', 'fossil', 'hg', 'rcs', 'svn', 'tfs' ]

" Enabling realtime autosaves the buffer.
let g:signify_realtime = 1
"let g:signify_cursorhold_insert = 1
"let g:signify_cursorhold_normal = 1
"let g:signify_update_on_bufenter = 1
"let g:signify_update_on_focusgained = 1

"""""""""""""
" GITGUTTER "
"""""""""""""
"" Set GitGutter's update time to 250ms
set updatetime=250

"""""""""""""
" ULTISNIPS "
"""""""""""""
"source $NEOVIM_STUDIO_DIR/includes/ultisnips.vim
" let g:UltiSnipsSnippetsDir = '~/.config/nvim/my-snippets'
" let g:UltiSnipsExpandTrigger = '<tab>'
" let g:UltiSnipsListSnippets = '<c-tab>'
" let g:UltiSnipsJumpForwardTrigger = '<c-j>'
" let g:UltiSnipsJumpBackwardTrigger = '<c-k>'

"""""""""""""""""""""""""""""""""""""
" SUPERTAB (AND COMPLETION HOTKEYS) "
"""""""""""""""""""""""""""""""""""""
let g:SuperTabDefaultCompletionType = '<C-x><C-o>'
let g:UltiSnipsExpandTrigger = '<C-j>'
inoremap <expr><Tab> pumvisible() ? '\<C-n>' : '\<Tab>'

"""""""""""""""""""""""""
" SYNTAX / FILE SUPPORT "
"""""""""""""""""""""""""
"" Enable JSDoc syntax highlighting
let g:javascript_plugin_jsdoc = 1

"" Ale alias for .aatstest
" let g:ale_linters = {'aatstest': ['jsonlint']}
" call ale#linter#Define('aatstest', g:aatstest)
" let ale_linter_aliases = {'json': ['json', 'aatstest']}

"""""""""""""""""""""""""""
" STARTUP / MISCELLANEOUS "
"""""""""""""""""""""""""""
noremap <C-p> :Denite buffer file_rec tag<CR>

"" Strip trailing whitespace for 99% of filetypes
function! StripTrailingWhitespace()
    " Filetype blacklist
    if &filetype =~ 'markdown\|whitespace'
        return
    endif
    %s/\s\+$//e
endfun

"" Enable NERDTree and Tagbar, recenter the cursor, strip trailing whitespace
augroup neovim_studio
    autocmd!
    autocmd BufWritePre * call StripTrailingWhitespace()
    autocmd vimenter * NERDTree
    autocmd vimenter * wincmd p
    autocmd vimenter * Tagbar
augroup END

"" Append any other overwrites or settings here
"source $NEOVIM_STUDIO_DIR/includes/settings.vim
