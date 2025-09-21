local map, cmd, fn, api = vim.keymap.set, vim.cmd, vim.fn, vim.api

vim.g.mapleader = " "

-- Window switching
map("n", "<Tab>", "<C-w><C-w>")
map("n", "<S-Tab>", "<C-w><S-w>")

-- Disable Ctrl-Z
map("n", "<C-z>", "<nop>")

-- Function keys / tools
-- map("n", "<F3>", ":TagbarToggle<CR>")
map("n", "<F3>", ":Vista!!<CR>")
map("n", "<F5>", ":make<CR>")
map("n", "<F4>", "<Plug>(ale_fix)", { silent = true })
map("n", "<F6>", ":MundoToggle<CR>")
map("n", "<F12>", ":ALEFix<CR>")

-- CoC completion helpers (expr mappings)
--local function coc_visible() return fn["coc#pum#visible"]() == 1 end
--local function check_backspace()
  --local col = fn.col(".") - 1
  --return (col == 0) or fn.getline("."):sub(col, col):match("%s") ~= nil
--end

--map("i", "<Tab>", function()
  --if coc_visible() then
    --return fn
  --elseif check_backspace() then
    --return "<Tab>"
  --else
    --return fn["coc#refresh"]()
  --end
--end, { expr = true, silent = true })

--map("i", "<S-Tab>", function()
  --return coc_visible() and fn or "<C-h>"
--end, { expr = true, silent = true })

--map("i", "<CR>", function()
  --if coc_visible() then
    --return fn["coc#pum#confirm"]()
  --end
  --return "<C-g>u<CR><c-r>=coc#on_enter()<CR>"
--end, { expr = true, silent = true })

--map("i", "<C-Space>", [[coc#refresh()]], { expr = true, silent = true })

-- CoC LSP-style maps
--map("n", "<leader>ld", "<Plug>(coc-definition)", { silent = true })
--map("n", "<leader>ly", "<Plug>(coc-type-definition)", { silent = true })
--map("n", "<leader>li", "<Plug>(coc-implementation)", { silent = true })
--map("n", "<leader>lr", "<Plug>(coc-references)", { silent = true })
--map("n", "<leader>lR", "<Plug>(coc-rename)", { silent = true })
--map("n", "<leader>lf", "<Plug>(coc-format)", { silent = true })
--map({ "n", "x", "v" }, "<leader>lF", "<Plug>(coc-fix-current)", { silent = true })
--map({ "n", "x", "v" }, "<leader>la", "<Plug>(coc-codeaction-selected)", { silent = true })
--map("n", "<leader>ll", "<Plug>(coc-codelens-action)", { silent = true })

-- Hover/doc
--local function show_doc()
  --if vim.bo.filetype == "vim" or vim.bo.filetype == "help" then
    --cmd("h " .. fn.expand("<cword>"))
  --else
    --fn.CocAction("doHover")
  --end
--end
--map("n", "<leader>lK", show_doc, { silent = true })

-- NERDCommenter toggles
map("n", "<leader>c<CR>", "<Plug>NERDCommenterToggle", { silent = true })
map("v", "<leader>c<CR>", "<Plug>NERDCommenterToggle", { silent = true })

-- Diagnostics jumping (ALE)
map("n", "<leader>e", "<Plug>(ale_next_wrap)", { silent = true })
map("n", "<leader>E", "<Plug>(ale_previous_wrap)", { silent = true })

-- Paste from the 0 register
map({ "x", "n", "v" }, "<leader>P", [["0p]])

-- vim-test
map("n", "<leader>t", ":TestNearest<CR>", { silent = true })
map("n", "<leader>T", ":TestFile<CR>", { silent = true })

-- Fugitive conflict resolution
map("n", "<leader>gd", ":Gvdiffsplit!<CR>", { silent = true })
map("n", "gdh", ":diffget //2<CR>", { silent = true })
map("n", "gdl", ":diffget //3<CR>", { silent = true })

-- FixTabs user command
vim.api.nvim_create_user_command("FixTabs", function()
  cmd("set tabstop=4 shiftwidth=4 expandtab")
  cmd("normal! gg=G")
  cmd("retab")
end, {})
