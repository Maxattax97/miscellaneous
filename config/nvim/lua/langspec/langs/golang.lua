local packages = { "golangci-lint" }
if vim.fn.executable("go") == 1 then
	-- We can only install gopls if Go is already installed on this system.
	table.insert(packages, "gopls")
	table.insert(packages, "gofumpt")
	table.insert(packages, "goimports")
	-- table.insert(packages, "golines") -- Entegrata does not limit line length
end

return {
	packages = packages,
	parsers = {
		"go",
		"gomod",
		"gosum",
	},
	linters = { go = { "golangcilint" } },
	formatters = { go = { "gofumpt", "goimports", "golangci-lint" } }, -- "golines", -- Entegrata does not limit line length
	language_servers = { "gopls" },
}
