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
	{
		"mhinz/vim-startify",
		config = function()
			vim.g.startify_custom_header = {
				"   ___       _____  ______ ______ ______ _____ ______ ______ _____  ",
				"  / _ \\     |  __ \\|  ____|  ____|  ____/ ____|____  |  ____|  __ \\ ",
				" | | | |_  _| |  | | |__  | |__  | |__ | |        / /| |__  | |  | |",
				" | | | \\ \\/ / |  | |  __| |  __| |  __|| |       / / |  __| | |  | |",
				" | |_| |>  <| |__| | |____| |    | |___| |____  / /  | |____| |__| |",
				"  \\___//_/\\_\\_____/|______|_|    |______\\_____|/_/   |______|_____/ ",
			}
		end,
	},
	{
		-- This repo says it's not needed, but NeoTest says it's required to
		-- separate the hold times
		"antoinemadec/FixCursorHold.nvim",
	},
}
