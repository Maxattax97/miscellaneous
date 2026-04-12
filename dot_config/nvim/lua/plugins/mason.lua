return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		config = function()
			local langspec = require("langspec")
			require("mason-tool-installer").setup({
				ensure_installed = langspec.collect_packages(),
				run_on_start = true,
				auto_update = true,
				start_delay = 3000, -- ms, wait for Mason to boot cleanly
				debounce_hours = 0, -- 168, -- update only once a week
			})
		end,
	},
	-- {
	-- 	"zapling/mason-lock.nvim",
	-- 	config = function()
	-- 		require("mason-lock").setup({
	-- 			lockfile_path = vim.fn.stdpath("config") .. "/mason-lock.json", -- (default)
	-- 		})
	-- 	end,
	-- },
}
