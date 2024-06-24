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

	null_ls.setup({
		sources = {
			-- javascript, typescript, react, json
			formatting.prettierd.with({
				prefer_local = "node_modules/.bin",
			}),
			-- see https://github.com/nvimtools/none-ls-extras.nvim/tree/main
			require("none-ls.diagnostics.eslint_d"),
			require("none-ls.formatting.eslint_d"),

      -- python
      formatting.black,
      -- see https://github.com/nvimtools/none-ls-extras.nvim/tree/main
      require("none-ls.diagnostics.flake8").with({
        extra_args = {
          "--ignore",
          "E121,E123,E126,E133,E2,E3,E501,E704,W2,W503,C901,E4,F841,W3,E115,E116,E722,F401,E12,E7,F405,X030,X031,X032,W605,E101,E111,E114,E117,E502,F402,F632,F811,F812,W191,W504,W601,H1,H3,H4,H5,H20,A003",
        },
      }),

			-- shell
			formatting.shfmt,
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
      attach_auto_formatter(client, bufnr, { name = "null-ls" });
		end,
	})
end

try(setup, vim.notify)
