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
		{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "[S]earch [H]elp", mode = "n" },
		{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "[S]earch [K]eymaps", mode = "n" },
		{ "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "[S]earch [F]iles", mode = "n" },
		{ "<leader>ss", "<cmd>Telescope builtin<cr>", desc = "[S]earch [S]elect Telescope", mode = "n" },
		{ "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "[S]earch current [W]ord", mode = "n" },
		{ "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "[S]earch by [G]rep", mode = "n" },
		{ "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "[S]earch [D]iagnostics", mode = "n" },
		{ "<leader>sr", "<cmd>Telescope lsp_references<cr>", desc = "[S]earch [R]eferences", mode = "n" },
		{ "<leader>sy", "<cmd>Telescope lsp_document_symbols<cr>", desc = "[S]earch s[Y]mbols", mode = "n" },
		{ "<leader>sR", "<cmd>Telescope resume<cr>", desc = "[S]earch [R]esume", mode = "n" },
		{ "<leader>s.", "<cmd>Telescope oldfiles<cr>", desc = '[S]earch Recent Files ("." for repeat)', mode = "n" },
		{ "<leader><leader>", "<cmd>Telescope buffers<cr>", desc = "[ ] Find existing buffers", mode = "n" },
		{
			"<leader>/",
			function()
				require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end,
			desc = "[/] Fuzzily search in current buffer",
			mode = "n",
		},
		{
			"<leader>s/",
			function()
				require("telescope.builtin").live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end,
			desc = "[S]earch [/] in Open Files",
			mode = "n",
		},
		{
			"<leader>sn",
			function()
				require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "[S]earch [N]eovim files",
			mode = "n",
		},
		{ "<leader>st", "<cmd>TodoTelescope<cr>", desc = "[S]earch [T]odos", mode = "n" },
	},

	config = function()
		require("telescope").setup({
			defaults = {
				file_ignore_patterns = { "%.git/", "node_modules/", "%.DS_Store" },
			},
			pickers = {
				find_files = {
					hidden = true,
					no_ignore = true,
					follow = true,
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
