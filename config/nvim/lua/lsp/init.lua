local M = {}

-- Helper: normalize module returns to a list of server names
local function normalize(ret)
	if ret == nil then
		return {}
	end
	if type(ret) == "string" then
		return { ret }
	end
	if type(ret) == "table" then
		return ret
	end
	return {}
end

function M.setup()
	local enabled = {}

	-- OPTION A: Manually list modules (explicit order)
	local modules = {
		-- "lsp.servers.lua_ls",
		-- "lsp.servers.pyright",
		-- "lsp.servers.clangd",
		-- add more here as you create them…
	}

	-- OPTION B (auto-discover every file under lsp/servers/*.lua)
	for path in vim.fs.dir(vim.fn.stdpath("config") .. "/lua/lsp/servers") do
		if path:sub(-4) == ".lua" then
			table.insert(modules, "lsp.servers." .. path:sub(1, -5))
		end
	end

	for _, mod in ipairs(modules) do
		local ok, ret = pcall(require, mod)
		if ok then
			for _, name in ipairs(normalize(ret)) do
				table.insert(enabled, name)
			end
		else
			vim.notify(("LSP module failed: %s\n%s"):format(mod, ret), vim.log.levels.WARN)
		end
	end

	-- Enhance capabilities for nvim-cmp
	local caps = vim.lsp.protocol.make_client_capabilities()
	local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
	if ok_cmp then
		caps = cmp_lsp.default_capabilities(caps)
	end
	for _, name in ipairs(enabled) do
		local cfg = vim.lsp.config[name] or {}
		cfg.capabilities = vim.tbl_deep_extend("force", cfg.capabilities or {}, caps)
		vim.lsp.config[name] = cfg
	end

	-- One call to enable all declared servers
	if #enabled > 0 then
		vim.lsp.enable(enabled)
	end
end

--[[
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
      local servers = {
        "ansiblels",
        "basedpyright",
        "bashls",
        "bitbake_language_server",
        "clangd",
        "cmake",
        "copilot", -- should I use a dedicated plugin for this?
        "csharp_ls",
        "cspell_ls",
        "cssls",
        "denols",
        "docker_language_server", -- official by Docker, supports all files
        "dotls",
        "emmet_language_server", -- better maintained than emmet_ls
        "eslint",
        "gdscript",
        "gdshader_lsp",
        "gh_actions_ls",
        "golangci_lint_ls",
        "gopls",
        "helm_ls",
        "html",
        "intelephense",
        "jdtls", -- see for improved support: https://codeberg.org/mfussenegger/nvim-jdtls
        "jsonls",
        "kotlin_lsp",
        "lua_ls",
        "marksman",
        "nginx_language_server",
        "openscad_lsp",
        "qmlls",
        "r_language_server",
        "rpmspec",
        "rust_analyzer",
        "sqls",
        "stylua", -- INSTALL: cargo install stylua
        "taplo",
        "terraformls",
        "texlab",
        "vimls",
        "vue_ls",
        "vtsls",
        "yamlls",
        -- "docker_compose_language_service", By Microsoft
        -- "dockerls", Kind of out of date
      }
]]
--

return M
