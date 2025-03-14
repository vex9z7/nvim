vim.opt.guicursor = ""

vim.opt.number = true
vim.opt.relativenumber = true

-- Config line break and wrap

-- hard wrap
vim.opt.textwidth = 0

-- soft wrap
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.showbreak = " 󱞩 "

-- FIXME: setting columns doesn't fit to the theme color
-- vertical line, only serves as a visual aid
local buffer_columns = 80
vim.opt.colorcolumn = tostring(buffer_columns)
-- actually width including numberwidth
vim.opt.columns = buffer_columns + 4 + 1 + 2 -- TODO: figure out why need 2 extra columns

-- e.g. Auctor erat et ut, id ut faucibus in, consequat pretium pellentesque tempor. Nunc natoque dignissim pellentesque, ultrices rutrum convallis nunc, magna purus dapibus erat. Rhoncus ante diam est, leo suspendisse est nullam, lorem maecenas vulputate porttitor. Nulla vestibulum maecenas etiam, rhoncus semper tortor metus, elit odio nulla dictum. Est parturient dapibus nunc, vitae vitae lobortis dui, tristique tempor sapien nulla. Nullam arcu dis malesuada, diam nullam cursus gravida, risus consequat eu sed. In ac posuere mus, feugiat vulputate id magna, vitae molestie eget et. Eu laoreet sed ornare, eros viverra quisque et, dui ac sem nec. Dui, ac, nibh efficitur.

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false

-- search will be case sensitive if it contains an uppercase letter
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.smartindent = true
-- vim.opt.autoindent = true

-- always use the clipboard
vim.opt.clipboard:append("unnamedplus")

vim.opt.swapfile = false
vim.opt.backup = false

-- save undo trees in files
vim.opt.undodir = vim.env.HOME .. "/.config/nvim/undo"
vim.opt.undofile = true

-- number of undo saved
vim.opt.undolevels = 10000
vim.opt.undoreload = 10000

-- vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.inccommand = "nosplit"

vim.opt.termguicolors = true

-- FIXME: enter everything in insert mode or paste in normal mode, will scroll up automatically
-- vim.opt.scrolloff = 999
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- see at https://github.com/epwalsh/obsidian.nvim/issues/286#issuecomment-1877258732
vim.opt.conceallevel = 1

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "json",
    },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
    end,
})
