local commands = require("zk.commands")
local zk = require("zk")
local zkApi = require("zk.api")

local defaultSortOption = { "modified-", "created-" }

local function inputTitle(onConfirm)
    vim.ui.input({ prompt = "title" }, function(input)
        if input ~= nil then
            return onConfirm(input)
        end
    end)
end

local function searchByTags()
    return zk.pick_tags(
        { sort = { "note-count-" } },
        {},
        function(selectedItems)
            local selectedTags = {}
            for _, item in ipairs(selectedItems) do
                table.insert(selectedTags, item.name)
            end

            return zk.edit({
                tags = selectedTags,
                sort = defaultSortOption,
            })
        end
    )
end

local function findNote()
    local finderTypes = {
        "daily",
        "zettel",
        "project",
        "area",
        "tags",
        "all",
    }

    local finderOptions = {
        ["daily"] = {
            tags = { table.concat({ "daily", "daily-notes" }, "|") },
            sort = { "created-" },
        },
        ["zettel"] = { tags = { "zettel" } },
        ["area"] = { tags = { "area" } },
        ["project"] = { tags = { "project" } },
        ["all"] = {},
    }

    vim.ui.select(finderTypes, {
        prompt = "Find from the vault",
    }, function(finderType)
        if finderType ~= nil then
            if finderType == "tags" then
                return searchByTags()
            else
                local finderOption = finderOptions[finderType]
                if finderOption then
                    local opts = vim.tbl_extend(
                        "keep",
                        finderOption,
                        { sort = defaultSortOption }
                    )
                    return zk.edit(opts)
                end
            end
        end
    end)
end

local function newNote()
    -- TODO: decouple the config related things from functionalities and keep them in sync with the config
    local noteTypes = {
        "daily",
        "zettel",
        "project",
        "area",
    }

    ---@type {[string]:string}
    local notePathes = {
        ["daily"] = "daily",
        ["zettel"] = "zettel",
        ["area"] = "areas",
        ["project"] = "projects",
    }

    vim.ui.select(noteTypes, {
        prompt = "Create a new note",
    }, function(noteType)
        if noteType ~= nil then
            ---@type {title:string?,content:string?,dir:string?,group:string?,template:string?,extra:table?,date:string?,edit:boolean?,dryRun:boolean?,insertLinkAtLocation:table?,insertContentAtLocation:table?}
            local options = {
                dir = notePathes[noteType],
                group = noteType,
                edit = true,
            }

            local function createNote(title)
                if title then
                    options.title = title
                end
                zkApi.new(nil, options, function(err, stats)
                    vim.print({ err = err, stats = stats })
                end)
            end

            if noteType ~= "daily" then
                inputTitle(createNote)
            else
                createNote()
            end
        end
    end)
end

local function setup()
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

    -- find notes
    vim.keymap.set(
        { "n" },
        "<leader>fv",
        findNote,
        { noremap = true, desc = "Find from the vault" }
    )

    -- find notes
    vim.keymap.set(
        { "n" },
        "<leader>zf",
        findNote,
        { noremap = true, desc = "Find from the vault" }
    )

    -- new notes
    vim.keymap.set(
        { "n" },
        "<leader>zn",
        newNote,
        { noremap = true, desc = "Create a new note" }
    )

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
                local newFromContentSelection =
                    commands.get("ZkNewFromContentSelection")
                newFromContentSelection({
                    title = title,
                    group = template,
                    edit = false,
                })
            end)
        end)
    end, { noremap = true, desc = "Extract into note" })

    vim.keymap.set({ "n", "o", "x" }, "<leader>zT", function()
        vim.print("zk test")
    end, { noremap = true, desc = "zk test key mapping" })
end

try(setup, vim.notify)
