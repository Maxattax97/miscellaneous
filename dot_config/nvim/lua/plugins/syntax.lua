return {
	-- Consider re-adding as fallback:
	-- { "sheerun/vim-polyglot", enabled = false },
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-treesitter/nvim-treesitter-context", -- sticky function/class header
			{
				"HiPhish/rainbow-delimiters.nvim",
				submodules = false,
			},
		},
		config = function()
			local langspec = require("langspec")

			-- Install parsers declared in langspec
			require("nvim-treesitter").install(langspec.collect_parsers())

			-- Enable treesitter highlighting and indentation per buffer,
			-- skipping large files (>50 KB)
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local max_filesize = 50 * 1024 -- 50 KB
					local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
					if ok and stats and stats.size > max_filesize then
						return
					end
					pcall(vim.treesitter.start, args.buf)
				end,
			})
		end,
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
	{
		"numToStr/Comment.nvim",
		-- I couldn't rebind to <leader>c<CR>
		-- The standard bindings are normal: gcc, or visual: gc
	},
	{
		"stevearc/aerial.nvim",
		opts = {},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("aerial").setup({
				backends = { "lsp", "treesitter", "markdown" },
				show_guides = true,
				filter_kind = false, -- show all kinds
				keymaps = {
					["{"] = "aerial_prev",
					["}"] = "aerial_next",
				},
			})

			vim.keymap.set("n", "<F3>", "<cmd>AerialToggle!<CR>")
		end,
	},
	{
		-- automatically pulls JSON and YAML schemas from schemastore.org
		"b0o/schemastore.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		config = function()
			vim.lsp.config("jsonls", {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})
			vim.lsp.config("yamlls", {
				settings = {
					yaml = {
						-- This plugin recommends disabling built-in support:
						-- https://github.com/b0o/SchemaStore.nvim?tab=readme-ov-file#usage
						schemaStore = {
							enable = false,
							url = "",
						},
						schemas = require("schemastore").yaml.schemas(),
					},
				},
			})
		end,
	},
	-- { "pearofducks/ansible-vim" },
	-- { "gurpreetatwal/vim-avro" },
	-- { "urbit/hoon.vim" },
	-- { "kalafut/vim-taskjuggler" },
	-- { "momota/cisco.vim" },
	-- { "powerman/vim-plugin-AnsiEsc" },
}
