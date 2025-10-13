return {
	packages = { "rpm_lsp_server", "rpmlint" },
	linters = {
		-- There is also the "rpmspec" linter, but it has no package on Mason
		spec = { "rpmlint" },
	},
	language_servers = { "rpmspec" },
}
