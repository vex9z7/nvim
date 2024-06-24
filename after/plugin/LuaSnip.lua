local function setup()
	require("luasnip.loaders.from_vscode").lazy_load()
end

try(setup, vim.notify)
