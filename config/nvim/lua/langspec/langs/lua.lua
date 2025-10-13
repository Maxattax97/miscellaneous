local packages = {
	"lua-language-server",
	"stylua",
}
local lua_linters = {}

if vim.fn.executable("luarocks") == 1 then
	-- We can only install luacheck if luarocks is already installed on this system.
	table.insert(packages, "luacheck")
	table.insert(lua_linters, "luacheck")
end

return {
	packages = packages,
	parsers = {
		"lua",
		"luadoc",
		"luap",
	},
	linters = { lua = lua_linters },
	formatters = { lua = { "stylua" } },
	language_servers = { "lua_ls", "stylua" },
	config = function()
		-- Optional: better Neovim API typing for lua_ls
		pcall(function()
			require("neodev").setup({})
		end)

		vim.lsp.config.lua_ls = {
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { enable = true, globals = { "vim" } },
					workspace = {
						checkThirdParty = false,
						library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" },
					},
					telemetry = { enable = false },
				},
			},
		}
	end,
}
