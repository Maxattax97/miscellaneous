return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "master", -- the main branch will become the new default, but its unstable right now
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-treesitter/nvim-treesitter-context", -- sticky function/class header
			{
				"HiPhish/rainbow-delimiters.nvim",
				submodules = false,
			},
		},
		opt = {
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
				-- Setting this to true will run `:h syntax` and tree-sitter at the same time. Set this to `true` if you depend on 'syntax' being enabled (like for indentation). Using this option may slow down your editor, and you may see some duplicate highlights. Instead of true it can also be a list of languages additional_vim_regex_highlighting = false, indent = {
				enable = true,

				-- disable slow treesitter highlight for large files
				disable = function(lang, buf)
					local max_filesize = 50 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
			},
		},
	},
	-- sticky function/class header
	{
		"nvim-treesitter/nvim-treesitter-context",
		opt = {
			enable = true,
			multiwindow = true,
			max_lines = 3,
			min_window_height = 0,
			line_numbers = true,
			multiline_threshold = 20, -- Maximum number of lines to show for a single context
			trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
			mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
			-- Separator between context and content. Should be a single character string, like '-'.
			-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
			separator = nil,
			zindex = 20, -- The Z-index of the context window
			on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
		},
	},
	{
		"brenoprata10/nvim-highlight-colors",
		config = function()
			local module = require("nvim-highlight-colors")
			module.setup({
				render = "virtual",
			})

			module.turnOn()
		end,
	},
}
