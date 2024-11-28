local function setup()
    local luasnip = require("luasnip")
    luasnip.filetype_extend("javascriptreact", { "html" })
    luasnip.filetype_extend("typescriptreact", { "javascriptreact" })
    require("luasnip.loaders.from_vscode").lazy_load()
end

try(setup, vim.notify)
