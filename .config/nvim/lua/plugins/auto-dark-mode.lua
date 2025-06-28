return {
	"f-person/auto-dark-mode.nvim",
	name = "auto-dark-mode",
	version = false,
	priority = 1000,
	config = function()
		require("auto-dark-mode").setup({
			update_interval = 1000 * 60 * 60,
			set_dark_mode = function()
				vim.api.nvim_set_option("background", "dark")
				vim.cmd("colorscheme rose-pine-moon")
			end,
			set_light_mode = function()
				vim.api.nvim_set_option("background", "light")
				vim.cmd("colorscheme rose-pine-dawn")
			end,
		})
	end,
}
