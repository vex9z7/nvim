return {
	"yuys13/collama.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	lazy = false,
	enabled = true,
	config = function()
		-- could you help me to split the following models into lines

		local models = { "qwen2.5-coder:0.5b", "qwen2.5-coder:1.5b", "codegemma:2b", "qwen2.5-coder:3b" }

		---@type CollamaConfig
		local config = {
			base_url = "http://localhost:11434/api/",
			model = models[2],
		}

		local augroup = vim.api.nvim_create_augroup("my_collama_augroup", { clear = true })

		-- auto execute debounced_request
		vim.api.nvim_create_autocmd({ "InsertEnter", "CursorMovedI", "TextChangedI" }, {
			group = augroup,
			callback = function()
				require("collama.copilot").debounced_request(config, 3000)
			end,
		})
		-- auto cancel
		vim.api.nvim_create_autocmd({ "InsertLeave", "VimLeavePre" }, {
			group = augroup,
			callback = function()
				require("collama.copilot").clear()
			end,
		})

		-- map accept key
		-- vim.keymap.set("i", "<Tab>", function(fallback)
		-- 	local state = require("collama.copilot.state")
		-- 	if state ~= nil then
		-- 		require("collama.copilot").accept()
		-- 	else
		-- 		fallback()
		-- 	end
		-- end, {})
		--
		-- vim.keymap.set("n", "<Cr>", require("collama.copilot").accept)
	end,
}
