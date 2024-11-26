-- Playground
-- -- positions vim's `w` will move to
-- local myVariableName = FOO_BAR_BAZ
-- --    ^              ^ ^
--
-- -- positions spider's `w` will move to
-- local myVariableName = FOO_BAR_BAZ
-- --    ^ ^       ^    ^ ^   ^   ^
-- https://github.com/chrisgrieser/nvim-spider
-- FIXME: dw will delete the symbols at the end of words
-- [beginner guide](https://www.youtube.com/watch?v=AL88UNqiIn)
-- --            ^
return {
	"chrisgrieser/nvim-spider",
	lazy = true,
	init = function()
		vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
		vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
		vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
	end,
}
