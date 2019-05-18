" Deoplete ----------{{{
let g:deoplete#enable_at_startup = 1

" Use smartcase.
"call deoplete#custom#option('smart_case', v:true)

" <CR>: close popup and save indent.
"inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"function! s:my_cr_function() abort
    "return deoplete#close_popup() . "\<CR>"
"endfunction

" TernJS
"let g:tern_request_timeout = 1

" Eclim
"let g:EclimCompletionMethod = 'omnifunc'

" D Lang
"let g:deoplete#sources#d#dcd_server_autostart = 1

" Omnifunctions
let g:deoplete#omni#functions = {}

"let g:EclimCompletionMethod = 'omnifunc'
"let g:deoplete#omni#functions.java = 'eclim#java#complete#CodeComplete'

"let g:deoplete#omni#functions.javascript = [
"    \ 'tern#Complete',
"    \ 'autocomplete_flow#Complete',
"    \ 'javascriptcomplete#CompleteJS'
"\]

let g:deoplete#omni#functions.css = 'csscomplete#CompleteCSS'

let g:deoplete#omni#functions.html = [
    \ 'htmlcomplete#CompleteTags',
    \ 'xmlcomplete#CompleteTags'
\]

let g:deoplete#omni#functions.xml = 'xmlcomplete#CompleteTags'

let g:deoplete#omni#functions.perl = 'perlomni#PerlComplete'
" }}}



" ALE ----------{{{
" Add an error indicator to ALE.
let g:ale_sign_column_always = 1

" Enable virtualtext.
let g:ale_virtualtext_cursor = 1
" }}}



" Signify ----------{{{
let g:signify_vcs_list = [ 'perforce', 'hg', 'svn', 'bzr', 'cvs', 'darcs', 'fossil', 'hg', 'rcs', 'svn', 'tfs' ]
" Disable git, use fugitive or others instead.
" 'accurev' is broken?

let g:signify_realtime = 1

"let g:signify_cursorhold_insert = 1
"let g:signify_cursorhold_normal = 1
"let g:signify_update_on_bufenter = 0
"let g:signify_update_on_focusgained = 1
" }}}



" UltiSnips ----------{{{
"let g:UltiSnipsSnippetsDir = '~/.config/nvim/my-snippets'
"let g:UltiSnipsExpandTrigger = '<tab>'
"let g:UltiSnipsListSnippets = '<c-tab>'
"let g:UltiSnipsJumpForwardTrigger = '<c-j>'
"let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
" }}}



" SuperTab ----------{{{
let g:SuperTabDefaultCompletionType = '<C-x><C-o>'
let g:UltiSnipsExpandTrigger = '<C-j>'
"inoremap <expr><Tab> pumvisible() ? '\<C-n>' : '\<Tab>'
" }}}


" Airline ----------{{{
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#bufferline#enabled = 1
let g:airline#extensions#tmuxline#enabled = 0
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#csv#enabled = 1
let g:airline#extensions#gutentags#enabled = 1
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#nerdtree#enabled = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" Add ALE's linter to Airline.
"function! LinterStatus() abort
    "let l:counts = ale#statusline#Count(bufnr(''))

    "let l:all_errors = l:counts.error + l:counts.style_error
    "let l:all_non_errors = l:counts.total - l:all_errors

    "return l:counts.total == 0 ? 'OK' : printf(
    "\   '%dW %dE',
    "\   all_non_errors,
    "\   all_errors
    "\)
"endfunction

"set statusline=%{LinterStatus()}
" Disable CoC diagnostics since we are using ALE.
"" Use error and warning count of diagnostics from coc.nvim
"let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
"let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

"" Create a section for language server status.
"function! GetServerStatus()
    "return get(g:, 'coc_status', '')
"endfunction

"call airline#parts#define_function('coc', 'GetServerStatus')

"function! AirlineInit()
    "let g:airline_section_a = airline#section#create(['coc'])
"endfunction

"autocmd User AirlineAfterInit call AirlineInit()

"" Exclude overwrite statusline of list filetype.
"let g:airline_exclude_filetypes = ["list"]
" }}}

" Syntax / File Support ----------{{{
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
" Enable JSDoc syntax highlighting
"let g:javascript_plugin_jsdoc = 1
" }}}
