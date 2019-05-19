" Additional Filetypes
augroup neovim_studio_filetypes
    autocmd!
    autocmd BufRead,BufNewFile *.aatstest set filetype=json
    autocmd BufRead,BufNewFile *.colortemplate set filetype=colortemplate
augroup END


augroup neovim_studio_coc
    autocmd!
    " Hover on cursor hold.
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Update signature to help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
