return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"j-hui/fidget.nvim",
	},

	config = function()
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		require("fidget").setup({})
		require("mason").setup()

		local lspconfig = require("lspconfig")

		require("mason-lspconfig").setup({
			ensure_installed = {
				-- typescript/javascript
				"ts_ls",
				"cssmodules_ls",
				-- css related
				"stylelint_lsp",
				"cssls",
				-- graphql
				"graphql",
				-- python
				"pyright",
				-- lua
				"lua_ls",
				-- rust
				"rust_analyzer",
				-- go
				"gopls",
				-- markdown
				-- "zk",
				-- others(not lsp):
				-- "css_variables",
			},
			handlers = {
				function(server_name) -- default handler (optional)
					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end,
				["ts_ls"] = function()
					-- A workaround to fix the exception that occurs on jumping to a css style.
					-- 2 Steps solution:
					--    1. disable ts_ls go to definition for it. See more details at https://github.com/neovim/neovim/issues/19237#issuecomment-2259638650
					--    2. install and config cssmodules-language-server from Mason. A nice catch from https://github.com/neovim/neovim/issues/19237#issuecomment-1509945822
					local tsHandlers = {
						["textDocument/definition"] = function(err, result, params, ...)
							if result == nil or vim.tbl_isempty(result) then
								return nil
							end

							if vim.islist(result) then
								for _, value in pairs(result) do
									local uri = value.targetUri
									if uri == nil then
										return nil
									else
										-- definition of disbaled file extensions
										local extensions_to_check = { ".less", ".scss", ".css" } -- INFO: not sure if we should disable css as well

										local function ends_with(str, suffix)
											local str_len = string.len(str)
											local suffix_len = string.len(suffix)

											return str_len >= suffix_len and string.sub(str, -suffix_len) == suffix
										end

										for _, extension in ipairs(extensions_to_check) do
											if ends_with(uri, extension) then
												return nil
											end
										end
									end
								end
							end
							return vim.lsp.handlers["textDocument/definition"](err, result, params, ...)
						end,
					}

					lspconfig.ts_ls.setup({
						handlers = tsHandlers,
						on_attach = function(client)
							-- disable the formatting from ts_ls
							client.server_capabilities.documentFormattingProvider = false
							client.server_capabilities.documentRangeFormattingProvider = false
						end,
						capabilities = capabilities,
						init_options = {
							preferences = {
								importModuleSpecifierPreference = "relative",
								importModuleSpecifierEnding = "minimal",
								-- inlay hints
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = true,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
					})
				end,
				-- reference at https://github.com/elijah-potter/harper/blob/88f675af0e250871ac9ee9822f5090985b90d8b8/harper-ls/README.md
				["harper_ls"] = function()
					lspconfig.harper_ls.setup({
						settings = {
							["harper-ls"] = {
								diagnosticSeverity = "information",
								linters = {
									spell_check = false,
									sentence_capitalization = false,
								},
							},
						},
					})
				end,
			},
		})

		vim.diagnostic.config({
			-- update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = true,
				header = "",
				prefix = "",
			},
		})
	end,
}
