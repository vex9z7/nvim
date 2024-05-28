local actions = require("telescope.actions")
local ratio = 1.618

require("telescope").setup({
	defaults = {
		git_worktrees = require("astrocore").config.git_worktrees,
		layout_strategy = "flex",
		layout_config = {
			width = (ratio - 1),
			vertical = {
				preview_height = function(_, _, max_lines)
					return math.max(math.floor(max_lines * (ratio - 1)), 5)
				end,
			},
			preview_cutoff = 0,
		},
		mappings = {
			i = {
				["<C-J>"] = actions.move_selection_next,
				["<C-K>"] = actions.move_selection_previous,
			},
		},
		path_display = { "truncate" },
		sorting_strategy = "ascending",
	},
})
