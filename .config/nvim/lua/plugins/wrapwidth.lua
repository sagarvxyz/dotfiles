return {
	"rickhowe/wrapwidth",
	ft = "markdown",
	config = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function()
				vim.opt_local.wrap = true
				vim.opt_local.linebreak = true
				vim.schedule(function()
					vim.cmd("Wrapwidth 100")
				end)
			end,
		})
	end,
}
