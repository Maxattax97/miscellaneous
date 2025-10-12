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
	{ "sitiom/nvim-numbertoggle" },
	-- Open to the the last place you were editing in a file
	{ "farmergreg/vim-lastplace" },
	-- Visualize undo history and tree
	-- TODO: Consider replacing with mbbill/undotree
	{ "simnalamburt/vim-mundo" },
	-- Start screen
	{ "mhinz/vim-startify" },
}
