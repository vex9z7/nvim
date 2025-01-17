return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        -- Support toggling auto formating
        -- see https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#command-to-toggle-format-on-save
        {
            "<leader><leader>lf",
            function()
                local bufnr = vim.api.nvim_get_current_buf()
                if
                    vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat
                then
                    return
                end
                require("conform").format()
            end,
            mode = { "v", "n" },
            desc = "Format buffer",
        },
    },
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        -- Define your formatters
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
            graphql = { "prettierd" },
            xml = { "xmlformatter" },
        },
        formatters = {
            xmlformatter = {
                prepend_args = {
                    "--selfclose",
                    "--blanks",
                    "--indent",
                    "2",
                    "--preserve-attributes",
                },
            },
        },
        default_format_opts = { timeout_ms = 1500, lsp_format = "fallback" },
        -- Set up format-on-save
        format_on_save = function(bufnr)
            -- Disable with a global or buffer-local variable
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
            end
            return {
                -- BUG: report the issue that occurs after format and undojoin right after undo
                -- Vim:E790: undojoin is not allowed after undo
                -- undojoin = true,
            }
        end,
    },
}
