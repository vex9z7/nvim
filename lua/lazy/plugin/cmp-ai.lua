local models = {
    "qwen2.5-coder:0.5b",
    "qwen2.5-coder:1.5b",
    "codegemma:2b",
    "qwen2.5-coder:3b",
}
local model = models[2]

return {
    "tzachar/cmp-ai",
    dependencies = "nvim-lua/plenary.nvim",
    enabled = false,
    config = function()
        local cmp_ai = require("cmp_ai.config")
        cmp_ai:setup({
            max_lines = 5,
            provider = "Ollama",
            provider_options = {
                model = model,
                prompt = function(lines_before, lines_after)
                    return lines_before
                end,
                suffix = function(lines_after)
                    return lines_after
                end,
            },
            notify = true,
            notify_callback = function(msg)
                vim.notify(msg)
            end,
            run_on_every_keystroke = false,
        })
    end,
}
