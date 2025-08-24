vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

vim.opt.shiftwidth = 4
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.o.inccommand = "split"

vim.o.scrolloff = 10

vim.o.confirm = true

vim.opt.fillchars = "eob: "
