return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- Formatters for web dev and data engineering
					"stylua",
					"ruff",
					"prettierd",
					-- LSP servers focused on our use cases
					"ts_ls",
					"pyright",
					"jsonls",
					"yamlls",
					-- Debug adapters
					"js-debug-adapter",
					"debugpy",
				},
				auto_update = false,
				run_on_start = true,
			})
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
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "mason-lspconfig.nvim", "nvim-telescope/telescope.nvim" },
		config = function()
			local lspconfig = require("lspconfig")

			-- Diagnostic configuration
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
					source = "always",
					header = "",
					prefix = "",
				},
			})

			-- Auto-popup diagnostics on cursor hold
			vim.api.nvim_create_autocmd("CursorHold", {
				callback = function()
					vim.diagnostic.open_float(nil, {
						focusable = false,
						close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
						border = "rounded",
						source = "always",
						prefix = " ",
						scope = "cursor",
					})
				end,
			})

			-- Essential LSP keybindings (Pragmatic Programmer approach)
			local on_attach = function(client, bufnr)
				local opts = { buffer = bufnr, silent = true }

				-- Core navigation (use native LSP, not Telescope for speed)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
				vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
				vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))

				-- Essential code actions
				vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
				vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))

				-- Format shortcut
				vim.keymap.set("n", "<leader>F", function()
					require("conform").format({ async = true, lsp_fallback = true })
				end, vim.tbl_extend("force", opts, { desc = "Format" }))
			end

			-- Server configurations optimized for web dev and data engineering
			local servers = {
				-- TypeScript/React - optimized for better go-to-definition
				ts_ls = {
					settings = {
						typescript = {
							preferences = {
								includePackageJsonAutoImports = "on",
								includeCompletionsForModuleExports = true,
							},
							suggest = {
								includeCompletionsForImportStatements = true,
							},
						},
						javascript = {
							preferences = {
								includePackageJsonAutoImports = "on",
								includeCompletionsForModuleExports = true,
							},
							suggest = {
								includeCompletionsForImportStatements = true,
							},
						},
					},
				},
				-- Data engineering essentials
				pyright = {},  -- Python for data work
				jsonls = {},   -- JSON configurations
				yamlls = {},   -- YAML configurations
			}

			-- Set up highlight groups for better visual styling
			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = function()
					-- Diagnostic underlines with colors
					vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#f7768e" })
					vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = "#e0af68" })
					vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = "#7aa2f7" })
					vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = "#9ece6a" })

					-- LSP reference highlighting
					vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#3d3d3d" })
					vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#3d3d3d" })
					vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#3d3d3d" })
				end,
			})

			-- Trigger once for current colorscheme
			vim.schedule(function()
				vim.cmd("doautocmd ColorScheme")
			end)

			-- Enhanced LSP capabilities for better completion
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem = {
				documentationFormat = { "markdown", "plaintext" },
				snippetSupport = true,
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

			for server, config in pairs(servers) do
				lspconfig[server].setup(vim.tbl_deep_extend("force", {
					on_attach = on_attach,
					capabilities = capabilities,
				}, config))
			end
		end,
	},
}
