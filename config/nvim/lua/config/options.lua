-- General
vim.opt.backspace = { "eol", "start", "indent" }
vim.opt.whichwrap:append("<,>,h,l,[,]")
vim.opt.fileformats = { "unix", "dos", "mac" }
vim.opt.hidden = true
vim.opt.termguicolors = true
vim.opt.lazyredraw = true
vim.opt.updatetime = 250
vim.opt.updatetime = 250
vim.opt.mouse = "a"

-- Swap/backup/undo dirs
vim.opt.directory = vim.fn.expand("~/.cache/nvim/swap/")
vim.opt.backupdir = vim.fn.expand("~/.cache/nvim/backup/")
vim.opt.undodir = vim.fn.expand("~/.cache/nvim/undo/")
vim.opt.undofile = true
for _, opt in ipairs({ vim.opt.backupdir, vim.opt.directory, vim.opt.undodir }) do
	for _, d in ipairs(opt:get()) do
		if vim.fn.isdirectory(d) == 0 then
			vim.fn.mkdir(d, "p")
		end
	end
end

-- Title
vim.opt.title = true

-- File format / indentation defaults
vim.opt.encoding = "utf-8"
vim.opt.shiftround = true
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.modeline = true
vim.opt.modelines = 5

-- Numbers & rulers
vim.opt.number = true
vim.opt.colorcolumn = "80,125"
vim.opt.cursorline = true
vim.opt.showmatch = true
vim.opt.matchtime = 2
vim.opt.scrolloff = 7
vim.opt.showmode = false
vim.opt.guifont = "Hack Nerd Font 9"

-- Colorscheme
vim.cmd.colorscheme("galactic")

-- Completion & wildmode
vim.opt.completeopt = { "menuone", "longest", "preview" }
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest,full"

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Clipboard
vim.opt.clipboard:append("unnamedplus")
