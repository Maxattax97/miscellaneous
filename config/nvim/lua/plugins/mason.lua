return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			-- everything you want installed
			ensure_installed = {
				-- LSP servers
				"lua-language-server",
				"basedpyright",
				"clangd",
				"rust-analyzer",
				--"gopls",
				--"bash-language-server",
				--"yaml-language-server",
				--"json-lsp",
				--"html-lsp",
				--"css-lsp",
				--"marksman", -- markdown
				--"taplo", -- TOML
				--"texlab",
				--"dockerfile-language-server",
				--"eslint-lsp",
				--"vim-language-server",
				--"vtsls", -- modern TS/JS server

				-- Linters
				"ruff",
				"shellcheck",
				"hadolint",
				"yamllint",
				"markdownlint",
				"jsonlint",
				"golangci-lint",

				-- Formatters
				"stylua",
				--"prettierd",
				--"prettier",
				"black",
				--"jq",
				--"shfmt",
				--"sqlfluff",
				--"gofumpt",
				--"goimports",
				--"golines",

				-- DAPs (if you want debugging)
				--"codelldb",
				--"debugpy",
			},

			run_on_start = true,
			aut_update = true,
			start_delay = 3000, -- ms, wait for Mason to boot cleanly
			debounce_hours = 168, -- update only once a week
		},
	},
}
