---@module "snacks"
---@class snacks.scope.Config
return {
    enabled = true,
    -- absolute minimum size of the scope.
    -- can be less if the scope is a top-level single line scope
    min_size = 2,
    -- try to expand the scope to this size
    max_size = nil,
    cursor = true, -- when true, the column of the cursor is used to determine the scope
    edge = false, -- include the edge of the scope (typically the line above and below with smaller indent)
    siblings = false, -- expand single line scopes with single line siblings
    -- what buffers to attach to
    filter = function(buf)
        return vim.bo[buf].buftype == ""
    end,
    -- debounce scope detection in ms
    debounce = 50,
    treesitter = {
        -- detect scope based on treesitter.
        -- falls back to indent based detection if not available
        enabled = true,
        ---@type string[]|{enabled?:boolean}
        blocks = {
            enabled = true, -- enable to use the following blocks
            "function_declaration",
            "function_definition",
            "method_declaration",
            "method_definition",
            "class_declaration",
            "class_definition",
            "do_statement",
            "while_statement",
            "repeat_statement",
            "if_statement",
            "for_statement",
        },
        -- these treesitter fields will be considered as blocks
        field_blocks = {
            "local_declaration",
        },
    },
    -- These keymaps will only be set if the `scope` plugin is enabled.
    -- Alternatively, you can set them manually in your config,
    -- using the `Snacks.scope.textobject` and `Snacks.scope.jump` functions.
    keys = {
        ---@type table<string, snacks.scope.TextObject|{desc?:string}>
        textobject = {
            ii = {
                min_size = 2, -- minimum size of the scope
                edge = false, -- inner scope
                cursor = false,
                treesitter = { blocks = { enabled = false } },
                desc = "inner scope",
            },
            ai = {
                cursor = false,
                min_size = 2, -- minimum size of the scope
                treesitter = { blocks = { enabled = false } },
                desc = "full scope",
            },
        },
        ---@type table<string, snacks.scope.Jump|{desc?:string}>
        jump = {
            ["[i"] = {
                min_size = 1, -- allow single line scopes
                bottom = false,
                cursor = false,
                edge = true,
                treesitter = { blocks = { enabled = false } },
                desc = "jump to top edge of scope",
            },
            ["]i"] = {
                min_size = 1, -- allow single line scopes
                bottom = true,
                cursor = false,
                edge = true,
                treesitter = { blocks = { enabled = false } },
                desc = "jump to bottom edge of scope",
            },
        },
    },
}
