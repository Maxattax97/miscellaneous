return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "master", -- the main branch will become the new default, but its unstable right now
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({
				ensure_installed = {
					"c",
					"javascript",
					"lua",
					"lua",
					"markdown",
					"markdown_inline",
					"query",
					"rust",
					"vim",
					"vimdoc",
				},
				auto_install = true, -- fetch the paser if we don't have it
				highlight = {
					enable = true,

					-- disable slow treesitter highlight for large files
					disable = function(lang, buf)
						local max_filesize = 50 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,

					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},
}
