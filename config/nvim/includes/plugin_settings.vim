" vim: foldmethod=marker
" ALE {{{
" Add an error indicator to ALE.
let g:ale_sign_column_always = 1

" Enable virtualtext.
let g:ale_virtualtext_cursor = 0
let g:ale_virtualtext_prefix = ' ]] '

"let g:ale_javascript_clangformat_options = '-style=file -assume-filename=file.js'
"let g:ale_c_clangformat_options = '-style=file'

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\   'json': ['jq'],
\   'jsx': ['eslint'],
\   'python': ['black'],
\   'rust': ['rustfmt'],
\   'typescript': ['eslint'],
\   'xml': ['xmllint'],
\   'yaml': [],
\}

" Disable ALE for C/C++, Python, use LSP exclusively.
let g:ale_linters = {
\   'c': [],
\   'cpp': [],
\   'css': [],
\   'go': [],
\   'html': [],
\   'java': [],
\   'javascript': [],
\   'json': [],
\   'jsx': [],
\   'python': [],
\   'ruby': [],
\   'rust': [],
\   'typescript': [],
\   'yaml': [],
\}

" Automatically fix on save.
let g:ale_fix_on_save = 1
" }}}

" Copilot {{{
let g:copilot_filetypes = {
\ 'gitcommit': v:true,
\ 'markdown': v:true,
\ 'yaml': v:true
\}

function! AddCopilotWorkspaceFolderIfExists(folder)
    " Expand the folder path to handle ~
    let l:directory = expand(a:folder)

    " Check if the directory exists
    if isdirectory(l:directory)
        " Add the directory to the copilot_workspace_folders list
        if exists("g:copilot_workspace_folders")
            " Append to the existing list
            call add(g:copilot_workspace_folders, l:directory)
        else
            " Create a new list with the directory
            let g:copilot_workspace_folders = [l:directory]
        endif
    endif
endfunction

call AddCopilotWorkspaceFolderIfExists('~/src')
call AddCopilotWorkspaceFolderIfExists('~/aura')
" }}}

" Signify {{{
let g:signify_vcs_list = [ 'git', 'perforce', 'hg', 'svn' ]

" Real time automatically saves/writes the file each time you idle, exit
" buffer, etc. This causes issues with ALE's auto fixers, e.g. removing
" trailing lines and trimming whitespace.
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

" Task Juggler {{{
let g:NERDCustomDelimiters = { 'tjp': { 'left': '#' }, 'tji': { 'left': '#' } }
" }}}

" }}}
"
" Denite {{{
" https://www.freecodecamp.org/news/a-guide-to-modern-web-development-with-neo-vim-333f7efbf8e2/
try
" Use ripgrep for searching current directory for files
" By default, ripgrep will respect rules in .gitignore
"   --files: Print each file that would be searched (but don't search)
"   --glob:  Include or exclues files for searching that match the given glob
"            (aka ignore .git files)
"   -i for insensitive instead of -S for smart case because Denite will sort
"   it on it's own using sublime sorter.
"
call denite#custom#var('file/rec', 'command', ['rg', '-i', '--files', '--glob', '!.git', '--glob', '!node_modules', '--max-filesize', '50K'])

" Use ripgrep in place of "grep"
call denite#custom#var('grep', 'command', ['rg'])

" Custom options for ripgrep
"   --vimgrep:  Show results with every match on it's own line
"   --hidden:   Search hidden directories and files
"   --heading:  Show the file name above clusters of matches from each file
"   --S:        Search case insensitively if the pattern is all lowercase
call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

" Recommended defaults for ripgrep via Denite docs
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Remove date from buffer list
call denite#custom#var('buffer', 'date_format', '')

call denite#custom#source(
\ 'file/rec', 'sorters', ['sorter/sublime'])
call denite#custom#source(
\ 'grep', 'sorters', ['sorter/sublime'])
call denite#custom#source(
\ 'tag', 'sorters', ['sorter/sublime'])
call denite#custom#source(
\ 'buffer', 'sorters', ['sorter/sublime'])
call denite#custom#source(
\ 'file_mru', 'sorters', ['sorter/sublime'])
call denite#custom#source(
\ 'help', 'sorters', ['sorter/help'])

