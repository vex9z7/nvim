local function setup()
	local zk = require("zk")
	local commands = require("zk.commands")
	local defaultSortOption = { "modified-", "created-" }

	local function selectFromTemplates(onConfirm)
		local templateChoices = { "zettel", "area", "project" }
		vim.ui.select(templateChoices, {
			prompt = "Select a template",
		}, function(choice)
			if choice ~= nil then
				return onConfirm(choice)
			end
		end)
	end

	local function inputTitle(onConfirm)
		vim.ui.input({ prompt = "title" }, function(input)
			if input ~= nil then
				return onConfirm(input)
			end
		end)
	end

	-- listing notes
	vim.keymap.set({ "n" }, "<leader>zd", function()
		local dailyTagUnion = table.concat({ "daily", "daily-notes" }, "|")
		zk.edit({ tags = { dailyTagUnion }, sort = { "created-" } })
	end, { noremap = true, desc = "daily notes" })

	vim.keymap.set({ "n" }, "<leader>zn", function()
		zk.edit({ tags = { "zettel" }, sort = defaultSortOption })
	end, { noremap = true, desc = "notes" })

	vim.keymap.set({ "n" }, "<leader>zp", function()
		zk.edit({ tags = { "project" }, sort = defaultSortOption })
	end, { noremap = true, desc = "projects" })

	vim.keymap.set({ "n" }, "<leader>za", function()
		zk.edit({ tags = { "area" }, sort = defaultSortOption })
	end, { noremap = true, desc = "areas" })

	vim.keymap.set({ "n" }, "<leader>zt", function()
		zk.pick_tags({ sort = { "note-count-" } }, {}, function(selectedItems)
			local selectedTags = {}
			for _, item in ipairs(selectedItems) do
				table.insert(selectedTags, item.name)
			end

			zk.edit({ tags = selectedTags, sort = defaultSortOption })
		end)
	end, { noremap = true, desc = "tags" })

	vim.keymap.set({ "n" }, "<leader>zb", function()
		local currentBufferName = vim.fn.bufname("%")

		zk.edit({ linkTo = { currentBufferName }, sort = defaultSortOption })
	end, { noremap = true, desc = "backlinks" })

	vim.keymap.set({ "n" }, "<leader>zil", function()
		local insertLinkFn = commands.get("ZkInsertLink")
		insertLinkFn({ sort = defaultSortOption })
	end, { noremap = true, desc = "insert link" })

	vim.keymap.set({ "o", "x" }, "<leader>ze", function()
		-- FIXME: lsp range selection error
		-- use more primitive api instead
		-- FIXME: use correct filepath
		selectFromTemplates(function(template)
			return inputTitle(function(title)
				local newFromContentSelection = commands.get("ZkNewFromContentSelection")
				newFromContentSelection({ title = title, group = template, edit = false })
			end)
		end)
	end, { noremap = true, desc = "Extract into note" })

	vim.keymap.set({ "n", "o", "x" }, "<leader>zT", function()
		vim.print("zk test")
	end, { noremap = true, desc = "zk test key mapping" })
end

try(setup, vim.notify)
