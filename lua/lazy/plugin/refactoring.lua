return {
  "ThePrimeagen/refactoring.nvim",
  keys = {
    {
      "<leader><leader>lR",
      function()
        -- FIXME: don't deduce extract vs inline
        require("refactoring").select_refactor({})
      end,
      mode = { "n", "x" },
      desc = "Refactor",
    },
  },
  config = true,
  dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
}
