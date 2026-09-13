-- Discover vendored JSON Schemas in the current project, if any.
-- Reads <cwd>/schemas/*/schema-map.json (the same maps the CI validator uses)
-- and returns a { [schema_path] = { globs } } table for yamlls. Returns an empty
-- table when the project doesn't vendor schemas, so this is safe to run anywhere.
local function discover_schemas()
	local schemas = {}
	local root = vim.fn.getcwd()
	for _, mp in ipairs(vim.fn.globpath(root .. "/schemas", "*/schema-map.json", false, true)) do
		local f = io.open(mp, "r")
		if f then
			local ok, data = pcall(vim.json.decode, f:read("*a"))
			f:close()
			if ok and type(data) == "table" then
				local folder = vim.fn.fnamemodify(mp, ":h")
				for file, globs in pairs(data) do
					local schema_path = folder .. "/" .. file
					if file:sub(1, 1) ~= "$" and vim.uv.fs_stat(schema_path) then
						schemas[schema_path] = globs
					end
				end
			end
		end
	end
	return schemas
end

return {
	packages = {
		"yamllint",
		"ansible-lint",
		"ansible-language-server",
		"yaml-language-server",
		"yamlfmt",
		"actionlint",
		"gh-actions-language-server",
	},
	parsers = { "yaml" },
	linters = {
		yaml = { "yamllint" },
		-- TODO: make a separate filetype for GHA or Act runners, etc.
		ghaction = { "actionlint" },
		ansible = { "ansible-lint" },
	},
	formatters = { yaml = { "yamlfmt" } },
	language_servers = { "yamlls", "ansiblels", "gh_actions_ls" },
	config = function()
		vim.lsp.config("yamlls", {
			settings = {
				yaml = {
					format = {
						printWidth = 80,
					},
					schemas = discover_schemas(),
				},
			},
		})
	end,
}
