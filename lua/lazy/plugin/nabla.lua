return {
    "jbyuki/nabla.nvim",
    dependencies = {
        "williamboman/mason.nvim",
    },
    lazy = true,
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "latex" },
            auto_install = true,
            sync_install = false,
        })
    end,
    -- opts = {},
    keys = {
        {
            "<leader>p",
            ':lua require("nabla").popup()<cr>',
            desc = "NablaPopUp",
        },
    },
}
