" Map leader
let mapleader = " "
"nnoremap <Space> <nop>

" Map window switching to Tab in normal mode.
nnoremap <Tab> <C-w><C-w>
nnoremap <S-Tab> <C-w><S-w>

" Map Ctrl-Z to a no-op so I don't screw up an background the process.
nnoremap <c-z> <nop>

" Bind NerdTree to F2
noremap <F2> :NERDTreeToggle<CR>

" Bind Tagbar to F3
noremap <F3> :TagbarToggle<CR>

" Bind make to F5
noremap <F5> :make<CR>

" Bind ALE format, fix, etc. to F4.
nnoremap <F4> <Plug>(ale_fix)

" Map block comment to Leader-c
" nnoremap <Leader>c<CR> <Plug>NERDCommenterToggle
" vnoremap <Leader>c<CR> <Plug>NERDCommenterToggle

" Map Tab and Enter to autocompletion.
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : <SID>check_backspace() ? "\<Tab>" : coc#refresh()
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <Up> pumvisible() ? "\<C-p>" : <SID>check_backspace() ? "\<Up>" : coc#refresh()
inoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
" Break undo chain is <C-g>u
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"

function! s:check_backspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" <C-Space> triggers completion menu.
inoremap <silent><expr> <C-Space> coc#refresh()

" Map various gotos's for CoC.
nmap <silent> <leader>ld <Plug>(coc-definition)
nmap <silent> <leader>ly <Plug>(coc-type-definition)
nmap <silent> <leader>li <Plug>(coc-implementation)
nmap <silent> <leader>lr <Plug>(coc-references)

nmap <leader>lR <Plug>(coc-rename)

nmap <leader>lf <Plug>(coc-format)

nmap <leader>lF <Plug>(coc-fix-selected)
xmap <leader>lF <Plug>(coc-fix-selected)
vmap <leader>lF <Plug>(coc-fix-selected)

nmap <leader>la <Plug>(coc-codeaction-selected)
xmap <leader>la <Plug>(coc-codeaction-selected)
vmap <leader>la <Plug>(coc-codeaction-selected)

nmap <leader>ll <Plug>(coc-codelens-action)

nnoremap <silent> <leader>lK :call <SID>show_documentation()<CR>

nnoremap <silent> <leader>lc<CR> :<C-u>CocList commands<CR>
nnoremap <silent> <leader>l<CR> :<C-u>CocList<CR>

function! s:show_documentation()
    if (index(['vim', 'help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

" Map Denite fuzzy search to act like ~CtrlP~ a friggin' boss.
noremap <leader><CR> :Denite buffer file/rec tag<CR>

nmap <leader>c<CR> <Plug>NERDCommenterToggle
vmap <leader>c<CR> <Plug>NERDCommenterToggle

" Map ALE error jumping.
nmap <silent> <leader>e <Plug>(ale_next_wrap)
nmap <silent> <leader><S-e> <Plug>(ale_previous_wrap)
