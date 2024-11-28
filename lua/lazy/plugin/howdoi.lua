-- TODO: fork and remove it
return {
  'zane-/howdoi.nvim',
  dependencies = { "nvim-telescope/telescope.nvim", },
  config = function()
    require('telescope').load_extension('howdoi')
    require('telescope').setup({
      extensions = {
        howdoi = vim.tbl_deep_extend(
          'force',
          { num_answers = 3, command_executor = { 'bash', '-c' } },
          require('telescope.themes').get_dropdown())
      }
    })
    vim.keymap.set('n', '<leader>hdi', function()
      vim.cmd('Telescope howdoi')
    end)
  end
}

