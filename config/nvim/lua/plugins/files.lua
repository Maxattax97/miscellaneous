return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
  config = function()
    require("neo-tree").setup({
      window = {
        mappings = {
          ["P"] = {
            "toggle_preview",
            config = {
              use_float = false,
            },
          },
        },
      },
    })

    vim.keymap.set("n", "<F2>", ":Neotree toggle<CR>", { silent = true, desc = "Toggle Neo-tree" })
  end,
  },
}
