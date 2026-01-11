return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"ts_ls",
					"pyright",
					"jsonls",
					"yamlls",
					"lua_ls",
					"sqlls",
				},
				automatic_installation = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "mason-lspconfig.nvim" },
		config = function()
			vim.diagnostic.config({
				virtual_text = false,
				signs = {
					severity = { min = vim.diagnostic.severity.HINT },
					text = {
						[vim.diagnostic.severity.ERROR] = "✘",
						[vim.diagnostic.severity.WARN] = "▲",
						[vim.diagnostic.severity.HINT] = "⚑",
						[vim.diagnostic.severity.INFO] = "»",
					},
				},
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = true,
					header = "",
					prefix = "",
				},
			})

			vim.api.nvim_create_autocmd("CursorHold", {
				callback = function()
					vim.diagnostic.open_float(nil, {
						focusable = false,
						close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
						border = "rounded",
						source = true,
						prefix = " ",
						scope = "cursor",
					})
				end,
			})

			local on_attach = function(client, bufnr)
				local opts = { buffer = bufnr, silent = true, remap = false }

				vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
				vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
				vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
				vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
				vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
				vim.keymap.set("n", "<leader>F", function()
					require("conform").format({ async = true, lsp_fallback = true })
				end, vim.tbl_extend("force", opts, { desc = "Format" }))
			end

			local servers = {
				ts_ls = {
					settings = {
						typescript = {
							preferences = {
								includePackageJsonAutoImports = "on",
								includeCompletionsForModuleExports = true,
							},
						},
						javascript = {
							preferences = {
								includePackageJsonAutoImports = "on",
								includeCompletionsForModuleExports = true,
							},
						},
					},
				},
				pyright = {},
				jsonls = {},
				yamlls = {},
				sqlls = {},
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								library = { vim.env.VIMRUNTIME },
							},
							diagnostics = {
								globals = { "vim" },
							},
							telemetry = { enable = false },
						},
					},
				},
			}

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem = {
				documentationFormat = { "markdown", "plaintext" },
				snippetSupport = false,
				preselectSupport = true,
				insertReplaceSupport = true,
				labelDetailsSupport = true,
				deprecatedSupport = true,
				commitCharactersSupport = true,
				tagSupport = { valueSet = { 1 } },
				resolveSupport = {
					properties = {
						"documentation",
						"detail",
						"additionalTextEdits",
					},
				},
			}

			local server_cmds = {
				ts_ls = { "typescript-language-server", "--stdio" },
				pyright = { "pyright-langserver", "--stdio" },
				jsonls = { "vscode-json-language-server", "--stdio" },
				yamlls = { "yaml-language-server", "--stdio" },
				sqlls = { "sql-language-server", "up", "--method", "stdio" },
				lua_ls = { "lua-language-server" },
			}

			for server, server_config in pairs(servers) do
				vim.lsp.config(server, vim.tbl_deep_extend("force", {
					cmd = server_cmds[server],
					on_attach = on_attach,
					capabilities = capabilities,
				}, server_config))
			end
			vim.lsp.enable(vim.tbl_keys(servers))
		end,
	},
}
