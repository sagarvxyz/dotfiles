return {
	"nvim-pack/nvim-spectre",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	cmd = "Spectre",
	keys = {
		{ "<leader>sr", '<cmd>lua require("spectre").toggle()<cr>', desc = "Search and replace" },
		{ "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<cr>', desc = "Search current word" },
		{ "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<cr>', mode = "v", desc = "Search selection" },
	},
	opts = {
		open_cmd = "vnew",
		live_update = true,
		is_insert_mode = false,
	},
}
