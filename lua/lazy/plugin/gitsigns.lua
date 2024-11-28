return {
    "lewis6991/gitsigns.nvim",
    enabled = vim.fn.executable("git") == 1,
    config = function()
        require("gitsigns").setup({
            signs = {
                add = { text = "┃" },
                change = { text = "┃" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "┆" },
            },
            signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
            numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
            linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
            watch_gitdir = {
                follow_files = true,
            },
            auto_attach = true,
            attach_to_untracked = false,
            current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
                delay = 1000,
                ignore_whitespace = false,
                virt_text_priority = 100,
            },
            current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
            current_line_blame_formatter_opts = {
                relative_time = false,
            },
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil, -- Use default
            max_file_length = 40000, -- Disable if file is longer than this (in lines)
            preview_config = {
                -- Options passed to nvim_open_win
                border = "single",
                style = "minimal",
                relative = "cursor",
                row = 0,
                col = 1,
            },
            on_attach = function(bufnr)
                local maps = { n = {}, i = {}, t = {}, v = {} }
                -- keymaps from astronvim
                -- maps.n["<Leader>g"] = vim.tbl_get(opts, "_map_sections", "g")
                maps.n["]g"] = {
                    function()
                        require("gitsigns").next_hunk()
                    end,
                    desc = "Next Git hunk",
                }
                maps.n["[g"] = {
                    function()
                        require("gitsigns").prev_hunk()
                    end,
                    desc = "Previous Git hunk",
                }
                maps.n["<Leader>gl"] = {
                    function()
                        require("gitsigns").blame_line()
                    end,
                    desc = "View Git blame",
                }
                maps.n["<Leader>gL"] = {
                    function()
                        require("gitsigns").blame_line({ full = true })
                    end,
                    desc = "View full Git blame",
                }
                maps.n["<Leader>gp"] = {
                    function()
                        require("gitsigns").preview_hunk_inline()
                    end,
                    desc = "Preview Git hunk",
                }
                maps.n["<Leader>gh"] = {
                    function()
                        require("gitsigns").reset_hunk()
                    end,
                    desc = "Reset Git hunk",
                }
                maps.n["<Leader>gr"] = {
                    function()
                        require("gitsigns").reset_buffer()
                    end,
                    desc = "Reset Git buffer",
                }
                maps.n["<Leader>gs"] = {
                    function()
                        require("gitsigns").stage_hunk()
                    end,
                    desc = "Stage Git hunk",
                }
                maps.n["<Leader>gS"] = {
                    function()
                        require("gitsigns").stage_buffer()
                    end,
                    desc = "Stage Git buffer",
                }
                maps.n["<Leader>gu"] = {
                    function()
                        require("gitsigns").undo_stage_hunk()
                    end,
                    desc = "Unstage Git hunk",
                }
                maps.n["<Leader>gd"] = {
                    function()
                        require("gitsigns").diffthis()
                    end,
                    desc = "View Git diff",
                }
                -- keymaps from astronvim

                for mode, mode_maps in pairs(maps) do
                    for astro_key, map in pairs(mode_maps) do
                        local key = string.sub(astro_key, 1, #"<Leader>")
                                    == "<Leader>"
                                and "<Leader>" .. astro_key
                            or astro_key
                        vim.keymap.set(mode, key, map[1], { desc = map.desc })
                    end
                end

                -- Text object
                vim.keymap.set(
                    { "o", "x" },
                    "ih",
                    ":<C-U>Gitsigns select_hunk<CR>",
                    { desc = "git hunk", buffer = bufnr }
                )
            end,
        })
    end,
    -- opts = function()
    --     -- local get_icon = require("astroui").get_icon
    --     return {
    --         -- signs = {
    --         --   add = { text = get_icon "GitSign" },
    --         --   change = { text = get_icon "GitSign" },
    --         --   delete = { text = get_icon "GitSign" },
    --         --   topdelete = { text = get_icon "GitSign" },
    --         --   changedelete = { text = get_icon "GitSign" },
    --         --   untracked = { text = get_icon "GitSign" },
    --         -- },
    --         -- worktrees = require("astrocore").config.git_worktrees,
    --     }
    -- end,
}
