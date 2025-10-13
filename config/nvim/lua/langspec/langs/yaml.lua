return {
	packages = {
		"yamllint",
		"ansible-lint",
		"ansible-language-server",
		"yaml-language-server",
		"yamlfmt",
		"actionlint",
		"gh-actions-language-server",
	},
	parsers = { "yaml" },
	linters = {
		yaml = { "yamllint" },
		-- TODO: make a separate filetype for GHA or Act runners, etc.
		ghaction = { "actionlint" },
		ansible = { "ansible-lint" },
	},
	formatters = { yaml = { "yamlfmt" } },
	language_servers = { "yamlls", "ansiblels", "gh_actions_ls" },
}
