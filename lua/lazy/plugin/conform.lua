return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				-- Conform will run multiple formatters sequentially
				lua = { "stylua" },
				python = { "autoflake", "ruff" },
				rust = { "rustfmt" },
				javascript = { "eslint_d", "prettierd" },
				javascriptreact = { "eslint_d", "prettierd" },
				typescript = { "eslint_d", "prettierd" },
				typescriptreact = { "eslint_d", "prettierd" },
				json = { "prettierd" },
				yaml = { "prettierd" },
				markdown = { "prettierd" },
			},
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		})
	end,
}
