vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.statuscolumn = "%s%=%{v:relnum?v:relnum:v:lnum} "
vim.o.cursorline = true
vim.o.cursorlineopt = "number"
vim.o.cmdheight = 0

vim.api.nvim_set_hl(0, "CursorLineNr", { bold = true })

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.o.inccommand = "split"

vim.o.scrolloff = 10

vim.opt.fillchars = { eob = " " }

vim.o.confirm = true

vim.o.wrap = true
vim.o.linebreak = true

vim.o.mouse = "a"

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)
