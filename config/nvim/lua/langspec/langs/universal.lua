return {
	packages = {
		"tree-sitter-cli",
		"prettier",
	},
	parsers = {},
	linters = {},
	formatters = {
		html = { "prettier" },
		css = { "prettier" },
		scss = { "prettier" },
		-- vue = { "prettier" }, -- may conflict with JS/TS
		jsonc = { "prettier" },
	},
	language_servers = {},
	config = nil,
}
