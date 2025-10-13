return {
	packages = { "rust-analyzer" },
	parsers = { "rust" },
	linters = { rust = { "clippy" } },
	formatters = { rust = { "rustfmt" } },
	language_servers = { "rust-analyzer" },
	config = function()
		vim.lsp.config("rust_analyzer", {
			settings = {
				["rust-analyzer"] = {
					check = {
						command = "clippy",
					},
				},
			},
		})
	end,
}
