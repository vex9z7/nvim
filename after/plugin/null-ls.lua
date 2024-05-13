-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/MAIN.md
local null_ls = require("null-ls")

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
    sources = {
        -- TODO: use repo root config file
        formatting.prettierd,
        formatting.eslint_d,
        diagnostics.eslint_d,
        -- null_ls.builtins.completion.spell,
    },
})
