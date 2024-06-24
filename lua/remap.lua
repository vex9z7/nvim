vim.g.mapleader = " "

vim.keymap.set({ "n", "x", }, "<Space>", "<Nop>", { silent = true })
-- to enable hop.nvim in operand and visial mode
vim.keymap.set({ "o", }, "<Space>", "<leader>", { silent = true })
-- turn off highlights
vim.keymap.set('n', '<esc><esc>', '<cmd>noh<CR>', {noremap = true})

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, {desc="hahaha"})
