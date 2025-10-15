return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					-- theme = "base16",
					theme = "tokyonight",
				},
				-- Available components: https://github.com/nvim-lualine/lualine.nvim?tab=readme-ov-file#available-components
				sections = {
					-- 	lualine_a = { "mode" },
					lualine_b = { "branch", "diff" },
					lualine_c = { "filename", "diagnostics" },
					lualine_x = { "lsp_status" },
					lualine_y = { "encoding", "fileformat", "filetype" },
					lualine_z = { "progress", "location" },
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
