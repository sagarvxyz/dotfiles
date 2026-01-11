return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	ft = { "markdown" },
	opts = {
		heading = {
			enabled = true,
			sign = false,
			icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
		},
		code = {
			enabled = true,
			sign = false,
			style = "full",
		},
		bullet = {
			enabled = true,
			icons = { "●", "○", "◆", "◇" },
		},
		checkbox = {
			enabled = true,
			unchecked = { icon = "☐ " },
			checked = { icon = "☑ " },
		},
		quote = {
			enabled = true,
		},
		pipe_table = {
			enabled = true,
			style = "full",
		},
	},
	keys = {
		{
			"<leader>mt",
			function()
				require("render-markdown").toggle()
			end,
			desc = "Toggle markdown render",
		},
	},
}
