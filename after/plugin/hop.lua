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

end

try(setup, vim.notify)
