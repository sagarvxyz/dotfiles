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
					-- Formatters
					"stylua",
					"ruff", 
					"prettierd",
					"prettier",
					"google-java-format",
					-- LSP servers (keeping existing ones)
					"ts_ls",
					"pyright", 
					"jsonls",
					"yamlls",
					"gopls",
					"jdtls",
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
					"gopls",
					"jdtls",
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

			-- Diagnostic signs
			local signs = { Error = "✘", Warn = "▲", Hint = "⚑", Info = "»" }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

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

			-- LSP keybindings function
			local on_attach = function(client, bufnr)
				local opts = { buffer = bufnr, silent = true }
				
				-- Core 'g' prefixed actions
				vim.keymap.set("n", "grn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "LSP: [R]e[n]ame" }))
				vim.keymap.set("n", "gra", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "LSP: Code [A]ction" }))
				vim.keymap.set("n", "grr", "<cmd>Telescope lsp_references<cr>", vim.tbl_extend("force", opts, { desc = "LSP: [R]eferences" }))
				vim.keymap.set("n", "gri", "<cmd>Telescope lsp_implementations<cr>", vim.tbl_extend("force", opts, { desc = "LSP: [I]mplementation" }))
				vim.keymap.set("n", "grd", "<cmd>Telescope lsp_definitions<cr>", vim.tbl_extend("force", opts, { desc = "LSP: [D]efinition" }))
				vim.keymap.set("n", "grD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "LSP: [D]eclaration" }))
				vim.keymap.set("n", "grt", "<cmd>Telescope lsp_type_definitions<cr>", vim.tbl_extend("force", opts, { desc = "LSP: [T]ype Definition" }))

				-- Manual popups
				vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "LSP: Hover Documentation" }))
				vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "LSP: Signature Documentation" }))

				-- Code actions
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "[C]ode [A]ction" }))
				vim.keymap.set("n", "<leader>cf", function()
					require("conform").format({ async = true, lsp_fallback = true })
				end, vim.tbl_extend("force", opts, { desc = "[C]ode [F]ormat" }))
				vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "[C]ode [R]ename" }))
				vim.keymap.set("n", "<leader>cs", "<cmd>Telescope lsp_document_symbols<cr>", vim.tbl_extend("force", opts, { desc = "[C]ode [S]ymbols" }))
				vim.keymap.set("n", "<leader>cS", "<cmd>Telescope lsp_workspace_symbols<cr>", vim.tbl_extend("force", opts, { desc = "[C]ode workspace [S]ymbols" }))
				vim.keymap.set("n", "<leader>cI", "<cmd>LspInfo<cr>", vim.tbl_extend("force", opts, { desc = "[C]ode LSP [I]nfo" }))
				
				-- Inlay hints toggle
				if vim.lsp.inlay_hint then
					vim.keymap.set("n", "<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
					end, vim.tbl_extend("force", opts, { desc = "[T]oggle inlay [H]ints" }))
				end
			end

			-- Server configurations
			local servers = {
				ts_ls = {
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
						javascript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
					},
				},
				pyright = {},
				jsonls = {},
				yamlls = {},
				gopls = {
					settings = {
						gopls = {
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
						},
					},
				},
				jdtls = {},
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