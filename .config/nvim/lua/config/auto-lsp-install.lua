-- Auto-install LSP servers based on filetype
local M = {}

-- Mapping of filetypes to LSP servers
local filetype_to_lsp = {
	cpp = "clangd",
	c = "clangd",
	rust = "rust_analyzer", 
	go = "gopls",
	java = "jdtls",
	python = "pyright",
	lua = "lua_ls",
	javascript = "ts_ls",
	typescript = "ts_ls",
	vue = "volar",
	svelte = "svelte",
	json = "jsonls",
	yaml = "yamlls",
	yml = "yamlls",
}

function M.setup()
	vim.api.nvim_create_autocmd("FileType", {
		callback = function(args)
			local filetype = args.match
			local lsp_server = filetype_to_lsp[filetype]
			
			if lsp_server then
				-- Check if server is already installed
				local mason_registry = require("mason-registry")
				if not mason_registry.is_installed(lsp_server) then
					vim.notify("Installing " .. lsp_server .. " for " .. filetype .. " files...")
					local package = mason_registry.get_package(lsp_server)
					package:install()
				end
			end
		end,
	})
end

return M
