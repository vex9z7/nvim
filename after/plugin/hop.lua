local function setup()
	local hop = require("hop")
	local directions = require("hop.hint").HintDirection
	local hint_positions = require("hop.hint").HintPosition

	vim.keymap.set("n", "<leader>e", function()
		hop.hint_camel_case({
			direction = directions.AFTER_CURSOR,
			hint_position = hint_positions.END,
		})
	end, { desc = "hop forawrd to end of word" })

	vim.keymap.set("n", "<leader>ge", function()
		hop.hint_camel_case({
			direction = directions.BEFORE_CURSOR,
			hint_position = hint_positions.END,
		})
	end, { desc = "hop backward to end of word" })

	vim.keymap.set("n", "<leader>w", function()
		hop.hint_camel_case({
			direction = directions.AFTER_CURSOR,
			hint_position = hint_positions.BEGIN,
		})
	end, { desc = "hop forawrd to word" })

	vim.keymap.set("n", "<leader>b", function()
		hop.hint_camel_case({
			direction = directions.BEFORE_CURSOR,
			hint_position = hint_positions.BEGIN,
		})
	end, { desc = "hop backward to word" })

	vim.keymap.set("n", "<leader>k", function()
		hop.hint_vertical({ direction = directions.BEFORE_CURSOR })
	end, { desc = "hop up" })

	vim.keymap.set("n", "<leader>j", function()
		hop.hint_vertical({ direction = directions.AFTER_CURSOR })
	end, { desc = "hop down" })
end

try(setup, print)
