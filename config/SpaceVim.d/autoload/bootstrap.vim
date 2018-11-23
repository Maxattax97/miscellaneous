" TODO LIST
" Spell checking: spell spelllang=en_us
" Cursor line wrapping
" Merge configuration with Neovim Studio

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
    " echom "Loading bootstrap configuration ..."
endf

func! bootstrap#after() abort
    " echom "Bootstrap configuration loaded."
endf

" echom "Bootstrapping defined in bootstrap configuration."


