return {
    -- "hrsh7th/nvim-cmp",
    -- waiting for this MR get merged https://github.com/hrsh7th/nvim-cmp/pull/1955
    "xzbdmw/nvim-cmp",
    branch = "dynamic",
    dependencies = {
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
        "onsails/lspkind.nvim",
        "buschco/nvim-cmp-ts-tag-close",
        -- 'windwp/nvim-autopairs',

        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "vex9z7/cmp-tw2css",

        "hrsh7th/cmp-buffer",
        "f3fora/cmp-spell",
        "uga-rosa/cmp-dictionary",
        "nat-418/cmp-color-names.nvim",

        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "dmitmel/cmp-cmdline-history",
    },
}
