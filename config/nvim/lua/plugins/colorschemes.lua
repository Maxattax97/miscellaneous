return {
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("cyberdream").setup({
				transparent = true,
				-- what you gonna do about it
				italic_comments = true,
				borderless_pickers = true,
				colors = {
					-- Galactic color scheme
					-- Color: base03               #262626                ~        8
					-- Color: base02               #303030                ~        0
					-- Color: base01               #6a6a6a                ~        10
					-- Color: base00               #777777                ~        11
					-- Color: base0                #919191                ~        12
					-- Color: base1                #9e9e9e                ~        14
					-- Color: base2                #e8e8e8                ~        7
					-- Color: base3                #f6f6f6                ~        15
					-- Color: yellow               #a68f01                ~        3
					-- Color: orange               #dd7202                ~        9
					-- Color: red                  #ff511a                ~        1
					-- Color: magenta              #fe3bb9                ~        5
					-- Color: violet               #cc62fe                ~        13
					-- Color: blue                 #3294ff                ~        4
					-- Color: cyan                 #07a38f                ~        6
					-- Color: green                #4ca340                ~        2
					-- #Color:green                #719e07                ~        2
					-- Color: back                 #262626                ~        8
					blue = "#3294ff",
					green = "#4ca340",
					cyan = "#07a38f",
					red = "#ff511a",
					yellow = "#a68f01",
					magenta = "#fe3bb9",
					pink = "#fe3bb9", -- this is just magenta again
					orange = "#dd7202",
					purple = "#cc62fe",
					grey = "#777777", -- base00
					fg = "#f6f6f6", -- base3
					bg = "#262626", -- base03
					bg_solid = "#262626", -- same as bg
					bg_alt = "#303030", -- base02
					bg_highlight = "#303030", -- base02
				},
			})
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		"Maxattax97/vim-galactic",
		lazy = false,
		priority = 1000,
	},
}
