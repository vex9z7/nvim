-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/MAIN.md
local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
  sources = {
    formatting.prettierd.with({
      prefer_local = "node_modules/.bin",
    }),
    formatting.eslint_d,

    diagnostics.eslint_d,

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
