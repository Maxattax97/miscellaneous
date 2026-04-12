return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			animate = { enabled = false },
			scroll = { enabled = false },
			dim = { enabled = false },
			explorer = { enabled = false }, -- I have NeoTree already
			scroll = { enabled = false }, -- I think this is for touchpad scrolling?

			indent = {
				enabled = true,
				animate = {
					enabled = false,
				},
			},

			bigfile = { enabled = true },
			dashboard = { enabled = true },
			debug = { enabled = true },
			input = { enabled = true },
			picker = { enabled = true },
			notifier = { enabled = true },
			notify = { enabled = true },
			quickfile = { enabled = true },
			rename = { enabled = true },
			scope = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
		},
	},
}
