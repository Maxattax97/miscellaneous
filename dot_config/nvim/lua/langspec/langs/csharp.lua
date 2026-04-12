local packages = {}
if vim.fn.executable("nuget") == 1 then
	-- We can only install csharp-language-server if Nuget is already installed on this system.
	table.insert(packages, "csharp-language-server")
end

return {
	packages = packages,
	parsers = { "c_sharp" },
	language_servers = { "csharp_ls" },
}
