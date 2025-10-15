return {
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
		enabled = true,
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
					-- Color: magenta              #fe3bb9                ~        5 Color: violet               #cc62fe                ~        13
					-- Color: blue                 #3294ff                ~        4 Color: cyan                 #07a38f                ~        6
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
		enabled = true,
		opts = {
			style = "night",
			transparent = true,
			on_colors = function(colors)
				-- colors = {
				-- 	bg = "#1a1b26",
				-- 	bg_dark = "#16161e",
				-- 	bg_dark1 = "#0C0E14",
				-- 	bg_float = "#16161e",
				-- 	bg_highlight = "#292e42",
				-- 	bg_popup = "#16161e",
				-- 	bg_search = "#3d59a1",
				-- 	bg_sidebar = "#16161e",
				-- 	bg_statusline = "#16161e",
				-- 	bg_visual = "#283457",
				-- 	black = "#15161e",
				-- 	blue = "#7aa2f7",
				-- 	blue0 = "#3d59a1",
				-- 	blue1 = "#2ac3de",
				-- 	blue2 = "#0db9d7",
				-- 	blue5 = "#89ddff",
				-- 	blue6 = "#b4f9f8",
				-- 	blue7 = "#394b70",
				-- 	border = "#15161e",
				-- 	border_highlight = "#27a1b9",
				-- 	comment = "#565f89",
				-- 	cyan = "#7dcfff",
				-- 	dark3 = "#545c7e",
				-- 	dark5 = "#737aa2",
				-- 	diff = {
				-- 		add = "#243e4a",
				-- 		change = "#1f2231",
				-- 		delete = "#4a272f",
				-- 		text = "#394b70",
				-- 	},
				-- 	error = "#db4b4b",
				-- 	fg = "#c0caf5",
				-- 	fg_dark = "#a9b1d6",
				-- 	fg_float = "#c0caf5",
				-- 	fg_gutter = "#3b4261",
				-- 	fg_sidebar = "#a9b1d6",
				-- 	git = {
				-- 		add = "#449dab",
				-- 		change = "#6183bb",
				-- 		delete = "#914c54",
				-- 		ignore = "#545c7e",
				-- 	},
				-- 	green = "#9ece6a",
				-- 	green1 = "#73daca",
				-- 	green2 = "#41a6b5",
				-- 	hint = "#1abc9c",
				-- 	info = "#0db9d7",
				-- 	magenta = "#bb9af7",
				-- 	magenta2 = "#ff007c",
				-- 	none = "NONE",
				-- 	orange = "#ff9e64",
				-- 	purple = "#9d7cd8",
				-- 	rainbow = { "#7aa2f7", "#e0af68", "#9ece6a", "#1abc9c", "#bb9af7", "#9d7cd8", "#ff9e64", "#f7768e" },
				-- 	red = "#f7768e",
				-- 	red1 = "#db4b4b",
				-- 	teal = "#1abc9c",
				-- 	terminal = {
				-- 		black = "#15161e",
				-- 		black_bright = "#414868",
				-- 		blue = "#7aa2f7",
				-- 		blue_bright = "#8db0ff",
				-- 		cyan = "#7dcfff",
				-- 		cyan_bright = "#a4daff",
				-- 		green = "#9ece6a",
				-- 		green_bright = "#9fe044",
				-- 		magenta = "#bb9af7",
				-- 		magenta_bright = "#c7a9ff",
				-- 		red = "#f7768e",
				-- 		red_bright = "#ff899d",
				-- 		white = "#a9b1d6",
				-- 		white_bright = "#c0caf5",
				-- 		yellow = "#e0af68",
				-- 		yellow_bright = "#faba4a",
				-- 	},
				-- 	terminal_black = "#414868",
				-- 	todo = "#7aa2f7",
				-- 	warning = "#e0af68",
				-- 	yellow = "#e0af68",
				-- }
			end,
			on_highlights = function(highlights, colors)
				-- customize highlights here
			end,
		},
	},
	{
		"Maxattax97/vim-galactic",
		lazy = false,
		priority = 1000,
		enabled = true,
	},
	{
		"RRethy/base16-nvim",
		lazy = false,
		priority = 1000,
		enabled = false,
		config = function()
			require("base16-colorscheme").setup({
				base00 = "#262626",
				base01 = "#303030",
				base02 = "#6a6a6a",
				base03 = "#777777",
				base04 = "#919191",
				base05 = "#9e9e9e",
				base06 = "#e8e8e8",
				base07 = "#f6f6f6",
				base08 = "#ff511a",
				base09 = "#dd7202",
				base0A = "#a68f01",
				base0B = "#4ca340",
				base0C = "#07a38f",
				base0D = "#3294ff",
				base0E = "#cc62fe",
				base0F = "#fe3bb9",
			})

			local groups = {
				"Normal", -- main text
				"NormalNC", -- non-current windows
				-- "SignColumn",   -- sign gutter (git signs, diagnostics)
				-- "MsgArea",      -- command line messages
				-- "TelescopeNormal",
				-- "NvimTreeNormal",
				-- "NormalFloat",  -- floating windows
				-- "FloatBorder",
				-- "WinSeparator", -- vertical split lines
				-- "EndOfBuffer",  -- ~ lines at the end
				-- "TabLineFill",  -- empty tabline space
			}

			-- Drop out the background so it's transparent
			for _, group in ipairs(groups) do
				vim.api.nvim_set_hl(0, group, { bg = "none" })
			end
		end,
	},
}
