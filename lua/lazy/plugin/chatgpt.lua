return {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    enabled = false,
    config = function()
        local tokenFilePath = vim.fn.expand("~/.config/openai.token")
        local content = vim.fn.readfile(tokenFilePath)
        local token = content[1]
        vim.fn.setenv("OPENAI_API_KEY", token)
        require("chatgpt").setup({})
    end,
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "folke/trouble.nvim",
        "nvim-telescope/telescope.nvim",
    },
}
