" Map leader
let mapleader = " "

" Map window switching to Tab in normal mode.
nnoremap <Tab> <C-w><C-w>
nnoremap <S-Tab> <C-w><S-w>

" Bind NerdTree to F2
noremap <F2> :NERDTreeToggle<CR>

" Bind Tagbar to F3
noremap <F3> :TagbarToggle<CR>

" Bind make to F5
noremap <F5> :make<CR>

" Map block comment to Leader-c
" nnoremap <Leader>c<CR> <Plug>NERDCommenterToggle
" vnoremap <Leader>c<CR> <Plug>NERDCommenterToggle

" Display ALE errors in the statusline.
function! LinterStatus() abort
    "let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction

set statusline=%{LinterStatus()}

" Map Tab and Enter to autocompletion.
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : <SID>check_backspace() ? "\<Tab>" : coc#refresh()
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <Up> pumvisible() ? "\<C-p>" : <SID>check_backspace() ? "\<Up>" : coc#refresh()
inoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
" Break undo chain is <C-g>u
inoremap <expr> <CR>  pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <Esc>  pumvisible() ? "\<C-e>" : "\<Esc>"

function! s:check_backspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" <C-Space> triggers completion menu.
inoremap <silent><expr> <C-Space> coc#refresh()

" Map Denite fuzzy search to act like CtrlP.
noremap <C-p> :Denite buffer file_rec tag<CR>

noremap <silent> <leader>e <Plug>(ale_next_wrap)
noremap <silent> <leader><S-e> <Plug>(ale_previous_wrap)

" Strip trailing whitespace for most of filetypes.
function! StripTrailingWhitespace()
    " Filetype blacklist
    if &filetype =~ 'markdown\|whitespace'
        return
    endif

    " Save line, column location
    let l:line_number = line('.')
    let l:column_number = col('.')

    %s/\s\+$//e

    call cursor(l:line_number, l:column_number)
endfun

" Automatically strip trailing whitespace before saving.
augroup neovim_studio_strip_whitespace
    autocmd!
    autocmd BufWritePre * call StripTrailingWhitespace()
augroup END

" Enable NERDTree and Tagbar, and recenter the cursor on startup.
"augroup neovim_studio_startup
"    autocmd!
"    autocmd vimenter * NERDTree
"    autocmd vimenter * wincmd p
"    autocmd vimenter * Tagbar
"augroup END
