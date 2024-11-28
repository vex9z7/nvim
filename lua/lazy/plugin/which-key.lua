return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    config = function()
        local groups = {
            ["<Leader><Leader>g"] = { name = "Git" },
            ["<Leader><Leader>b"] = { name = "Buffers" },
            ["<Leader><Leader>f"] = { name = "Find" },
            ["<Leader><Leader>l"] = { name = "Language Tools" },
            ["<Leader><Leader>p"] = { name = "Packages" },
            ["<Leader><Leader>t"] = { name = "Terminal" },
            ["<Leader><Leader>u"] = { name = "UI/UX" },
        }
        local wk = require("which-key")
        for key, group in pairs(groups) do
            wk.register({ [key] = group })
        end
    end,
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
}
