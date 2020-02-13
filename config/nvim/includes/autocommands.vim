" vim: foldmethod=marker
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

augroup neovim_studio_english_spelling
    autocmd!
    autocmd FileType gitcommit,latex,tex,md,markdown setlocal spell
    autocmd BufRead,BufNewFile *.md setlocal spell
augroup end

augroup neovim_studio_denite
    " Define mappings while in 'filter' mode
    "   <C-o>         - Switch to normal mode inside of search results
    "   <Esc>         - Exit denite window in any mode
    "   <CR>          - Open currently selected file in any mode
    autocmd FileType denite-filter call s:denite_filter_my_settings()
    function! s:denite_filter_my_settings() abort
    imap <silent><buffer> <Tab>
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
    nnoremap <silent><buffer><expr> <Tab>
    \ denite#do_map('open_filter_buffer')
    endfunction
augroup end

augroup neovim_studio_defx
	autocmd!

	" Set common settings.
	autocmd FileType defx setlocal statusline=defx

	" Set mappings.
	autocmd FileType defx call s:defxmappings()

	function! s:defxmappings() abort
		" Navigation
		nnoremap <buffer><silent><expr> <CR>
			\ defx#is_directory()
				\ ? defx#do_action('open_or_close_tree')
				\ : defx#do_action('drop')
		nnoremap <buffer><silent><expr> l
			\ defx#is_directory()
				\ ? defx#do_action('open_or_close_tree')
				\ : defx#do_action('drop')
		nnoremap <buffer><silent><expr> <2-LeftMouse>
			\ defx#is_directory()
				\ ? defx#do_action('open_or_close_tree')
				\ : defx#do_action('drop')
		nnoremap <buffer><silent><expr> v
			\ defx#is_directory()
				\ ? defx#do_action('open_or_close_tree')
				\ : defx#do_action('drop', 'vsplit')
		nnoremap <buffer><silent><expr> s
			\ defx#is_directory()
				\ ? defx#do_action('open_or_close_tree')
				\ : defx#do_action('drop', 'split')
		nnoremap <buffer><silent><expr> h defx#do_action('close_tree')
		nnoremap <buffer><silent><expr> L defx#do_action('cd', defx#get_candidate().action__path)
		nnoremap <buffer><silent><expr> H defx#do_action('cd', ['..'])
		nnoremap <buffer><silent><expr> gh defx#do_action('cd', getcwd())
		nnoremap <buffer><silent><expr> ~ defx#do_action('open_tree_recursive')

		" Selection
		nnoremap <buffer><silent><expr> a defx#do_action('toggle_select') . 'j'
		xnoremap <buffer><silent><expr> a defx#do_action('toggle_select_visual')
		nnoremap <buffer><silent><expr> uv defx#do_action('clear_select_all')

		" Operations
		nnoremap <buffer><silent><expr> yy defx#do_action('copy')
		xnoremap <buffer><silent><expr> yy defx#do_action('copy')
		nnoremap <buffer><silent><expr> dd defx#do_action('move')
		nnoremap <buffer><silent><expr> dD defx#do_action('remove_trash')
		nnoremap <buffer><silent><expr> p defx#do_action('paste')
		nnoremap <buffer><silent><expr> r defx#do_action('rename')
		nnoremap <buffer><silent><expr><nowait> c defx#do_action('new_multiple_files')

		" Other
		nnoremap <buffer><silent><expr> <C-r> defx#do_action('redraw')
		nnoremap <buffer><silent><expr> <C-g> defx#do_action('print')
		nnoremap <buffer><silent><expr> zh defx#do_action('toggle_ignored_files')
		nnoremap <buffer><silent><expr> ypf defx#do_action('yank_path')
		nnoremap <buffer><silent><expr> q defx#do_action('quit')

		" Custom
		nnoremap <buffer><silent><expr> gl defx#do_action('call', 'DefxTmuxExplorer')
		function! g:DefxTmuxExplorer(context) abort
			if empty('$TMUX')
				return v:false
			endif

			let l:parent = fnamemodify(a:context['targets'][0], ':h')
			silent execute printf('!tmux split-window -p 40 -c "%s" ranger', l:parent)
		endfunction
	endfunction
augroup end

"augroup neovim_studio_auto_open
    "autocmd!
    "autocmd VimEnter * Vista
    "autocmd VimEnter * Defx
"augroup end