" Custom options for Denite
"   auto_resize             - Auto resize the Denite window height automatically.
"   prompt                  - Customize denite prompt
"   direction               - Specify Denite window direction as directly below current pane
"   winminheight            - Specify min height for Denite window
"   highlight_mode_insert   - Specify h1-CursorLine in insert mode
"   prompt_highlight        - Specify color of prompt
"   highlight_matched_char  - Matched characters highlight
"   highlight_matched_range - matched range highlight
let s:denite_options = {'default' : {
\ 'split': 'floating',
\ 'start_filter': 1,
\ 'auto_resize': 1,
\ 'prompt': 'λ:',
\ 'statusline': 0,
\ 'winrow': 1,
\ 'highlight_matched_char': 'WildMenu',
\ 'highlight_matched_range': 'Visual',
\ 'highlight_prompt': 'StatusLine',
\ 'vertical_preview': 1
\ }}

" Loop through denite options and enable them
function! s:profile(opts) abort
  for l:fname in keys(a:opts)
    for l:dopt in keys(a:opts[l:fname])
      call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
    endfor
  endfor
endfunction

call s:profile(s:denite_options)
catch
  echom 'Denite not installed, skipping configuration.'
endtry
" }}}

" Vista {{{
" INSTALL: pacman -Syu ctags    # https://github.com/universal-ctags/ctags
let g:vista_default_executive = 'ctags'
let g:vista_icon_indent = ['▸ ', '▸ ']
let g:vista#renderer#enable_icon = 1
let g:vista_executive_for = {
 \ 'javascript': 'coc',
 \ 'typescript': 'coc',
 \ 'jsx': 'coc',
 \ 'ruby': 'coc',
 \ 'python': 'coc',
 \ 'java': 'coc',
 \ 'rust': 'coc',
 \ 'html': 'coc',
 \ 'php': 'coc',
 \ 'fsharp': 'coc'
 \ }

let g:vista_echo_cursor_strategy = 'floating_win'
" }}}

" Defx {{{
"call defx#custom#column('icon', {
 "\ 'directory_icon': '▸',
 "\ 'opened_icon': '▾',
 "\ 'root_icon': ' ',
 "\ })

"call defx#custom#column('mark', {
 "\ 'readonly_icon': '✗',
 "\ 'selected_icon': '✓',
 "\ })

"nnoremap <silent><buffer><expr> <CR>
 "\ defx#is_directory() ?
 "\ defx#do_action('open') :
 "\ defx#do_action('multi', ['drop', 'quit'])


"call defx#custom#option('_', 'drives', [
 "\ expand('~/Downloads'), expand('~')
 "\ ])

silent! call defx#custom#option('_', {
 \ 'columns': 'indent:git:icons:filename',
 \ 'winwidth': 35,
 \ 'split': 'vertical',
 \ 'direction': 'topleft',
 \ 'ignored_files': '',
 \ 'show_ignored_files': v:true,
 \ 'toggle': v:true,
 \ 'buffer_name': 'Defx'
 \ })

" }}}

" Miscellaneous {{{
" Causes broken highlighted curly braces.
let g:polyglot_disabled = ['jsx']
"let g:neoformat_javascript_clangformat = {
            "\ 'exe': 'clang-format',
            "\ 'args': ['-style=file', '-assume-filename=file.js'],
            "\ 'stdin': 1
            "\ }

"let g:neoformat_enabled_javascript = ['clangformat']

" Enable rainbow parenthesization.
call rainbow_parentheses#activate()
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
let g:rainbow#blacklist = [242, 243, 246, 247]

" Enable indent guides.
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

" Disable arrow keys (and others) by default. Re-enable with :HardTimeToggle
let g:hardtime_default_on = 1
let g:list_of_normal_keys = ['<UP>', '<DOWN>', '<LEFT>', '<RIGHT>']
let g:list_of_visual_keys = ['<UP>', '<DOWN>', '<LEFT>', '<RIGHT>']
let g:list_of_insert_keys = []
let g:list_of_disabled_keys = []
let g:hardtime_timeout = 2000
let g:hardtime_maxcount = 0
" }}}
