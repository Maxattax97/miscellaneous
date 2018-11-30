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

    let g:ale_fixers = {
    \   '*': ['remove_trailing_lines', 'trim_whitespace'],
    \   'javascript': ['eslint'],
    \   'python': ['black'],
    \}
endf
