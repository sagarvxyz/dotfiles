return {
	"lewis6991/gitsigns.nvim",
	opts = {
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")
			local opts = { buffer = bufnr, silent = true }

			-- Navigation
			vim.keymap.set("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end, vim.tbl_extend("force", opts, { desc = "Next git [C]hange" }))

			vim.keymap.set("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end, vim.tbl_extend("force", opts, { desc = "Previous git [C]hange" }))

			-- Git actions
			vim.keymap.set("n", "<leader>gs", gitsigns.stage_hunk, vim.tbl_extend("force", opts, { desc = "[G]it [S]tage hunk" }))
			vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk, vim.tbl_extend("force", opts, { desc = "[G]it [R]eset hunk" }))
			vim.keymap.set("v", "<leader>gs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, vim.tbl_extend("force", opts, { desc = "[G]it [S]tage selection" }))
			vim.keymap.set("v", "<leader>gr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, vim.tbl_extend("force", opts, { desc = "[G]it [R]eset selection" }))
			vim.keymap.set("n", "<leader>gS", gitsigns.stage_buffer, vim.tbl_extend("force", opts, { desc = "[G]it [S]tage buffer" }))
			vim.keymap.set("n", "<leader>gu", gitsigns.undo_stage_hunk, vim.tbl_extend("force", opts, { desc = "[G]it [U]ndo stage hunk" }))
			vim.keymap.set("n", "<leader>gR", gitsigns.reset_buffer, vim.tbl_extend("force", opts, { desc = "[G]it [R]eset buffer" }))
			vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk, vim.tbl_extend("force", opts, { desc = "[G]it [P]review hunk" }))
			vim.keymap.set("n", "<leader>gb", function()
				gitsigns.blame_line({ full = true })
			end, vim.tbl_extend("force", opts, { desc = "[G]it [B]lame line" }))
			vim.keymap.set("n", "<leader>gtb", gitsigns.toggle_current_line_blame, vim.tbl_extend("force", opts, { desc = "[G]it [T]oggle [B]lame" }))
			vim.keymap.set("n", "<leader>gd", gitsigns.diffthis, vim.tbl_extend("force", opts, { desc = "[G]it [D]iff this" }))
			vim.keymap.set("n", "<leader>gD", function()
				gitsigns.diffthis("~")
			end, vim.tbl_extend("force", opts, { desc = "[G]it [D]iff this ~" }))
			vim.keymap.set("n", "<leader>gtd", gitsigns.toggle_deleted, vim.tbl_extend("force", opts, { desc = "[G]it [T]oggle [D]eleted" }))

			-- Text object
			vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", vim.tbl_extend("force", opts, { desc = "Git hunk text object" }))
		end,
	},
}
