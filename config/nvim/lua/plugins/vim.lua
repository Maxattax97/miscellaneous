return {
	-- Better Lua LSP support for Neovim
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	-- Show current line number even when in relative mode.
	{
		"sitiom/nvim-numbertoggle",
	},
}
