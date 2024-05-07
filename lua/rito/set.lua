vim.opt.guicursor = ""

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
-- vim.opt.autoindent = true

-- awalys use the clipboard
vim.opt.clipboard:append("unnamedplus")

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false

-- save undo trees in files
vim.opt.undodir = vim.env.HOME .. "/.config/nvim/undo"
vim.opt.undofile = true

-- number of undo saved
vim.opt.undolevels=10000
vim.opt.undoreload=10000

-- vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.inccommand = "nosplit"

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"
