local function has_go()
	return vim.fn.executable("go") == 1
end

local packages = { "golangci-lint" }
if has_go() then
	-- We can only install gopls if Go is already installed on this system.
	table.insert(packages, "gopls")
	table.insert(packages, "gofumpt")
	table.insert(packages, "goimports")
	table.insert(packages, "golines")
end

return {
	packages = packages,
	parsers = {
		"go",
		"gomod",
		"gosum",
	},
	linters = { go = { "golangcilint" } },
	formatters = { go = { "gofumpt", "goimports", "golines", "golangci-lint" } },
	language_servers = { "gopls" },
}
