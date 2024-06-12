local function setup()
	local cspell = require("cspell")
	local null_ls = require("null-ls")

	local CSPELL_FALLBACK_CONFIG_PATH = vim.fn.expand("~/.config/nvim/null-ls-config-fallbacks/cspell.json")

	local condition = function()
		return vim.fn.executable("cspell") > 0
	end

	local config = {
		find_json = function(cwd)
			return CSPELL_FALLBACK_CONFIG_PATH
		end,
	}

	null_ls.register(cspell.diagnostics.with({
		condition = condition,
		extra_filetypes = {},
		diagnostic_config = {
			-- see :help vim.diagnostic.config()
			underline = true,
			virtual_text = false,
			signs = false,
			update_in_insert = false,
			severity_sort = true,
		},
		diagnostics_postprocess = function(diagnostic)
			-- see :help diagnostic-severity
			diagnostic.severity = vim.diagnostic.severity.INFO
		end,
		config = config,
	}))

	null_ls.register(cspell.code_actions.with({
		condition = condition,
		extra_filetypes = {},
		config = config,
	}))
end

try(setup, print)
