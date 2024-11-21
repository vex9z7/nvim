return {
	"stevearc/conform.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"zapling/mason-conform.nvim",
	},
	keys = {
		{
			"<leader><leader>uf",
			function()
				vim.b.disable_autoformat = not vim.b.disable_autoformat
				if vim.b.disable_autoformat then
					vim.print("auto formatter disabled (buffer)")
				else
					vim.print("auto formatter enabled (buffer)")
				end
			end,
			mode = { "v", "n" },
			desc = "Toggle autoformatting (buffer)",
		},
		{
			"<leader><leader>uF",
			function()
				vim.g.disable_autoformat = not vim.g.disable_autoformat
				if vim.g.disable_autoformat then
					vim.print("auto formatter disabled (global)")
				else
					vim.print("auto formatter enabled (global)")
				end
			end,
			mode = { "v", "n" },
			desc = "Toggle autoformatting (global)",
		},
	},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				-- Conform will run multiple formatters sequentially
				lua = { "stylua" },
				python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
				rust = { "rustfmt" },
				javascript = { "eslint_d", "prettierd" },
				javascriptreact = { "eslint_d", "prettierd" },
				typescript = { "eslint_d", "prettierd" },
				typescriptreact = { "eslint_d", "prettierd" },
				css = { "stylelint", "prettierd" },
				less = { "stylelint", "prettierd" },
				json = { "prettierd" },
				yaml = { "prettierd" },
				markdown = { "prettierd" },
			},

			-- Toggle auto format
			-- see https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#command-to-toggle-format-on-save
			format_on_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return {
					-- These options will be passed to conform.format()
					timeout_ms = 500,
					lsp_format = "fallback",
				}
			end,
		})
		})

		require("mason-conform").setup()
	end,
}
