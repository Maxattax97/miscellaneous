return {
	packages = { "kotlin-lsp", "ktfmt", "ktlint" },
	parsers = { "kotlin" },
	linters = { kotlin = { "ktlint" } },
	formatters = { kotlin = { "ktlint", "ktfmt" } },
	language_servers = { "kotlin_language_server" },
}
