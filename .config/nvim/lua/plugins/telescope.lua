return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	version = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-telescope/telescope-ui-select.nvim",
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},

	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
		{ "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
		{ "<leader>fr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
		{ "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Symbols" },
		{ "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
		{ "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Search word under cursor" },
		{ "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
		{ "<leader>fn", function()
			require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
		end, desc = "Neovim config files" },
		{ "<leader>/", function()
			require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, desc = "Fuzzy search in buffer" },
		{ "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Todo comments" },
	},

	config = function()
		require("telescope").setup({
			defaults = {
				file_ignore_patterns = { "%.git/", "node_modules/", "%.DS_Store" },
			},
			pickers = {
				find_files = {
					hidden = true,
					no_ignore = false,
					follow = true,
				},
				live_grep = {
					additional_args = function()
						return { "--hidden" }
					end,
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
	end,
}
