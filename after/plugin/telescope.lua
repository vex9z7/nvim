local function setup()
    local actions = require("telescope.actions")
    local ratio = 1.618

    require("telescope").setup({
        pickers = {
            colorscheme = {
                enable_preview = true,
            },
        },
        defaults = {
            -- TODO: investigate
            -- git_worktrees = require("astrocore").config.git_worktrees,

            -- https://github.com/nvim-telescope/telescope.nvim/pull/1735
            wrap_results = true,
            layout_strategy = "flex",
            layout_config = {
                width = (ratio - 1),
                vertical = {
                    preview_height = function(_, _, max_lines)
                        return math.max(math.floor(max_lines * (ratio - 1)), 5)
                    end,
                },
                preview_cutoff = 0,
            },
            mappings = {
                i = {
                    ["<C-J>"] = actions.move_selection_next,
                    ["<C-K>"] = actions.move_selection_previous,
                },
            },
            path_display = { "truncate" },
        },
    })

    -- wrap line
    -- https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#previewers
    vim.api.nvim_create_autocmd("User", {
        pattern = "TelescopePreviewerLoaded",
        callback = function(args)
            vim.wo.number = true
            vim.wo.wrap = true
        end,
    })
end

try(setup, vim.notify)
