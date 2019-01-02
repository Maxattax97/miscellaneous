" TODO LIST
" Spell checking: spell spelllang=en_us
" Cursor line wrapping
" Merge configuration with Neovim Studio
" Plugins: vim-sleuth, vim-lastplace 
func! bootstrap#before() abort
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

    let g:ale_fixers = {
    \   '*': ['remove_trailing_lines', 'trim_whitespace'],
    \   'javascript': ['eslint'],
    \   'python': ['black'],
    \}

    " Disable ALE for C/C++, use LSP exclusively.
    let g:ale_linters = {
    \   'c': [],
    \   'cpp': [],
    \}
    
    " let g:ale_sign_column_always = 1
    
    " let g:signify_sign_add               = '+'
    " let g:signify_sign_delete            = '_'
    " let g:signify_sign_delete_first_line = '‾'
    let g:signify_sign_change            = '~'
    " let g:signify_sign_changedelete = g:signify_sign_change

    call SpaceVim#mapping#space#def('nmap', ['c', '<CR>'], '<Plug>NERDCommenterToggle', 'toggle the comments on the selected line(s)', 0, 1)
    
    nnoremap <silent> <leader>lh :call LanguageClient_textDocument_hover()<CR>
    nnoremap <silent> <leader>ld :call LanguageClient_textDocument_definition()<CR>
    nnoremap <silent> <leader>lr :call LanguageClient_textDocument_rename()<CR>
endf
