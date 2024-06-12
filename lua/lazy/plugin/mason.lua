return {
	"williamboman/mason.nvim",
	cmd = {
		"Mason",
		"MasonInstall",
		"MasonUninstall",
		"MasonUninstallAll",
		"MasonLog",
	},
	dependencies = {
		"AstroNvim/astrocore",
	},
	config = function()
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})
		local maps = { n = {}, i = {}, t = {}, v = {} }

		maps.n["<Leader>pm"] = {
			function()
				require("mason.ui").open()
			end,
			desc = "Mason Installer",
		}
		maps.n["<Leader>pM"] = {
			function()
				require("astrocore.mason").update_all()
			end,
			desc = "Mason Update",
		}
		-- opts.commands.AstroMasonUpdate = {
		--     function(options) require("astrocore.mason").update(options.fargs) end,
		--     nargs = "*",
		--     desc = "Update Mason Package",
		--     complete = function(arg_lead)
		--         local _ = require "mason-core.functional"
		--         return _.sort_by(
		--             _.identity,
		--             _.filter(_.starts_with(arg_lead), require("mason-registry").get_installed_package_names())
		--         )
		--     end,
		-- }
		-- opts.commands.AstroMasonUpdateAll =
		-- { function() require("astrocore.mason").update_all() end, desc = "Update Mason Packages" }

		for mode, mode_maps in pairs(maps) do
			for astro_key, map in pairs(mode_maps) do
				local key = string.sub(astro_key, 1, #"<Leader>") == "<Leader>" and "<Leader>" .. astro_key or astro_key
				vim.keymap.set(mode, key, map[1], { desc = map.desc })
			end
		end
	end,
	opts = function()
		return {
			ui = {
				icons = {
					package_installed = "✓",
					package_uninstalled = "✗",
					package_pending = "⟳",
				},
			},
		}
	end,
	build = ":MasonUpdate",
}
