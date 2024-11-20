local CBFMT_CONFIG_PATH = vim.fn.expand("~/.config/nvim/null-ls-config-fallbacks/cbfmt.toml")

local function setup()
	-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/MAIN.md
	local null_ls = require("null-ls")

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

	function cbfmtSourecFactory()
		local h = require("null-ls.helpers")
		local methods = require("null-ls.methods")

		local FORMATTING = methods.internal.FORMATTING

		return h.make_builtin({
			name = "cbfmt",
			meta = {
				url = "https://github.com/lukas-reineke/cbfmt",
				description = "A tool to format codeblocks inside markdown and org documents.",
			},
			method = FORMATTING,
			filetypes = { "markdown", "org" },
			generator_opts = {
				command = "cbfmt",
				args = {
					"--stdin-filepath",
					"$FILENAME",
					"--best-effort",
					"--config",
					CBFMT_CONFIG_PATH,
				},
				to_stdin = true,
				condition = true,
			},
			factory = h.formatter_factory,
		})
	end

	null_ls.setup({
		sources = {
			-- see https://github.com/nvimtools/none-ls-extras.nvim/tree/main
			require("none-ls.diagnostics.eslint_d"),
			require("none-ls.code_actions.eslint_d"),

			-- shell
			formatting.shfmt,

			-- qml
			-- formatting.qmlformat,
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

			-- Markdown
			cbfmtSourecFactory(),
		},
	})
end

try(setup, vim.notify)
