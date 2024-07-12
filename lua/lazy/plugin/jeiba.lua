return {
  'noearc/jieba.nvim',
  dependencies = { 'noearc/jieba-lua' },
  config = function()
    vim.keymap.set({ 'x', 'n', 'o' }, 'B', '<cmd>lua require("jieba_nvim").wordmotion_B()<CR>',
      { noremap = false, silent = true })
    vim.keymap.set({ 'x', 'n', 'o' }, 'b', '<cmd>lua require("jieba_nvim").wordmotion_b()<CR>',
      { noremap = false, silent = true })
    vim.keymap.set({ 'x', 'n', 'o' }, 'w', '<cmd>lua require("jieba_nvim").wordmotion_w()<CR>',
      { noremap = false, silent = true })
    vim.keymap.set({ 'x', 'n', 'o' }, 'W', '<cmd>lua require("jieba_nvim").wordmotion_W()<CR>',
      { noremap = false, silent = true })
    vim.keymap.set({ 'x', 'n', 'o' }, 'E', '<cmd>lua require("jieba_nvim").wordmotion_E()<CR>',
      { noremap = false, silent = true })
    vim.keymap.set({ 'x', 'n', 'o' }, 'e', '<cmd>lua require("jieba_nvim").wordmotion_e()<CR>',
      { noremap = false, silent = true })
    vim.keymap.set({ 'x', 'n', 'o' }, 'ge', '<cmd>lua require("jieba_nvim").wordmotion_ge()<CR>',
      { noremap = false, silent = true })
    vim.keymap.set({ 'x', 'n', 'o' }, 'gE', '<cmd>lua require("jieba_nvim").wordmotion_gE()<CR>',
      { noremap = false, silent = true })
  end
}
