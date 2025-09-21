local api, fn = vim.api, vim.fn

-- Additional Filetypes
local ft = api.nvim_create_augroup("neovim_studio_filetypes", { clear = true })
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = ft, pattern = "*.aatstest", command = "set filetype=json",
})
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = ft, pattern = "*.colortemplate", command = "set filetype=colortemplate",
})
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = ft, pattern = "*/playbooks/*.yml", command = "set filetype=yaml.ansible",
})

-- CoC hover/signature (only if CocActionAsync exists)
--if fn.exists("*CocActionAsync") == 1 then
  --local cocg = api.nvim_create_augroup("neovim_studio_coc", { clear = true })
  --api.nvim_create_autocmd("CursorHold", { group = cocg, command = "silent call CocActionAsync('highlight')" })
  --api.nvim_create_autocmd("User", { group = cocg, pattern = "CocJumpPlaceholder", command = "call CocActionAsync('showSignatureHelp')" })
--end

-- English spelling in prose
local sp = api.nvim_create_augroup("neovim_studio_english_spelling", { clear = true })
api.nvim_create_autocmd("FileType", { group = sp, pattern = { "gitcommit","latex","tex","md","markdown" }, command = "setlocal spell" })
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, { group = sp, pattern = "*.md", command = "setlocal spell" })

-- Denite buffer-local mappings (verbatim)
vim.cmd([[
augroup neovim_studio_denite
  autocmd!
  autocmd FileType denite-filter call <SID>denite_filter_my_settings()
  function! s:denite_filter_my_settings() abort
    imap <silent><buffer> <Tab> <Plug>(denite_filter_quit)
    inoremap <silent><buffer><expr> <Esc> denite#do_map('quit')
    nnoremap <silent><buffer><expr> <Esc> denite#do_map('quit')
    inoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
  endfunction

  autocmd FileType denite call <SID>denite_my_settings()
  function! s:denite_my_settings() abort
    nnoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
    nnoremap <silent><buffer><expr> q denite#do_map('quit')
    nnoremap <silent><buffer><expr> <Esc> denite#do_map('quit')
    nnoremap <silent><buffer><expr> d denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> p denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> i denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> v denite#do_map('do_action', 'vsplit')
    nnoremap <silent><buffer><expr> s denite#do_map('do_action', 'split')
    nnoremap <silent><buffer><expr> <Tab> denite#do_map('open_filter_buffer')
  endfunction
augroup END
]])

-- Defx mappings (verbatim; easier to retain)
vim.cmd([[
augroup neovim_studio_defx
  autocmd!
  autocmd FileType defx setlocal statusline=defx
  autocmd FileType defx call <SID>defxmappings()
  function! s:defxmappings() abort
    nnoremap <buffer><silent><expr> <CR> defx#is_directory() ? defx#do_action('open_or_close_tree') : defx#do_action('drop')
    nnoremap <buffer><silent><expr> l    defx#is_directory() ? defx#do_action('open_or_close_tree') : defx#do_action('drop')
    nnoremap <buffer><silent><expr> <2-LeftMouse> defx#is_directory() ? defx#do_action('open_or_close_tree') : defx#do_action('drop')
    nnoremap <buffer><silent><expr> v    defx#is_directory() ? defx#do_action('open_or_close_tree') : defx#do_action('drop', 'vsplit')
    nnoremap <buffer><silent><expr> s    defx#is_directory() ? defx#do_action('open_or_close_tree') : defx#do_action('drop', 'split')
    nnoremap <buffer><silent><expr> h defx#do_action('close_tree')
    nnoremap <buffer><silent><expr> L defx#do_action('cd', defx#get_candidate().action__path)
    nnoremap <buffer><silent><expr> H defx#do_action('cd', ['..'])
    nnoremap <buffer><silent><expr> gh defx#do_action('cd', getcwd())
    nnoremap <buffer><silent><expr> ~ defx#do_action('open_tree_recursive')
    nnoremap <buffer><silent><expr> a defx#do_action('toggle_select') . 'j'
    xnoremap <buffer><silent><expr> a defx#do_action('toggle_select_visual')
    nnoremap <buffer><silent><expr> uv defx#do_action('clear_select_all')
    nnoremap <buffer><silent><expr> yy defx#do_action('copy')
    xnoremap <buffer><silent><expr> yy defx#do_action('copy')
    nnoremap <buffer><silent><expr> dd defx#do_action('move')
    nnoremap <buffer><silent><expr> dD defx#do_action('remove_trash')
    nnoremap <buffer><silent><expr> p defx#do_action('paste')
    nnoremap <buffer><silent><expr> r defx#do_action('rename')
    nnoremap <buffer><silent><expr><nowait> c defx#do_action('new_multiple_files')
    nnoremap <buffer><silent><expr> <C-r> defx#do_action('redraw')
    nnoremap <buffer><silent><expr> <C-g> defx#do_action('print')
    nnoremap <buffer><silent><expr> zh defx#do_action('toggle_ignored_files')
    nnoremap <buffer><silent><expr> ypf defx#do_action('yank_path')
    nnoremap <buffer><silent><expr> q defx#do_action('quit')
    nnoremap <buffer><silent><expr> gl defx#do_action('call', 'DefxTmuxExplorer')
    function! g:DefxTmuxExplorer(context) abort
      if empty($TMUX) | return v:false | endif
      let l:parent = fnamemodify(a:context['targets'][0], ':h')
      silent execute printf('!tmux split-window -p 40 -c "%s" ranger', l:parent)
    endfunction
  endfunction
augroup END
]])

-- Copilot: disable on very large files
local cop = api.nvim_create_augroup("neovim_studio_copilot", { clear = true })
api.nvim_create_autocmd("BufReadPre", {
  group = cop,
  callback = function(args)
    local f = fn.getfsize(fn.expand(args.file))
    if f > 500000 or f == -2 then vim.b.copilot_enabled = false end
  end,
})

-- Folds on larger fi
