-- Optional: better Neovim API typing for lua_ls
pcall(function() require("neodev").setup({}) end)

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

return "lua_ls"
