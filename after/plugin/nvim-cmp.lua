local function setup_cmp_theme()
    -- gray
    vim.api.nvim_set_hl(
        0,
        "CmpItemAbbrDeprecated",
        { bg = "NONE", strikethrough = true, fg = "#808080" }
    )
    -- blue
    vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { bg = "NONE", fg = "#569CD6" })
    vim.api.nvim_set_hl(
        0,
        "CmpItemAbbrMatchFuzzy",
        { link = "CmpIntemAbbrMatch" }
    )
    -- light blue
    vim.api.nvim_set_hl(
        0,
        "CmpItemKindVariable",
        { bg = "NONE", fg = "#9CDCFE" }
    )
    vim.api.nvim_set_hl(
        0,
        "CmpItemKindInterface",
        { link = "CmpItemKindVariable" }
    )
    vim.api.nvim_set_hl(0, "CmpItemKindText", { link = "CmpItemKindVariable" })
    -- pink
    vim.api.nvim_set_hl(
        0,
        "CmpItemKindFunction",
        { bg = "NONE", fg = "#C586C0" }
    )
    vim.api.nvim_set_hl(
        0,
        "CmpItemKindMethod",
        { link = "CmpItemKindFunction" }
    )
    -- front
    vim.api.nvim_set_hl(
        0,
        "CmpItemKindKeyword",
        { bg = "NONE", fg = "#D4D4D4" }
    )
    vim.api.nvim_set_hl(
        0,
        "CmpItemKindProperty",
        { link = "CmpItemKindKeyword" }
    )
    vim.api.nvim_set_hl(0, "CmpItemKindUnit", { link = "CmpItemKindKeyword" })
end

local function setup()
    vim.opt.completeopt = "menu,menuone,noinsert"

    local completion_width = 15
    local completion_height = 10
    vim.opt.pumheight = completion_height

    local dictionary_source = {
        name = "dictionary",
        keyword_length = 2,
        max_item_count = 5,
    }

    setup_cmp_theme()

    local cmp = require("cmp")
    local lspkind = require("lspkind")

    cmp.setup({
        experimental = { ghost_text = true },
        completion = { completeopt = "menu,menuone,noinsert" },
        preselect = cmp.PreselectMode.Item,
        formatting = {
            expandable_indicator = true,
            fields = { "kind", "abbr", "menu" },
            format = lspkind.cmp_format({
                mode = "symbol",
                -- show only symbol annotations
                maxwidth = completion_width,
                -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                -- can also be a function to dynamically calculate max width such as
                -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
                ellipsis_char = "...",
                -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                show_labelDetails = true,
                -- show labelDetails in menu. Disabled by default
                before = function(entry, vim_item)
                    if not vim_item then
                        return vim_item
                    end

                    local source_name = entry.source.name
                    if source_name == "nvim_lsp_signature_help" then
                        return vim_item
                    end

                    vim_item.menu = string.format(
                        "[%s/%s]",
                        string.sub(vim_item.kind, 0, 4),
                        source_name
                    )
                    return vim_item
                end,
            }),
        },

        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
            end,
        },

        window = {
            completion = vim.tbl_deep_extend("keep", {
                winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                col_offset = -3,
                side_padding = 0,
            }, cmp.config.window.bordered()),
            documentation = cmp.config.window.bordered(),
        },

        mapping = cmp.mapping.preset.insert({

            ["<Cr>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.confirm({
                        select = false,
                        behavior = cmp.ConfirmBehavior.Insert,
                    })
                else
                    fallback()
                end
            end, { "i" }),
            ["<C-y>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.confirm({
                        select = false,
                        behavior = cmp.ConfirmBehavior.Insert,
                    })
                else
                    fallback()
                end
            end, { "i" }),
            ["<esc>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.close()
                else
                    fallback()
                end
            end, { "i" }),

            ["<C-n>"] = function()
                if cmp.visible() then
                    cmp.select_next_item({
                        behavior = cmp.SelectBehavior.Select,
                        count = 1,
                    })
                else
                    cmp.complete()
                end
            end,
            ["<C-p>"] = function()
                if cmp.visible() then
                    cmp.select_prev_item({
                        behavior = cmp.SelectBehavior.Select,
                        count = 1,
                    })
                else
                    cmp.complete()
                end
            end,

            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
        }),

        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "nvim-cmp-ts-tag-close" },
            { name = "lazydev" }, -- optional completion source for require statements and module annotations
            { name = "cmp-tw2css" }, -- For luasnip users.
            { name = "luasnip" }, -- For luasnip users.
            { name = "color_names" },
            { name = "npm", keyword_length = 3 }, -- For luasnip users.
            -- { name = "minuet", max_item_count = 3 }, -- For luasnip users.
            -- { name = "cmp_ai", max_item_count = 3 },
        }, {
            dictionary_source,
            {
                name = "buffer",
                option = {
                    get_bufnrs = function()
                        local buf = vim.api.nvim_get_current_buf()
                        local byte_size = vim.api.nvim_buf_get_offset(
                            buf,
                            vim.api.nvim_buf_line_count(buf)
                        )
                        if byte_size > 1024 * 1024 then -- 1 Megabyte max
                            return {}
                        end
                        return { buf }
                    end,
                },
                max_item_count = 10,
            },
        }),
    })

    -- `/` and `?` cmdline setup.
    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer" },
            dictionary_source,
        },
    })

    -- `:` cmdline setup.
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            {
                name = "cmdline_history",
                max_item_count = 3,
                priority_weight = 10,
            },
            {
                name = "cmdline",
                option = {
                    ignore_cmds = { "Man", "!" },
                },
            },
            { name = "path" },
        }, {}),
        -- matching = { disallow_symbol_nonprefix_matching = false }
    })
end

try(setup, vim.notify)
