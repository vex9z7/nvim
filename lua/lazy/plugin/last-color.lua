return {
	"raddari/last-color.nvim",
	config = function()
		-- default theme as a backup, `recall()` can return `nil`.
		local theme = require("last-color").recall() or "default"
		vim.cmd.colorscheme(theme)
	end,
}
