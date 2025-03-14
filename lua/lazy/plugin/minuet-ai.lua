local models = {
    "qwen2.5-coder:0.5b",
    "qwen2.5-coder:1.5b",
    "codegemma:2b",
    "qwen2.5-coder:3b",
}
local model = models[2]

return {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    enabled = false,
    config = function()
        require("minuet").setup({
            provider = "openai_fim_compatible",
            provider_options = {
                openai_fim_compatible = {
                    model = model,
                    end_point = "http://localhost:11434/api/generate",
                    api_key = "PATH",
                    name = model,
                    stream = true,
                    --
                    optional = {
                        max_tokens = 20,
                        stop = { "\n\n" },
                    },
                },
            },
        })
    end,
}
