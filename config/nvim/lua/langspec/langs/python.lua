return {
	language_servers = { "basedpyright", "ruff", "black", "debugpy" },
	parsers = { "python" },
	linters = { python = { "ruff" } },
	formatters = {
		python = { "ruff_format", "black" },
	},
	config = function()
		vim.lsp.config.basedpyright = {
			-- settings = { python = { analysis = { typeCheckingMode = "basic" } } },
		}
	end,
}
