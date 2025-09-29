return {
	-- LSP configuration
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- Optional: buffer-local LSP keymaps
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local o = { buffer = ev.buf }
					vim.keymap.set("n", "K", vim.lsp.buf.hover, o)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, o)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, o)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, o)
				end,
			})

			-- Load your modular server configs + enable them
			require("lsp").setup()
		end,
	},

	-- Snippet engine
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},

	-- Completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip", -- the connector between nvim-cmp and LuaSnip
			"onsails/lspkind.nvim", -- shows icons in completion menu
			"brenoprata10/nvim-highlight-colors", -- integrates with color highlighting
			-- TODO: Other completions to investigate:
			-- https://github.com/hrsh7th/cmp-calc
			-- https://github.com/uga-rosa/cmp-dictionary
			-- https://github.com/f3fora/cmp-spell
			-- https://github.com/hrsh7th/cmp-omni
			-- https://github.com/hrsh7th/cmp-emoji
			-- https://github.com/hrsh7th/cmp-copilot
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enter accepts first suggestion
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
					{ name = "path" },
				}),

				-- Settings for lspkind
				formatting = {
					--[[format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = {
							menu = function()
								return math.floor(0.8 * vim.o.columns)
							end,
							abbr = 32,
						},
						ellipsis_char = "…",
						show_labelDetails = true,
					}), ]]
					--
					format = function(entry, item)
						-- A little more complicated than usual due to the highlight colors...
						-- https://github.com/brenoprata10/nvim-highlight-colors?tab=readme-ov-file#lspkind-integration
						local color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })
						item = require("lspkind").cmp_format({
							mode = "symbol_text",
							maxwidth = {
								menu = function()
									return math.floor(0.8 * vim.o.columns)
								end,
								abbr = 32,
							},
							ellipsis_char = "…",
							show_labelDetails = true,
						})(entry, item)

						if color_item.abbr_hl_group then
							item.kind_hl_group = color_item.abbr_hl_group
							item.kind = color_item.abbr
						end

						return item
					end,
				},
			})

			-- Use buffer source for `/`
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':'
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "InsertEnter",
		opts = {
			bind = true,
			hint_enable = false,
			handler_opts = {
				border = "none",
			},
		},
	},
	{ "github/copilot.vim" },
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
}
