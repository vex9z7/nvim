-- use this simple plugin until inlay configs are merged into lsp-config
return {
    "MysticalDevil/inlay-hints.nvim",
    event = "LspAttach",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
        -- require("inlay-hints").setup()
    end,
}
