-- see https://github.com/brenoprata10/nvim-highlight-colors

vim.opt.termguicolors = true

local palette = try(function()
    return require("../../private/palette")
end, nil, {})

local example_palette = {
    ["@baby-blue"] = "#90ace3",
    ["@blue"] = "#1673ff",
    ["@blue-jeans"] = "#61afef",
}

palette = vim.tbl_extend("force", palette, example_palette)

return {
    "brenoprata10/nvim-highlight-colors",
    config = function()
        require("nvim-highlight-colors").setup({
            ---Render style
            ---@usage 'background'|'foreground'|'virtual'
            render = "virtual",

            ---Set virtual symbol (requires render to be set to 'virtual')
            ---alternatives
            virtual_symbol = "󱠦",

            ---Set virtual symbol suffix (defaults to '')
            virtual_symbol_prefix = "[",

            ---Set virtual symbol suffix (defaults to '')
            virtual_symbol_suffix = "]",

            ---Set virtual symbol position()
            ---@usage 'inline'|'eol'|'eow'
            ---inline mimics VS Code style
            ---eol stands for `end of column` - Recommended to set `virtual_symbol_suffix = ''` when used.
            ---eow stands for `end of word` - Recommended to set `virtual_symbol_prefix = ' ' and virtual_symbol_suffix = ''` when used.
            virtual_symbol_position = "eow",

            ---Highlight hex colors, e.g. '#803FFF'
            enable_hex = true,

            ---Highlight short hex colors e.g. '#3ff'
            enable_short_hex = true,

            ---Highlight rgb colors, e.g. 'rgb(255 0 0)'
            enable_rgb = true,

            ---Highlight hsl colors, e.g. 'hsl(150deg 30% 40%)'
            enable_hsl = true,

            ---Highlight CSS variables, e.g. 'var(--test-color)'
            enable_var_usage = true,

            ---Highlight named colors, e.g. ': green'
            enable_named_colors = false,

            ---Highlight tailwind colors, e.g. 'bg-blue-500'
            enable_tailwind = true,

            ---Set custom colors
            ---Label must be properly escaped with '%' to adhere to `string.gmatch`
            --- :help string.gmatch
            --- e.g. @blue; @blue-jeans; @baby-blue;
            custom_colors = (function()
                local formatted_colors = {}
                for name, data in pairs(palette) do
                    local formatted_color = {
                        label = name:gsub("%-", "%%-"),
                        color = data,
                    }
                    table.insert(formatted_colors, formatted_color)
                end
                return formatted_colors
            end)(),

            -- Exclude filetypes or buftypes from highlighting e.g. 'exclude_buftypes = {'text'}'
            exclude_filetypes = {},
            exclude_buftypes = {},
        })
    end,
}
