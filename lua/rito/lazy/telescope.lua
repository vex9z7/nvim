return {
	"nvim-telescope/telescope.nvim",

	tag = "0.1.6",

	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			lazy = true,
			enabled = vim.fn.executable("make") == 1,
			build = "make",
		},
		"nvim-treesitter/nvim-treesitter",
		"rcarriga/nvim-notify",
		"stevearc/aerial.nvim",
	},

	config = function()
		require("telescope").setup({})

		local builtin = require("telescope.builtin")
		local maps = { n = {}, i = {}, t = {}, v = {} }

		local astro = require("astrocore")
		-- keymaps from astronvim
		if vim.fn.executable("git") == 1 then
			maps.n["<Leader>gb"] = {
				function()
					builtin.git_branches({ use_file_path = true })
				end,
				desc = "Git branches",
			}
			maps.n["<Leader>gc"] = {
				function()
					builtin.git_commits({ use_file_path = true })
				end,
				desc = "Git commits (repository)",
			}
			maps.n["<Leader>gC"] = {
				function()
					builtin.git_bcommits({ use_file_path = true })
				end,
				desc = "Git commits (current file)",
			}
			maps.n["<Leader>gt"] = {
				function()
					builtin.git_status({ use_file_path = true })
				end,
				desc = "Git status",
			}
		end
		maps.n["<Leader>f<CR>"] = {
			function()
				builtin.resume()
			end,
			desc = "Resume previous search",
		}
		maps.n["<Leader>f'"] = {
			function()
				builtin.marks()
			end,
			desc = "Find marks",
		}
		maps.n["<Leader>f/"] = {
			function()
				builtin.current_buffer_fuzzy_find()
			end,
			desc = "Find words in current buffer",
		}
		maps.n["<Leader>fb"] = {
			function()
				builtin.buffers()
			end,
			desc = "Find buffers",
		}
		maps.n["<Leader>fc"] = {
			function()
				builtin.grep_string()
			end,
			desc = "Find word under cursor",
		}
		maps.n["<Leader>fC"] = {
			function()
				builtin.commands()
			end,
			desc = "Find commands",
		}
		maps.n["<Leader>ff"] = {
			function()
				builtin.find_files()
			end,
			desc = "Find files",
		}
		maps.n["<Leader>fF"] = {
			function()
				builtin.find_files({ hidden = true, no_ignore = true })
			end,
			desc = "Find all files",
		}
		maps.n["<Leader>fh"] = {
			function()
				builtin.help_tags()
			end,
			desc = "Find help",
		}
		maps.n["<Leader>fk"] = {
			function()
				builtin.keymaps()
			end,
			desc = "Find keymaps",
		}
		maps.n["<Leader>fm"] = {
			function()
				builtin.man_pages()
			end,
			desc = "Find man",
		}
		maps.n["<Leader>fn"] = {
			function()
				require("telescope").extensions.notify.notify()
			end,
			desc = "Find notifications",
		}
		maps.n["<Leader>fo"] = {
			function()
				builtin.oldfiles()
			end,
			desc = "Find history",
		}
		maps.n["<Leader>fr"] = {
			function()
				builtin.registers()
			end,
			desc = "Find registers",
		}
		maps.n["<Leader>ft"] = {
			function()
				builtin.colorscheme({ enable_preview = true })
			end,
			desc = "Find themes",
		}
		if vim.fn.executable("rg") == 1 then
			maps.n["<Leader>fw"] = {
				function()
					builtin.live_grep()
				end,
				desc = "Find words",
			}
			maps.n["<Leader>fW"] = {
				function()
					builtin.live_grep({
						additional_args = function(args)
							return vim.list_extend(args, { "--hidden", "--no-ignore" })
						end,
					})
				end,
				desc = "Find words in all files",
			}
		end
		maps.n["<Leader>ls"] = {
			function()
				require("telescope").extensions.aerial.aerial()
				builtin.lsp_document_symbols()
			end,
			desc = "Search symbols",
		}
		if vim.fn.has("nvim-0.10") == 1 then
			maps.n.gr = {
				function()
					builtin.lsp_references()
				end,
				desc = "Search references",
			}
		end
		-- keymaps from astronvim

		for mode, mode_maps in pairs(maps) do
			for astro_key, map in pairs(mode_maps) do
				local key = string.sub(astro_key, 1, #"<Leader>") == "<Leader>" and "<Leader>" .. astro_key or astro_key
				vim.keymap.set(mode, key, map[1], { desc = map.desc })
			end
		end
	end,
}
