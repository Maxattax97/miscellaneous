return {
	packages = { "dockerfile-language-server", "hadolint" },
	parsers = { "dockerfile" },
	linters = { dockerfile = { "hadolint" } },
}
