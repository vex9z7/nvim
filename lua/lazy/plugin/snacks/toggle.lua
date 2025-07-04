Snacks = require("snacks")

Snacks.toggle.diagnostics():map("<leader>td")
Snacks.toggle
    .option("conceallevel", {
        off = 0,
        on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
    })
    :map("<leader>tc")
Snacks.toggle.treesitter():map("<leader>tT")
Snacks.toggle
    .option("background", { off = "light", on = "dark", name = "Dark Background" })
    :map("<leader>tB")
Snacks.toggle.inlay_hints():map("<leader>th")

Snacks.indent.enable()
Snacks.toggle.indent():map("<leader>tg")

Snacks.dim.enable()
Snacks.toggle.dim():map("<leader>tD")

Snacks.words.enable()
Snacks.toggle.words():map("<leader>tw")

-- Snacks.toggle.zen():map("<leader>tz")

-- local snacks_input_opts = {
--     id = "snacks_input",
--     name = "Snacks input",
--     get = function()
--         return vim.ui.input == Snacks.input.input
--     end,
--     set = function(state)
--         if state then
--             Snacks.input.enable()
--         else
--             Snacks.input.disable()
--         end
--     end,
-- }
-- Snacks.toggle.new(snacks_input_opts):map("<leader>ti")

local conform_global_autoformating_opts = {
    id = "conform_global_autoformatting",
    name = "Conform autoformatting (global)",
    get = function()
        return not vim.g.disable_autoformat
    end,
    set = function(state)
        vim.g.disable_autoformat = not state
    end,
}

local conform_local_autoformating_opts = {
    id = "conform_global_autoformatting",
    name = "Conform autoformatting (local)",
    get = function()
        return not vim.b.disable_autoformat
    end,
    set = function(state)
        vim.b.disable_autoformat = not state
    end,
}

local gitsigns_line_blame = {
    id = "gitsigns_line_blameline",
    name = "Gitsigns line blame",
    get = function()
        local config = require("gitsigns.config").config
        return config.current_line_blame
    end,
    set = function()
        local actions = require("gitsigns.actions")
        actions.toggle_current_line_blame()
    end,
}

local mini_diff_toggle_overlay = {
    id = "mini_diff_toggle_overlay",
    name = "Mini.diff toggle overlay",
    get = function()
        local bufnr = vim.api.nvim_get_current_buf()
        if vim.bo.buftype == "" and vim.api.nvim_buf_is_loaded(bufnr) then
            return require("mini.diff").get_buf_data(bufnr).overlay
        end
        return false
    end,
    set = function()
        local bufnr = vim.api.nvim_get_current_buf()
        if vim.bo.buftype == "" and vim.api.nvim_buf_is_loaded(bufnr) then
            require("mini.diff").toggle_overlay(bufnr)
        end
    end,
}

Snacks.toggle.new(conform_global_autoformating_opts):map("<leader>tF")
Snacks.toggle.new(conform_local_autoformating_opts):map("<leader>tf")

Snacks.toggle.new(gitsigns_line_blame):map("<leader>tb")

Snacks.toggle.new(mini_diff_toggle_overlay):map("<leader>to")
