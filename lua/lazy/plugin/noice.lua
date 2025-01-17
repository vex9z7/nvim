-- https://github.com/folke/noice.nvim
return {
    "folke/noice.nvim",
    event = "VeryLazy",
    ---@module "noice"
    ---@type NoiceConfig
    opts = {
        -- add any options here
        notify = { enabled = false },
        lsp = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
            -- INFO: render-markdown messes up the override
            ["vim.lsp.util.stylize_markdown"] = false,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
        -- you can enable a preset for easier configuration
        presets = {
            bottom_search = false, -- use a classic bottom cmdline for search
            command_palette = false, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = true, -- add a border to hover docs and signature help
        },
    },
    dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
    },
}
