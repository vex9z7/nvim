local vaultRoot = vim.fn.expand('~/Documents/the-vault/')

return {
  'renerocksai/telekasten.nvim',
  dependencies = { "renerocksai/calendar-vim", 'nvim-telescope/telescope.nvim' },

  config = function()
    require('telekasten').setup({
      home = vim.fs.joinpath(vaultRoot, 'zettel'),
      dailies = vim.fs.joinpath(vaultRoot, 'daily'),
      templates = vim.fs.joinpath(vaultRoot, 'templates'),
      template_new_daily = vim.fs.joinpath(vaultRoot, 'templates/telekasten.daily.template.md'),
      template_new_note = vim.fs.joinpath(vaultRoot, 'templates/telekasten.zettel.md'),
      image_subdir = "assets",
      auto_set_filetype = false,
      journal_auto_open = true,
      sort = 'modified',
      command_palette_theme = "dropdown",
    })
  end,

  keys = { { '<leader><leader>z', function() require('telekasten').panel() end, desc = 'telekasten panel' } }
}
