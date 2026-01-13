return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_fix", "ruff_format" },
				javascript = { "eslint_d", "prettier", "biome", stop_after_first = true },
				typescript = { "eslint_d", "prettier", "biome", stop_after_first = true },
				javascriptreact = { "eslint_d", "prettier", "biome", stop_after_first = true },
				typescriptreact = { "eslint_d", "prettier", "biome", stop_after_first = true },
				json = { "prettier", "biome", stop_after_first = true },
				yaml = { "prettier" },
				markdown = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
			},
			default_format_opts = {
				lsp_fallback = true,
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
			notify_on_error = true,
			notify_no_formatters = true,
		})

		vim.api.nvim_create_user_command("FormatInfo", function()
			local bufnr = vim.api.nvim_get_current_buf()
			local formatters = conform.list_formatters(bufnr)
			if #formatters == 0 then
				vim.notify("No formatters available for this buffer", vim.log.levels.INFO)
			else
				local names = vim.tbl_map(function(f)
					return f.name .. (f.available and "" or " (unavailable)")
				end, formatters)
				vim.notify("Formatters: " .. table.concat(names, ", "), vim.log.levels.INFO)
			end
		end, { desc = "Show available formatters" })
	end,
}
