" ALE {{{
" Add an error indicator to ALE.
let g:ale_sign_column_always = 1

" Enable virtualtext.
let g:ale_virtualtext_cursor = 1

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\   'typescript': ['eslint'],
\   'jsx': ['eslint'],
\   'python': ['black'],
\}

" Automatically fix on save.
let g:ale_fix_on_save = 1
" }}}

" Signify {{{
let g:signify_vcs_list = [ 'git', 'perforce', 'hg', 'svn' ]

let g:signify_realtime = 0
let g:signify_sign_change = '~'
let g:signify_sign_delete = '-'
let g:signify_sign_delete_first_line = '-'
let g:signify_sign_changedelete = '!'
" }}}

" SuperTab {{{
let g:SuperTabDefaultCompletionType = '<C-x><C-o>'
let g:UltiSnipsExpandTrigger = '<C-j>'
"inoremap <expr><Tab> pumvisible() ? '\<C-n>' : '\<Tab>'
" }}}

" Airline {{{
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#bufferline#enabled = 1
let g:airline#extensions#tmuxline#enabled = 0
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#csv#enabled = 1
let g:airline#extensions#gutentags#enabled = 1
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#nerdtree#enabled = 1
let g:airline#extensions#obsession#enabled = 1
let g:airline#extensions#fugitiveline#enabled = 1
let g:airline#extensions#denite#enabled = 1
let g:airline#extensions#undotree#enabled = 1
let g:airline#extensions#coc#enabled = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" This will keep your messages from getting quickly hidden.
let g:bufferline_echo = 0
" }}}

" Startify {{{
let g:startify_custom_header = [
    \ '      __  ___                 __  __              ',
    \ '     /  |/  /___ __  ______ _/ /_/ /_____ __  __  ',
    \ '    / /|_/ / __ `/ |/_/ __ `/ __/ __/ __ `/ |/_/  ',
    \ '   / /  / / /_/ />  </ /_/ / /_/ /_/ /_/ />  <    ',
    \ '  /_/  /_/\__,_/_/|_|\__,_/\__/\__/\__,_/_/|_|    ',
    \ ]

" }}}

" Syntax / File Support {{{
" Go {{{
let g:go_code_completion_enabled = 1
let g:go_metalinter_autosave = 0
let g:go_metalinter_enabled = []
let g:go_metalinter_disabled = ['vet', 'golint', 'errcheck']
let g:go_fmt_fail_silently = 1
" }}}

" }}}

" Miscellaneous {{{
" Enable rainbow parenthesization.
"call rainbow_parentheses#activate()

" Enable indent guides.
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
" }}}
