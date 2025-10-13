return {
	packages = { "typescript-language-server", "vtsls", "eslint_d", "eslint-lsp" },
	parsers = { "javascript", "typescript", "tsx", "vue" },
	linters = {
		javascript = { "eslint_d" },
		typescript = { "eslint_d" },
		javascriptreact = { "eslint_d" },
		typescriptreact = { "eslint_d" },
		tsx = { "eslint_d" },
		jsx = { "eslint_d" },
		vue = { "eslint_d" },
	},
	formatters = {
		javascript = { "eslint_d" },
		typescript = { "eslint_d" },
		javascriptreact = { "eslint_d" },
		typescriptreact = { "eslint_d" },
		tsx = { "eslint_d" },
		jsx = { "eslint_d" },
		vue = { "eslint_d" },
	},
	language_servers = { "ts_ls", "eslint", "vtsls" },
}
