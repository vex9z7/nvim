local function setup()
  local hop = require("hop")
  local directions = require("hop.hint").HintDirection
  local hint_positions = require("hop.hint").HintPosition

  vim.keymap.set({ "n", "o", "x" }, "<leader>e", function()
    hop.hint_camel_case({
      direction = directions.AFTER_CURSOR,
      hint_position = hint_positions.END,
    })
  end, { noremap = true, desc = "hop forward to end of word" })

  vim.keymap.set({ "n", "o", "x" }, "<leader>ge", function()
    hop.hint_camel_case({
      direction = directions.BEFORE_CURSOR,
      hint_position = hint_positions.END,
    })
  end, { noremap = true, desc = "hop backward to end of word" })

  vim.keymap.set({ "n", "o", "x" }, "<leader>w", function()
    hop.hint_camel_case({
      direction = directions.AFTER_CURSOR,
      hint_position = hint_positions.BEGIN,
    })
  end, { noremap = true, desc = "hop forward to word" })

  vim.keymap.set({ "n", "o", "x" }, "<leader>b", function()
    hop.hint_camel_case({
      direction = directions.BEFORE_CURSOR,
      hint_position = hint_positions.BEGIN,
    })
  end, { noremap = true, desc = "hop backward to word" })

  vim.keymap.set({ "n", "o", "x" }, "<leader>k", function()
    hop.hint_vertical({ direction = directions.BEFORE_CURSOR, })
  end, { noremap = true, desc = "hop up" })

  vim.keymap.set({ "n", "o", "x" }, "<leader>j", function()
    hop.hint_vertical({ direction = directions.AFTER_CURSOR, })
  end, { noremap = true, desc = "hop down" })

  vim.keymap.set({ "n", "o", "x" }, "<leader>s", function()
    hop.hint_patterns({
      multi_windows = true,
    }, "[^0-9A-Za-z \t]")
  end, { noremap = true, desc = "hop to non alphanumeric symbol" })
end

-- TODO: fix the issue that the direction does not work with multi_windows
-- TODO: allow the tags to use capital letters to reduce the visual noise when
-- the tags are too dense
try(setup, vim.notify)
