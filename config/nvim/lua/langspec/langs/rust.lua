return {
	packages = { "rust-analyzer" },
	parsers = { "rust" },
	linters = { rust = { "clippy" } },
	formatters = { rust = { "rustfmt" } },
	language_servers = { "rust-analyzer" },
}
