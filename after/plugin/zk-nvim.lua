local commands = require("zk.commands")
local zk = require("zk")
local zkApi = require("zk.api")

--- see at https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#position
--- Line position in a document (zero-based).
---	Character offset on a line in a document (zero-based). The meaning of this offset is determined by the negotiated `PositionEncodingKind`. If the character value is greater than the line length it defaults back to the line length.
---
---@alias LspPosition { line: integer, character:integer }
---@alias LspLocation { uri: string, range: { end: LspPosition, start: LspPosition }}

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

local function extratLinesToNote()
    if vim.fn.mode() ~= "V" then
        return
    end
    -- TODO: decouple the config related things from functionalities and keep them in sync with the config
    local noteTypes = {
        "zettel",
        "project",
        "area",
    }

    ---@type {[string]:string}
    local notePathes = {
        ["zettel"] = "zettel",
        ["area"] = "areas",
        ["project"] = "projects",
    }

    ---comment
    ---@return integer[]
    ---@return integer[]
    local function getVisualPositions()
        local cursorPosition = vim.fn.getpos(".")
        local visualPosition = vim.fn.getpos("v")
        for i = 2, 3 do
            if cursorPosition[i] ~= visualPosition[i] then
                if cursorPosition[i] > visualPosition[i] then
                    return visualPosition, cursorPosition
                else
                    break
                end
            end
        end
        return cursorPosition, visualPosition
    end

    local visualStartPosition, visualEndPosition = getVisualPositions()

    -- get selectedContent
    local lines = vim.fn.getregion(
        visualStartPosition,
        visualEndPosition,
        { type = vim.fn.mode() }
    )
    local selectedContent = table.concat(lines, "\n")

    local location = vim.lsp.util.make_given_range_params(
        { visualStartPosition[2], 0 },
        { visualEndPosition[2], #vim.fn.getline(visualEndPosition[2]) },
        0
    )
    location.uri = location.textDocument.uri

    vim.ui.select(noteTypes, {
        prompt = "Extract to template",
    }, function(noteType)
        if noteType ~= nil then
            local function createNote(title)
                ---@type {title:string?,content:string?,dir:string?,group:string?,template:string?,extra:table?,date:string?,edit:boolean?,dryRun:boolean?,insertLinkAtLocation:LspLocation?,insertContentAtLocation:table?}
                local options = {
                    dir = notePathes[noteType],
                    group = noteType,
                    title = title,
                    edit = false,
                    content = selectedContent,
                    insertLinkAtLocation = location,
                }

                zkApi.new(nil, options, function(err)
                    assert(not err, tostring(err))
                end)
            end

            inputTitle(createNote)
        end
    end)
end

local function setup()
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

    -- show backlinks
    vim.keymap.set({ "n" }, "<leader>zb", function()
        local currentBufferName = vim.fn.bufname("%")
        zk.edit({ linkTo = { currentBufferName }, sort = defaultSortOption })
    end, { noremap = true, desc = "backlinks" })

    -- insert link using picker
    vim.keymap.set({ "n" }, "<leader>zil", function()
        local insertLinkFn = commands.get("ZkInsertLink")
        insertLinkFn({ sort = defaultSortOption })
    end, { noremap = true, desc = "insert link" })

    -- extrat lines to note
    vim.keymap.set(
        { "v" },
        "<leader>ze",
        extratLinesToNote,
        { noremap = true, desc = "Extract the selected lines into note" }
    )

    vim.keymap.set({ "n", "o", "x" }, "<leader>zT", function()
        vim.print("zk test")
    end, { noremap = true, desc = "zk test key mapping" })
end

try(setup, vim.notify)
