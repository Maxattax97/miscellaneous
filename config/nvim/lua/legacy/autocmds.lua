-- Additional Filetypes
local ft = vim.api.nvim_create_augroup("com_maxocull_nvim_filetypes", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = ft,
	pattern = "*/playbooks/*.yml",
	command = "set filetype=yaml.ansible",
})

-- English spelling in prose
local sp = vim.api.nvim_create_augroup("com_maxocull_nvim_english_spelling", { clear = true })
vim.api.nvim_create_autocmd(
	"FileType",
	{ group = sp, pattern = { "gitcommit", "latex", "tex", "md", "markdown" }, command = "setlocal spell" }
)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, { group = sp, pattern = "*.md", command = "setlocal spell" })

-- Copilot: disable on very large files
local cop = vim.api.nvim_create_augroup("neovim_studio_copilot", { clear = true })
vim.api.nvim_create_autocmd("BufReadPre", {
	group = cop,
	callback = function(args)
		local file_size = vim.fn.getfsize(vim.fn.expand(args.file))
		if file_size > 50 * 1024 or file_size == -2 then
			vim.b.copilot_enabled = false
		end
	end,
})
