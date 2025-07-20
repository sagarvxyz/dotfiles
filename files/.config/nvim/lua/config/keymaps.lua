-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Toggle options
vim.keymap.set("n", "<leader>tn", function()
	vim.wo.number = not vim.wo.number
end, { desc = "[T]oggle line [N]umbers" })

vim.keymap.set("n", "<leader>tr", function()
	vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "[T]oggle [R]elative numbers" })

vim.keymap.set("n", "<leader>tw", function()
	vim.wo.wrap = not vim.wo.wrap
end, { desc = "[T]oggle line [W]rap" })

vim.keymap.set("n", "<leader>ts", function()
	vim.wo.spell = not vim.wo.spell
end, { desc = "[T]oggle [S]pellcheck" })

vim.keymap.set("n", "<leader>td", function()
	local enabled = vim.diagnostic.is_enabled()
	vim.diagnostic.enable(not enabled)
end, { desc = "[T]oggle [D]iagnostics" })

vim.keymap.set("n", "<leader>tc", function()
	vim.wo.cursorline = not vim.wo.cursorline
end, { desc = "[T]oggle [C]ursor line" })

vim.keymap.set("n", "<leader>tC", function()
	vim.wo.cursorcolumn = not vim.wo.cursorcolumn
end, { desc = "[T]oggle [C]ursor column" })

-- Window operations
vim.keymap.set("n", "<leader>ws", "<C-w>s", { desc = "[W]indow [S]plit horizontal" })
vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "[W]indow [V]ertical split" })
vim.keymap.set("n", "<leader>wc", "<C-w>c", { desc = "[W]indow [C]lose" })
vim.keymap.set("n", "<leader>wo", "<C-w>o", { desc = "[W]indow [O]nly (close others)" })
vim.keymap.set("n", "<leader>w=", "<C-w>=", { desc = "[W]indow [=] balance" })
vim.keymap.set("n", "<leader>w|", "<C-w>|", { desc = "[W]indow max [|] width" })
vim.keymap.set("n", "<leader>w_", "<C-w>_", { desc = "[W]indow max [_] height" })

-- Window resize
vim.keymap.set("n", "<leader>w+", "<C-w>+", { desc = "[W]indow [+] height" })
vim.keymap.set("n", "<leader>w-", "<C-w>-", { desc = "[W]indow [-] height" })
vim.keymap.set("n", "<leader>w>", "<C-w>>", { desc = "[W]indow [>] width" })
vim.keymap.set("n", "<leader>w<", "<C-w><", { desc = "[W]indow [<] width" })

-- Buffer management
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "[B]uffer [D]elete" })
vim.keymap.set("n", "<leader>bD", "<cmd>bdelete!<cr>", { desc = "[B]uffer [D]elete (force)" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "[B]uffer [N]ext" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "[B]uffer [P]revious" })
vim.keymap.set("n", "<leader>bl", "<cmd>buffers<cr>", { desc = "[B]uffer [L]ist" })
vim.keymap.set("n", "<leader>ba", "<cmd>ball<cr>", { desc = "[B]uffer [A]ll (open in windows)" })
