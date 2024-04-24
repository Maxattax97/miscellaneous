" TODO LIST
" Spell checking: spell spelllang=en_us
" Cursor line wrapping
" Merge configuration with Neovim Studio
" Plugins: vim-sleuth, vim-lastplace

func! bootstrap#before() abort
    set modeline
    set modelines=5

    let g:vim_arduino_library_path = '/home/max/.local/share/arduino/'
    " let g:vim_arduino_serial_port = /my/serial/port

    let g:startify_custom_header = [
        \ '       _   __                _         ',
        \ '      / | / /__  ____ _   __(_)___ ___ ',
        \ '     /  |/ / _ \/ __ \ | / / / __ `__ \',
        \ '    / /|  /  __/ /_/ / |/ / / / / / / /',
        \ '   /_/_||||_||/\____/|___/|||/ /_/ /_/ ',
        \ '     / ___// /___  ______/ (_)___      ',
        \ '     \__ \/ __/ / / / __  / / __ \     ',
        \ '    ___/ / /_/ /_/ / /_/ / / /_/ /     ',
        \ '   /____/\__/\__,_/\__,_/_/\____/      ',
        \ '                                       ',
        \ ]

    " Disable concealing of Markdown characters for displaying.
    let g:vim_markdown_conceal = 0

    " Use Galactic's airline theme.
    let g:airline_theme='galactic'
    let g:gitgutter_realtime = 0
    let g:airline#extensions#tmuxline#enabled = 0
    let g:airline#extensions#bookmark#enabled = 0
    let g:airline#extensions#fugitiveline#enabled = 0
    let g:airline#extensions#hunks#enabled = 0

    let g:bootstrap_pre_exec = 1
endf

func! bootstrap#after() abort
    " Keep lines above or below the cursor at all times.
    set scrolloff=7
    set colorcolumn=80,125

    " Wrap around lines in insert mode.
    set whichwrap+=<,>,h,l,[,]

    " Raise cmdheight so echodoc can display function parameters.
    set cmdheight=2

    " Default to case insensitive searches.
    set ignorecase
    set smartcase

    " Decrease idle time.
    set updatetime=350

    " Enable automated fixing.
    let g:ale_fixers = {
    \   '*': ['remove_trailing_lines', 'trim_whitespace'],
    \   'javascript': ['eslint'],
    \   'typescript': ['eslint'],
    \   'jsx': ['eslint'],
    \   'python': ['black'],
    \}

    " Automatically fix on save.
    let g:ale_fix_on_save = 1

    " Disable ALE for C/C++, Python, use LSP exclusively.
    let g:ale_linters = {
    \   'c': [],
    \   'cpp': [],
    \   'python': [],
    \   'java': [],
    \   'json': [],
    \   'javascript': [],
    \   'typescript': [],
    \   'jsx': [],
    \   'css': [],
    \   'html': [],
    \   'ruby': [],
    \   'rust': [],
    \   'go': [],
    \   'yaml': [],
    \}

    " let g:ale_sign_column_always = 1

    " let g:signify_sign_add               = '+'
    " let g:signify_sign_delete            = '_'
    " let g:signify_sign_delete_first_line = '‾'
    let g:signify_sign_change            = '~'
    " let g:signify_sign_changedelete = g:signify_sign_change

    call SpaceVim#mapping#space#def('nmap', ['c', '<CR>'], '<Plug>NERDCommenterToggle', 'toggle the comments on the selected line(s)', 0, 1)
    let g:_spacevim_mappings_space.l.c = {'name' : '+coc.nvim'}
    call SpaceVim#mapping#space#langSPC('nmap', ['l', 'c', 'd'], 'CocList diagnostics', 'show diagnostics', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l', 'c', 'c'], 'CocList extensions', 'list commands', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l', 'c', 'e'], 'CocList extensions', 'list extensions', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l', 'c', 'o'], 'CocList outline', 'list document symbols', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l', 'c', 's'], 'CocList -I symbols', 'list workspace symbols', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l', 'c', 'j'], 'CocNext', 'perform default action', 1)

    " nnoremap <silent> <leader>lh :call LanguageClient_textDocument_hover()<CR>
    " nnoremap <silent> <leader>ld :call LanguageClient_textDocument_definition()<CR>
    " nnoremap <silent> <leader>lr :call LanguageClient_textDocument_rename()<CR>

    inoremap <silent><expr> <c-space> coc#refresh()

    call coc#config('coc.preferences', {
        \ "autoTrigger": "always",
        \ "maxCompleteItemCount": 10,
        \ "codeLens.enable": 1,
        \ "diagnostic.virtualText": 1,
        \})

    " \ 'coc-prettier',
    " \ 'coc-imselect',
    " \ 'coc-wxml',
    " \ 'coc-stylelint',
    " \ 'coc-weather',
    " \ 'coc-emoji',
    " \ 'coc-ultisnips',
    " let s:coc_extensions = [
    "     \ 'coc-dictionary',
    "     \ 'coc-json',
    "     \ 'coc-tag',
    "     \ 'coc-tslint',
    "     \ 'coc-eslint',
    "     \ 'coc-css',
    "     \ 'coc-html',
    "     \ 'coc-pyls',
    "     \ 'coc-solargraph',
    "     \ 'coc-vetur',
    "     \ 'coc-json',
    "     \ 'coc-tsserver',
    "     \ 'coc-jest',
    "     \ 'coc-java',
    "     \ 'coc-rls',
    "     \ 'coc-highlight',
    "     \ 'coc-gocode',
    "     \ 'coc-omni',
    "     \ 'coc-word',
    "     \ 'coc-neosnippet',
    "     \ 'coc-yaml',
    "     \ 'coc-emmet',
    "     \ 'coc-snippets',
    "     \ 'coc-pairs',
    "     \ 'coc-lists',
    "     \ 'coc-yank',
    "     \ 'coc-vimtex',
    "     \ 'coc-tslint-plugin',
    "     \]

    " for extension in s:coc_extensions
    "     call coc#add_extension(extension)
    " endfor

    " Jump to next item in snippets with Tab.
    " let g:UltiSnipsJumpForwardTrigger="<tab>"
    " let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
    " imap <Tab> <Plug>(neosnippet_jump)

    let g:AutoHighlight_ClearOnCursorMoved = 1
    let g:AutoHighlight_ClearOnWindowExit = 1

    if g:bootstrap_pre_exec
        echom('Pre-execution bootstrap completed.')
    endif

    echom('Post-execution bootstrap complete.')
endf
