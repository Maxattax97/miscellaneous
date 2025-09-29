return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "base16",
				},
			})
		end,
	},
	{
		"akinsho/bufferline.nvim",
		version = "v4.*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					buffer_close_icon = "",
					diagnostics = "nvim_lsp",
				},
			})
		end,
	},
}
