return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		config = function()
			local langspec = require("langspec")
			require("conform").setup({
				-- run formatters in sequence per filetype (first present wins unless you set "stop_after_first")
				-- to get a list of these, see `:help conform-formatters`
				formatters_by_ft = langspec.collect_formatters(),

				-- format on save (fast; uses LSP if no external is set)
				format_on_save = function(bufnr)
					-- large files: skip
					local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
					if ok and stats and stats.size > 50 * 1024 then -- 50 kB max size
						return nil
					end
					return { lsp_fallback = true, timeout_ms = 2000 }
				end,
				notify_on_error = true,
			})
		end,
	},
}
