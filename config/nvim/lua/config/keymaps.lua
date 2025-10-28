vim.g.mapleader = " "

-- Window switching
vim.keymap.set("n", "<Tab>", "<C-w><C-w>")
vim.keymap.set("n", "<S-Tab>", "<C-w><S-w>")

-- Disable Ctrl-Z
vim.keymap.set("n", "<C-z>", "<nop>")

-- Function keys / tools
vim.keymap.set("n", "<F5>", ":make<CR>")
vim.keymap.set("n", "<F6>", ":MundoToggle<CR>")

-- Paste from the 0 register
vim.keymap.set({ "x", "n", "v" }, "<leader>P", [["0p]])

-- vim-test
vim.keymap.set("n", "<leader>t", ":TestNearest<CR>", { silent = true })
vim.keymap.set("n", "<leader>T", ":TestFile<CR>", { silent = true })

-- Fugitive conflict resolution
vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit!<CR>", { silent = true })
vim.keymap.set("n", "gdh", ":diffget //2<CR>", { silent = true })
vim.keymap.set("n", "gdl", ":diffget //3<CR>", { silent = true })

-- FixTabs user command
vim.api.nvim_create_user_command("FixTabs", function()
	vim.cmd("set tabstop=4 shiftwidth=4 expandtab")
	vim.cmd("normal! gg=G")
	vim.cmd("retab")
end, {})
