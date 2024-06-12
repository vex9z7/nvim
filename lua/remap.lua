vim.keymap.set('n', '<Space>', '<Nop>', {silent = true})
vim.g.mapleader = " "

-- turn off highlights
vim.keymap.set('n', '<esc><esc>', '<cmd>noh<CR>', {noremap = true})

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, {desc="hahaha"})
