local M = {}

-- A langspec contains:
-- - Mason packages found here:
--      https://mason-registry.dev/registry/list
--
-- - Tree-sitter parsers found here:
--      https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#supported-languages
--
-- - Linters found here:
--      https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#available-linters
--
-- - Formatters found via `:help conform-formatters` or here:
--      https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
--
-- - Language servers found here:
--      https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

-- Deduplicates entries in a list
local function dedup(list)
	local out, seen = {}, {}
	for _, v in ipairs(list or {}) do
		if not seen[v] then
			seen[v] = true
			table.insert(out, v)
		end
	end
	return out
end

-- Finds lua files under this module's langs directory
local function glob_submodules()
	local base = vim.fn.stdpath("config") .. "/lua/langspec/langs"
	local files = vim.fn.globpath(base, "*.lua", false, true)
	local mods = {}
	for _, f in ipairs(files) do
		local name = f:match("langs/(.+)%.lua$") or f:match("langspec/langs/(.+)%.lua$") or f:match("([^/]+)%.lua$")
		if name then
			table.insert(mods, "langspec.langs." .. name)
		end
	end
	table.sort(mods)
	return mods
end

-- Loads and returns all spec tables from langs/*.lua
local function load_specs()
	local specs = {}
	for _, mod in ipairs(glob_submodules()) do
		local ok, s = pcall(require, mod)
		if ok and type(s) == "table" then
			table.insert(specs, s)
		else
			vim.notify("langspec: failed to load " .. mod, vim.log.levels.WARN)
		end
	end
	return specs
end

-- collects a list of Mason packages to ensure are installed
function M.collect_packages()
	local acc = {}
	for _, s in ipairs(load_specs()) do
		for _, p in ipairs(s.packages or {}) do
			table.insert(acc, p)
		end
	end
	return dedup(acc)
end

-- collects a list of language servers to enable, using lspconfig names
function M.collect_language_servers()
	local acc = {}
	for _, s in ipairs(load_specs()) do
		for _, ls in ipairs(s.language_servers or {}) do
			table.insert(acc, ls)
		end
	end
	return acc
end

-- collects a map of deduplicated linters for nvim-lint, keyed by filetype
function M.collect_linters()
	-- returns a merged map: { ft = { "linter1", "linter2" } }
	local map = {}
	local function add(ft, arr)
		map[ft] = map[ft] or {}
		for _, l in ipairs(arr) do
			if not vim.tbl_contains(map[ft], l) then
				table.insert(map[ft], l)
			end
		end
	end
	for _, s in ipairs(load_specs()) do
		if type(s.linters) == "table" then
			for ft, lin in pairs(s.linters) do
				add(ft, type(lin) == "string" and { lin } or lin)
			end
		end
	end
	return map
end

-- collects a map of deduplicated formatters for conform.nvim, keyed by filetype
function M.collect_formatters()
	-- returns a merged map: { ft = { "formatter1", "formatter2" } }
	local map = {}
	local function add(ft, arr)
		map[ft] = map[ft] or {}
		for _, l in ipairs(arr) do
			if not vim.tbl_contains(map[ft], l) then
				table.insert(map[ft], l)
			end
		end
	end
	for _, s in ipairs(load_specs()) do
		if type(s.formatters) == "table" then
			for ft, lin in pairs(s.formatters) do
				add(ft, type(lin) == "string" and { lin } or lin)
			end
		end
	end
	return map
end

-- collects a list of Tree-sitter parsers to ensure are installed
function M.collect_parsers()
	local acc = {}
	for _, s in ipairs(load_specs()) do
		for _, p in ipairs(s.parsers or {}) do
			table.insert(acc, p)
		end
	end
	-- dedup reuse
	local out, seen = {}, {}
	for _, v in ipairs(acc) do
		if not seen[v] then
			seen[v] = true
			table.insert(out, v)
		end
	end
	return out
end

-- runs any config functions found in the specs
function M.run_configs()
	for _, s in ipairs(load_specs()) do
		if type(s.config) == "function" then
			pcall(s.config)
		end
	end
end

-- returns capabilities table, enhanced for nvim-cmp if available
local function capabilities()
	local ok, cmp = pcall(require, "cmp_nvim_lsp")
	local caps = vim.lsp.protocol.make_client_capabilities()
	return ok and cmp.default_capabilities(caps) or caps
end

-- sets up lspconfig servers found in the specs
function M.apply_lsp()
	-- 1) ensure per-lang config() ran (you already call run_configs() elsewhere)
	-- 2) merge capabilities into each declared server's vim.lsp.config entry
	local caps = capabilities()
	local enabled = {}
	for _, entry in ipairs(M.collect_language_servers()) do
		local name = type(entry) == "string" and entry or entry.name
		if name then
			local cfg = vim.lsp.config[name] or {}
			cfg.capabilities = vim.tbl_deep_extend("force", cfg.capabilities or {}, caps)
			vim.lsp.config[name] = cfg
			table.insert(enabled, name)
		else
			vim.notify("langspec: server entry missing name", vim.log.levels.WARN)
		end
	end
	if #enabled > 0 then
		vim.lsp.enable(enabled)
	end
end

-- sets up nvim-lint linters found in the specs
function M.apply_linters()
	local ok, lint = pcall(require, "lint")
	if not ok then
		return
	end
	lint.linters_by_ft = lint.linters_by_ft or {}
	for ft, arr in pairs(M.collect_linters()) do
		local cur = lint.linters_by_ft[ft]
		if type(cur) ~= "table" then
			cur = cur and { cur } or {}
		end
		for _, l in ipairs(arr) do
			if not vim.tbl_contains(cur, l) then
				table.insert(cur, l)
			end
		end
		lint.linters_by_ft[ft] = cur
	end
end

return M
