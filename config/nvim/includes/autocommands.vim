" Additional Filetypes
augroup neovim_studio_filetypes
    autocmd!
    autocmd BufRead,BufNewFile *.aatstest set filetype=json
    autocmd BufRead,BufNewFile *.colortemplate set filetype=colortemplate
augroup end


augroup neovim_studio_coc
    autocmd!
    " Hover on cursor hold.
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Update signature to help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

augroup neovim_studio_denite
    " Define mappings while in 'filter' mode
    "   <C-o>         - Switch to normal mode inside of search results
    "   <Esc>         - Exit denite window in any mode
    "   <CR>          - Open currently selected file in any mode
    autocmd FileType denite-filter call s:denite_filter_my_settings()
    function! s:denite_filter_my_settings() abort
    imap <silent><buffer> <C-o>
    \ <Plug>(denite_filter_quit)
    inoremap <silent><buffer><expr> <Esc>
    \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> <Esc>
    \ denite#do_map('quit')
    inoremap <silent><buffer><expr> <CR>
    \ denite#do_map('do_action')
    endfunction

    " Define mappings while in denite window
    "   <CR>        - Opens currently selected file
    "   q or <Esc>  - Quit Denite window
    "   d           - Delete currenly selected file
    "   p           - Preview currently selected file
    "   <C-o> or i  - Switch to insert mode inside of filter prompt
    autocmd FileType denite call s:denite_my_settings()
    function! s:denite_my_settings() abort
    nnoremap <silent><buffer><expr> <CR>
    \ denite#do_map('do_action')
    nnoremap <silent><buffer><expr> q
    \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> <Esc>
    \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> d
    \ denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> p
    \ denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> i
    \ denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> v
    \ denite#do_map('do_action', 'vsplit')
    nnoremap <silent><buffer><expr> s
    \ denite#do_map('do_action', 'split')
    nnoremap <silent><buffer><expr> <C-o>
    \ denite#do_map('open_filter_buffer')
    endfunction
augroup end
