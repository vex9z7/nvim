return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        file_types = { "markdown", "telekasten" },
        heading = {
            position = "overlay",
            width = "block",
            left_pad = 1,
        },
        code = {
            -- style = 'language',
            width = "block",
            disable_background = { "diff" },
            -- Highlight for code blocks
            highlight = "",
            -- Highlight for inline code
            highlight_inline = "NormalFloat",
            above = "─",
            below = "─",
            left_margin = 2,
        },
        checkbox = {
            -- position = 'overlay',

            checked = {
                icon = "✔",
                scope_highlight = "@markup.checked",
            },
            custom = {
                todo = {
                    raw = "[>]",
                    rendered = "󰥔",
                    highlight = "RenderMarkdownTodo",
                },
                question = {
                    raw = "[?]",
                    rendered = "",
                    highlight = "RenderMarkdownTodo",
                },
                important = {
                    raw = "[!]",
                    rendered = "",
                    highlight = "RenderMarkdownTodo",
                },
                canceled = {
                    raw = "[-]",
                    rendered = "✘",
                    highlight = "RenderMarkdownTodo",
                    scope_highlight = "@markup.strikethrough",
                },
                paused = {
                    raw = "[=]",
                    rendered = "󰏥",
                    highlight = "RenderMarkdownTodo",
                },
            },
        },
    },
}
