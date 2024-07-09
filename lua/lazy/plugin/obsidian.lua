-- TODO: walkthough the config documents
-- see https://github.com/epwalsh/obsidian.nvim?tab=readme-ov-file#configuration-options

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
  keys = {
    { "<leader>oo", "<cmd>ObsidianOpen<cr>",        desc = "Open Obsidian" },
    { "<leader>on", "<cmd>ObsidianNew<cr>",         desc = "Create a new Obsidian Document" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>",      desc = "Search Obsidian" },
    { "<leader>of", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian Find Files" },
    { "<leader>op", "<cmd>ObsidianPasteImg<cr>",    desc = "Obsidian Paste Image" },
    { "<leader>or", "<cmd>ObsidianRename<cr>",      desc = "Obsidian Rename current note" },
    { "<leader>ot", "<cmd>ObsidianTemplate<cr>",    desc = "Insert Obsidian Template into file" },
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
