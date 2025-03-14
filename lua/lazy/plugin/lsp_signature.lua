-- see https://github.com/ray-x/lsp_signature.nvim
return {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {
        hint_prefix = {
            above = "↙ ", -- when the hint is on the line above the current line
            current = "← ", -- when the hint is on the same line
            below = "↖ ", -- when the hint is on the line below the current line
        },
        -- transparency = 50,
    },
}
