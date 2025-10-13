return {
	packages = { "marksman", "markdownlint" },
	parsers = { "markdown", "markdown_inline" },
	linters = {
		markdown = { "markdownlint" }, -- markdownlint-cli2 preferred; nvim-lint calls it "markdownlint"
	},
	formatters = {
		markdown = { "markdownlint" }, -- or prettierd/prettier
	},
}
