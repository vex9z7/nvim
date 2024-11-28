-- TODO: Integrate annotation into none-ls
-- see https://github.com/nvimtools/none-ls.nvim/blob/main/doc/MAIN.md
return {
    "danymat/neogen",
    config = function()
        require("neogen").setup({ snippet_engine = "luasnip" })
        vim.keymap.set(
            { "n" },
            "<leader><leader>d",
            require("neogen").generate,
            { desc = "generate annotations for the current function." }
        )
    end,
    -- Uncomment next line if you want to follow only stable versions
    version = "*",
}
