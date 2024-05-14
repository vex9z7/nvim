-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/MAIN.md
local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

local CSPELL_CONFIG_FALLBACK = vim.fn.expand('~/.config/nvim/null-ls-config-fallbacks/cspell.json')

null_ls.setup({
  sources = {
    formatting.prettierd.with({
      prefer_local = "node_modules/.bin",
    }),
    formatting.eslint_d,

    diagnostics.eslint_d,

    diagnostics.cspell.with({
      extra_args = { '--config', CSPELL_CONFIG_FALLBACK },
      condition = function()
        return vim.fn.executable('cspell') > 0
      end,
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
    }),

    code_actions.cspell.with({
      extra_args = { '--config', CSPELL_CONFIG_FALLBACK },
      condition = function()
        return vim.fn.executable('cspell') > 0
      end,
    }),
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
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
