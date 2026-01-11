return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	lazy = false,
	keys = {
		{ "\\", ":Neotree toggle<CR>", desc = "Neo-tree toggle", silent = true },
		{ "<leader>e", ":Neotree focus<CR>", desc = "Neo-tree focus", silent = true },
	},
	opts = {
		close_if_last_window = true,
		popup_border_style = "rounded",
		default_component_configs = {
			icon = {
				folder_closed = "+",
				folder_open = "-",
				folder_empty = "o",
				default = "*",
				highlight = "NeoTreeFileIcon",
			},
			git_status = {
				symbols = {
					added = "+",
					deleted = "-",
					modified = "*",
					renamed = "r",
					untracked = "?",
					ignored = "i",
					unstaged = "u",
					staged = "s",
					conflict = "x",
				},
			},
		},
		filesystem = {
			filtered_items = {
				visible = true,
				hide_dotfiles = false,
				hide_gitignored = false,
			},
			follow_current_file = {
				enabled = true,
			},
			use_libuv_file_watcher = true,
		},
		window = {
			width = 35,
			mappings = {
				["<space>"] = "none",
			},
		},
	},
}
