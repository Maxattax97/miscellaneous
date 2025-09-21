local api, fn = vim.api, vim.fn

-- Additional Filetypes
local ft = api.nvim_create_augroup("neovim_studio_filetypes", { clear = true })
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = ft,
	pattern = "*.aatstest",
	command = "set filetype=json",
})
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = ft,
	pattern = "*.colortemplate",
	command = "set filetype=colortemplate",
})
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = ft,
	pattern = "*/playbooks/*.yml",
	command = "set filetype=yaml.ansible",
})

-- English spelling in prose
local sp = api.nvim_create_augroup("neovim_studio_english_spelling", { clear = true })
api.nvim_create_autocmd(
	"FileType",
	{ group = sp, pattern = { "gitcommit", "latex", "tex", "md", "markdown" }, command = "setlocal spell" }
)
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, { group = sp, pattern = "*.md", command = "setlocal spell" })

-- Copilot: disable on very large files
local cop = api.nvim_create_augroup("neovim_studio_copilot", { clear = true })
api.nvim_create_autocmd("BufReadPre", {
	group = cop,
	callback = function(args)
		local f = fn.getfsize(fn.expand(args.file))
		if f > 500000 or f == -2 then
			vim.b.copilot_enabled = false
		end
	end,
})

-- Folds on larger fi
