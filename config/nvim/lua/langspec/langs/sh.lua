return {
	packages = { "shellcheck", "shfmt", "bash-language-server" },

	-- currently poor support for zsh? https://github.com/nvim-treesitter/nvim-treesitter/issues/655
	parsers = { "bash", "fish" },

	linters = {
		sh = { "shellcheck" },
		bash = { "shellcheck" },
		zsh = { "shellcheck" },
	},
	formatters = {
		sh = { "shfmt" },
		bash = { "shfmt" },
		zsh = { "shfmt" },
	},
	language_servers = { "bashls" },
}
