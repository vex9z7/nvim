local function setup()
    local lorem = require("lorem")
    lorem.setup({
        sentenceLength = "mixed",
        comma_chance = 0.2,
        max_commas_per_sentence = 2,
    })

    vim.keymap.set(
        "n",
        "<leader><leader>L",
        "<CMD>LoremIpsum 1 paragraphs<CR>",
        { noremap = true }
    )
end

try(setup, vim.notify)
