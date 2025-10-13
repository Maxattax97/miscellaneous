return {
	packages = {
		"tree-sitter-cli",
		"prettier",
		"cspell",
	},
	parsers = {},
	linters = {
		["*"] = { "cspell" },
	},
	formatters = {
		html = { "prettier" },
		css = { "prettier" },
		scss = { "prettier" },
		-- vue = { "prettier" }, -- may conflict with JS/TS
		jsonc = { "prettier" }, -- regular jason has jq
	},
	language_servers = {},
	config = nil,
}
