function attach_auto_formatter(client, bufnr, opts)
  opts = vim.F.if_nil(opts, {})
  if client.supports_method("textDocument/rangeFormatting") then
    local result = require("lsp-format-modifications").attach(client, bufnr,
      {
        format_on_save = true,
        experimental_empty_line_handling = true,
        format_callback = function(diff)
          vim.lsp.buf.format(vim.tbl_extend("keep", opts, diff))
        end,
      })
    if result.success then
      vim.notify("Ranger formatter " .. client.name .. " is attached to the buffer")
    else
      vim.notify("Ranger formatter " .. client.name .. " cannot be attached to the buffer")
    end
  elseif client.supports_method("textDocument/formatting") then
    local augroup = vim.api.nvim_create_augroup("LspFileFormatting", {})
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre",
      {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format(opts)
        end,
      })
    vim.notify("Formatter " .. client.name .. " is attached to the buffer")
  end
end

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
	},

	config = function()
		local cmp = require("cmp")
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
				"stylelint_lsp",
				"lua_ls",
				"rust_analyzer",
				"gopls",
				"tsserver", -- lsp sever
			},
			handlers = {
				function(server_name) -- default handler (optional)
					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end,
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = "Lua 5.1" },
                diagnostics = {
                  globals = { "vim", "it", "describe", "before_each", "after_each" },
                },
              },
            },
            on_attach = function(client, bufnr)
              attach_auto_formatter(client, bufnr, { name = "lua_ls" })
            end
          })
        end,
				["tsserver"] = function()
					lspconfig.tsserver.setup({
						on_attach = function(client)
							-- disable the formatting from tsserver
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
        -- TODO: add custom config if pyright conflicts with linter or formatter
        -- ["pyright"] = function() end,
			},
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- For luasnip users.
			}, {
				{ name = "buffer" },
			}),
		})

		vim.diagnostic.config({
			-- update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
	end,
}
