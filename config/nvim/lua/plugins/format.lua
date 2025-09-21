return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		opts = {
			-- run formatters in sequence per filetype (first present wins unless you set "stop_after_first")
			-- to get a list of these, see `:help conform-formatters`
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format", "black" }, -- ruff fmt then black if you like; or just one of them
				rust = { "rustfmt" },
				go = { "gofumpt", "goimports", "golines" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
				json = { "jq" }, -- or "prettier"/"prettierd"
				jsonc = { "prettierd", "prettier" },
				yaml = { "prettierd", "prettier" }, -- or "yamlfmt"
				toml = { "taplo" },
				markdown = { "prettierd", "prettier" }, -- or "markdownlint" fix mode via nvim-lint
				typescript = { "prettierd", "prettier" },
				javascript = { "prettierd", "prettier" },
				tsx = { "prettierd", "prettier" },
				jsx = { "prettierd", "prettier" },
				css = { "prettierd", "prettier" },
				html = { "prettierd", "prettier" },
				vue = { "prettierd", "prettier" },
				sql = { "sqlfluff" }, -- or "pg_format"
			},

			-- format on save (fast; uses LSP if no external is set)
			format_on_save = function(bufnr)
				-- large files: skip
				local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
				if ok and stats and stats.size > 500 * 1024 then
					return nil
				end
				return { lsp_fallback = true, timeout_ms = 2000 }
			end,
			notify_on_error = true,
		},
	},
}
