return {
	packages = { "yamllint", "ansible-lint", "ansible-language-server", "yaml-language-server", "yamlfmt" },
	parsers = { "yaml" },
	linters = {
		yaml = { "yamllint" },
		ansible = { "ansible-lint" },
	},
	formatters = { yaml = { "yamlfmt" } },
	language_servers = { "yamlls", "ansiblels" },
}
