return {
	packages = { "dockerfile-language-server", "hadolint", "helm-ls" },
	parsers = { "dockerfile" },
	-- "kube-linter" exists in Mason but is not supported in linters/formatters yet
	linters = { dockerfile = { "hadolint" } },
	language_servers = {
		"docker_language_server", -- official by Docker, supports all files
		"helm_ls",
		-- "docker_compose_language_service", By Microsoft
		-- "dockerls", Kind of out of date
	},
}
