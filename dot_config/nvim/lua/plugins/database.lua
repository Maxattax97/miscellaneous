return {
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "tpope/vim-dotenv", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
		ft = { "sql", "mysql", "plsql" },
		keys = {
			{ "<leader>du", "<cmd>DBUIToggle<cr>", desc = "Toggle DBUI" },
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
		end,
		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "sql", "mysql", "plsql" },
				callback = function()
					local ok, cmp = pcall(require, "cmp")
					if not ok then
						return
					end
					cmp.setup.buffer({
						sources = cmp.config.sources({
							{ name = "vim-dadbod-completion" },
							{ name = "nvim_lsp" },
							{ name = "minuet" },
							{ name = "luasnip" },
						}, {
							{ name = "buffer" },
							{ name = "path" },
						}),
					})
				end,
			})
		end,
	},
}
