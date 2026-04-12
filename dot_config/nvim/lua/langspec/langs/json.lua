return {
	packages = { "json-lsp", "jsonlint", "jq" },
	parsers = { "json", "json5", "jsonc" },
	linters = { json = { "jsonlint" } },
	formatters = {
		json = { "jq" }, -- or "prettier"/"prettierd"
	},
	language_servers = { "jsonls" },
}
