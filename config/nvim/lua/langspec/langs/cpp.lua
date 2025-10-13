return {
	packages = {
		"clangd",
		"clang-format",
		"codelldb",
		"cpplint", -- cppcheck is better I think, but Mason doesn't have a package for it yet.
	},
	parsers = {
		"c",
		"cpp",
	},
	linters = { lua = { "cpplint" } },
	language_servers = { "clangd" },
	config = function()
		vim.lsp.config.clangd = {
			-- cmd = { "clangd", "--background-index" },
		}
	end,
}
