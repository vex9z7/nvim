local vaultRoot = "~/Documents/the-vault/"
return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	-- only load obsidian.nvim for markdown files in your vault:
	event = {
		-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"

		"BufReadPre "
			.. vaultRoot
			.. "**.md",
		"BufNewFile " .. vaultRoot .. "**.md",
	},
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",

		-- see below for full list of optional dependencies 👇
		"hrsh7th/nvim-cmp",
		"nvim-telescope/telescope.nvim",
		"nvim-treesitter",
	},
	opts = {
		workspaces = {
			{
				name = "hugo",
				path = "~/Documents/the-vault/hugo",
			},
			{
				name = "mujin",
				path = "~/Documents/the-vault/mujin",
			},
			{
				name = "overall",
				path = "~/Documents/the-vault",
			},
		},

		-- see below for full list of options 👇
	},
}
