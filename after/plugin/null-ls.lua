-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/MAIN.md
local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

function qmllintSourceFactory()
	local h = require("null-ls.helpers")
	local methods = require("null-ls.methods")

	local DIAGNOSTICS = methods.internal.DIAGNOSTICS

	return h.make_builtin({
		name = "qmllint",
		meta = {
			url = "https://doc-snapshots.qt.io/qt6-dev/qtquick-tools-and-utilities.html#qmllint",
			description = "qmllint is a tool shipped with Qt that verifies the syntatic validity of QML files. It also warns about some QML anti-patterns.",
		},
		method = DIAGNOSTICS,
		filetypes = { "qml" },
		generator_opts = {
			command = "qmllint",
			args = { "$FILENAME" },
			to_stdin = false,
			format = "line",
			from_stderr = true,
			to_temp_file = true,

			on_output = function(line, _params)
				local errorType, message, row, col = line:match("(%a+):%s(.-) at (%d+):(%d+)")
				if errorType then
					return {
						row = row,
						col = col,
						message = message,
						severity = 2,
					}
				end
			end,
		},
		factory = h.generator_factory,
	})
end

null_ls.setup({
	sources = {
		-- lua
		formatting.stylua,

		-- javascript, typescript, react, json
		formatting.prettierd.with({
			prefer_local = "node_modules/.bin",
		}),
		formatting.eslint_d,
		diagnostics.eslint_d,

		-- qml
		formatting.qmlformat,
		qmllintSourceFactory().with({
			extra_args = { "-U" },
			diagnostic_config = {
				-- see :help vim.diagnostic.config()
				underline = true,
				virtual_text = false,
				signs = false,
				update_in_insert = false,
				severity_sort = true,
			},
		}),

		-- English
		diagnostics.write_good.with({
			condition = function()
				return vim.fn.executable("write-good") > 0
			end,
			diagnostic_config = {
				-- see :help vim.diagnostic.config()
				underline = true,
				virtual_text = true,
				signs = false,
				update_in_insert = false,
				severity_sort = true,
			},
			diagnostics_postprocess = function(diagnostic)
				-- see :help diagnostic-severity
				diagnostic.severity = vim.diagnostic.severity.WARN
			end,
		}),
	},
	on_attach = function(client, bufnr)
		-- auto format
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
          print('asdadasd')
					vim.lsp.buf.format({
						async = false,
						filter = function(c)
							return c.name == "null-ls"
						end,
					})
				end,
			})
		end
	end,
})
