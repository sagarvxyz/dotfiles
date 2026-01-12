-- Clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { remap = false })

-- Diagnostics navigation
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic", remap = false })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic", remap = false })
vim.keymap.set("n", "<leader>d", vim.diagnostic.setloclist, { desc = "Open diagnostics panel", remap = false })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move to left window", remap = false })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move to right window", remap = false })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move to lower window", remap = false })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move to upper window", remap = false })

-- Buffer/window management (from spec)
vim.keymap.set("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close buffer", remap = false })
vim.keymap.set("n", "<leader>q", "<cmd>close<CR>", { desc = "Close window", remap = false })
vim.keymap.set("n", "<leader>o", "<cmd>only<CR>", { desc = "Only this window", remap = false })

-- Quickfix navigation
vim.keymap.set("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix", remap = false })
vim.keymap.set("n", "[q", "<cmd>cprev<CR>", { desc = "Previous quickfix", remap = false })

-- Center on jump (remap = true to use neoscroll's smooth zz)
vim.keymap.set("n", "n", "nzz", { desc = "Next search result (centered)", remap = true })
vim.keymap.set("n", "N", "Nzz", { desc = "Previous search result (centered)", remap = true })

-- Delete to black hole register (don't overwrite clipboard)
vim.keymap.set({ "n", "v" }, "d", '"_d', { desc = "Delete (black hole)", remap = false })
vim.keymap.set({ "n", "v" }, "D", '"_D', { desc = "Delete to end (black hole)", remap = false })
vim.keymap.set({ "n", "v" }, "c", '"_c', { desc = "Change (black hole)", remap = false })
vim.keymap.set({ "n", "v" }, "C", '"_C', { desc = "Change to end (black hole)", remap = false })
vim.keymap.set({ "n", "v" }, "x", '"_x', { desc = "Delete char (black hole)", remap = false })
vim.keymap.set({ "n", "v" }, "X", '"_X', { desc = "Delete char before (black hole)", remap = false })

-- Keep original delete behavior with leader prefix
vim.keymap.set({ "n", "v" }, "<leader>D", "d", { desc = "Delete (to register)", remap = false })
