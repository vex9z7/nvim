local models = {
    "qwen2.5-coder:0.5b",
    "qwen2.5-coder:1.5b",
    "codegemma:2b",
    "qwen2.5-coder:3b",
}
local model = models[2]

return {
    "yuys13/collama.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    enabled = false,
    config = function()
        ---@type CollamaConfig
        local config = {
            base_url = "http://localhost:11434/api/",
            model = model,
        }

        local augroup =
            vim.api.nvim_create_augroup("my_collama_augroup", { clear = true })

        -- auto execute debounced_request
        vim.api.nvim_create_autocmd(
            { "InsertEnter", "CursorMovedI", "TextChangedI" },
            {
                group = augroup,
                callback = function()
                    require("collama.copilot").debounced_request(config, 3000)
                end,
            }
        )
        -- auto cancel
        vim.api.nvim_create_autocmd({ "InsertLeave", "VimLeavePre" }, {
            group = augroup,
            callback = function()
                require("collama.copilot").clear()
            end,
        })

        -- accept keymap
        vim.keymap.set("i", "<Cr>", function()
            local result = require("collama.copilot.state").get_result()
            if result then
                require("collama.copilot").accept()
            else
                vim.api.nvim_feedkeys("\n", "n", false)
            end
        end, { remap = true })
    end,
}
