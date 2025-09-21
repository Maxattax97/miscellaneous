local o, g, fn = vim.opt, vim.g, vim.fn

-- General
o.backspace = { "eol", "start", "indent" }
o.whichwrap:append("<,>,h,l,[,]")
o.fileformats = { "unix", "dos", "mac" }
o.hidden = true
o.termguicolors = true
o.lazyredraw = true
o.updatetime = 250
vim.o.updatetime = 250
o.mouse = "a"

-- Swap/backup/undo dirs
o.directory = fn.expand("~/.cache/nvim/swap/")
o.backupdir = fn.expand("~/.cache/nvim/backup/")
o.undodir = fn.expand("~/.cache/nvim/undo/")
o.undofile = true
for _, opt in ipairs({ o.backupdir, o.directory, o.undodir }) do
	for _, d in ipairs(opt:get()) do
		if fn.isdirectory(d) == 0 then
			fn.mkdir(d, "p")
		end
	end
end

-- Title
o.title = true

-- File format / indentation defaults
o.encoding = "utf-8"
o.shiftround = true
o.softtabstop = 4
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.modeline = true
vim.o.modelines = 5

-- Numbers & rulers
o.number = true
o.colorcolumn = "80,125"
o.cursorline = true
o.showmatch = true
vim.o.matchtime = 2
o.scrolloff = 7
o.showmode = false
vim.o.guifont = "Hack Nerd Font 9"

-- Colorscheme
-- vim.cmd.colorscheme("galactic")
vim.cmd.colorscheme("cyberdream")

-- Completion & wildmode
o.completeopt = { "menuone", "longest", "preview" }
o.wildmenu = true
o.wildmode = "list:longest,full"

-- Search
o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true

-- Clipboard
o.clipboard:append("unnamedplus")
