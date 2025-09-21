return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("telescope").setup({})

			require("telescope").load_extension("fzf")

			vim.keymap.set("n", "<leader><CR>", "<cmd>Telescope find_files<cr>", { desc = "Search files" })
			vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Search Vim help" })
			vim.keymap.set("n", "<leader>fm", "<cmd>Telescope man_pages<cr>", { desc = "Search man pages" })
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
}
