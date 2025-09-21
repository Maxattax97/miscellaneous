return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				python = { "ruff" }, -- super fast; replaces flake8/pycodestyle
				go = { "golangci_lint" },
				sh = { "shellcheck" },
				bash = { "shellcheck" },
				zsh = { "shellcheck" },
				dockerfile = { "hadolint" },
				yaml = { "yamllint" },
				json = { "jsonlint" },
				markdown = { "markdownlint" }, -- markdownlint-cli2 preferred; nvim-lint calls it "markdownlint"
				sql = { "sqlfluff" },
				javascript = { "eslint_d" }, -- or "eslint" if you don’t use eslint_d
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				vue = { "eslint_d" },
			}

			-- run automatically
			local group = vim.api.nvim_create_augroup("NvimLint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
				group = group,
				callback = function()
					-- don't spam lint on huge files
					local name = vim.api.nvim_buf_get_name(0)
					local ok, s = pcall(vim.uv.fs_stat, name)
					if ok and s and s.size > 800 * 1024 then
						return
					end
					require("lint").try_lint()
				end,
			})

			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				severity_sort = true,
				float = { border = "none", source = "if_many" },
			})

			vim.diagnostic.goto_next({ wrap = false })

			-- Show diagnostic float on hover (normal & insert)
			local diag_grp = vim.api.nvim_create_augroup("DiagFloat", { clear = true })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				group = diag_grp,
				callback = function()
					vim.diagnostic.open_float(nil, {
						scope = "cursor",
						focus = false,
						border = "none",
						source = "if_many",
					})
				end,
			})

			-- Diagnostic navigation
			vim.keymap.set("n", "<leader>e", function()
				vim.diagnostic.jump({ count = 1, wrap = true })
			end, { desc = "Next diagnostic" })

			vim.keymap.set("n", "<leader>E", function()
				vim.diagnostic.jump({ count = -1, wrap = true })
			end, { desc = "Previous diagnostic" })
		end,
	},
}
