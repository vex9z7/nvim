local function setup()
	require("hardtime")
	vim.opt.showmode = false
end

try(setup, vim.notify)
