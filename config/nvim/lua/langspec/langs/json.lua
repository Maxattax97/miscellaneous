return {
	packages = { "json-lsp", "jsonlint", "jq" },
	language_servers = { "jsonls" },
	linters = { json = { "jsonlint" } },
	formatters = {
		json = { "jq" }, -- or "prettier"/"prettierd"
	},
}
