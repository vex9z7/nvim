return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
        -- your configuration comes here
        dim = require("lazy.plugin.snacks.dim"),
        bigfile = require("lazy.plugin.snacks.bigfile"),
        indent = require("lazy.plugin.snacks.indent"),
        input = require("lazy.plugin.snacks.input"),
        notifier = require("lazy.plugin.snacks.notifier"),
        scroll = require("lazy.plugin.snacks.scroll"),
        words = require("lazy.plugin.snacks.words"),
        scope = require("lazy.plugin.snacks.scope"),
        statuscolumn = require("lazy.plugin.snacks.statuscolumn"),
        -- picker = require("lazy.plugin.snacks.picker"),
        -- gitbrowse = { enabled = true },
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Setup some globals for debugging (lazy-loaded)
                _G.dd = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.bt = function()
                    Snacks.debug.backtrace()
                end
                vim.print = _G.dd -- Override print to use snacks for `:=` command

                require("lazy.plugin.snacks.toggle")
            end,
        })
    end,
}
