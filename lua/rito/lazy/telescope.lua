return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.6",

    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            lazy = true,
            enabled = vim.fn.executable "make" == 1,
            build = "make",
        },
        "nvim-treesitter/nvim-treesitter",
        "AstroNvim/astrocore",
    },

    config = function()
        require('telescope').setup({})

        local builtin = require('telescope.builtin')
                local maps = { n={}, i={}, t={}, v={} }


          local astro = require "astrocore"
          local is_available = astro.is_available
        -- keymaps from astronvim
        if vim.fn.executable "git" == 1 then
            maps.n["<Leader>gb"] = {
                function() builtin.git_branches { use_file_path = true } end,
                desc = "Git branches",
            }
            maps.n["<Leader>gc"] = {
                function() builtin.git_commits { use_file_path = true } end,
                desc = "Git commits (repository)",
            }
            maps.n["<Leader>gC"] = {
                function() builtin.git_bcommits { use_file_path = true } end,
                desc = "Git commits (current file)",
            }
            maps.n["<Leader>gt"] =
            { function() builtin.git_status { use_file_path = true } end, desc = "Git status" }
        end
        maps.n["<Leader>f<CR>"] =
        { function() builtin.resume() end, desc = "Resume previous search" }
        maps.n["<Leader>f'"] = { function() builtin.marks() end, desc = "Find marks" }
        maps.n["<Leader>f/"] = {
            function() builtin.current_buffer_fuzzy_find() end,
            desc = "Find words in current buffer",
        }
        maps.n["<Leader>fb"] = { function() builtin.buffers() end, desc = "Find buffers" }
        maps.n["<Leader>fc"] =
        { function() builtin.grep_string() end, desc = "Find word under cursor" }
        maps.n["<Leader>fC"] = { function() builtin.commands() end, desc = "Find commands" }
        maps.n["<Leader>ff"] = { function() builtin.find_files() end, desc = "Find files" }
        maps.n["<Leader>fF"] = {
            function() builtin.find_files { hidden = true, no_ignore = true } end,
            desc = "Find all files",
        }
        maps.n["<Leader>fh"] = { function() builtin.help_tags() end, desc = "Find help" }
        maps.n["<Leader>fk"] = { function() builtin.keymaps() end, desc = "Find keymaps" }
        maps.n["<Leader>fm"] = { function() builtin.man_pages() end, desc = "Find man" }
        if is_available "nvim-notify" then
            maps.n["<Leader>fn"] =
            { function() require("telescope").extensions.notify.notify() end, desc = "Find notifications" }
        end
        maps.n["<Leader>fo"] = { function() builtin.oldfiles() end, desc = "Find history" }
        maps.n["<Leader>fr"] = { function() builtin.registers() end, desc = "Find registers" }
        maps.n["<Leader>ft"] =
        { function() builtin.colorscheme { enable_preview = true } end, desc = "Find themes" }
        if vim.fn.executable "rg" == 1 then
            maps.n["<Leader>fw"] = { function() builtin.live_grep() end, desc = "Find words" }
            maps.n["<Leader>fW"] = {
                function()
                    builtin.live_grep {
                        additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
                    }
                end,
                desc = "Find words in all files",
            }
        end
        maps.n["<Leader>ls"] = {
            function()
                if is_available "aerial.nvim" then
                    require("telescope").extensions.aerial.aerial()
                else
                    builtin.lsp_document_symbols()
                end
                builtin.lsp_document_symbols()
            end,
            desc = "Search symbols",
        }
        if vim.fn.has "nvim-0.10" == 1 then
            maps.n.gr = { function() builtin.lsp_references() end, desc = "Search references" }
        end
        -- keymaps from astronvim

        for mode, mode_maps  in pairs(maps) do
            for astro_key, map in pairs(mode_maps) do
                local key = string.sub(astro_key, 1, #'<Leader>') == '<Leader>' and '<Leader>' .. astro_key or astro_key
                vim.keymap.set(mode, key, map[1], {desc = map.desc})
            end
        end
    end,
    opts = function()
      local actions = require "telescope.actions"
      --local get_icon = require("astroui").get_icon
      return {
        defaults = {
          git_worktrees = require("astrocore").config.git_worktrees,
          --prompt_prefix = get_icon("Selected", 1),
          --selection_caret = get_icon("Selected", 1),
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55 },
            vertical = { mirror = false },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<C-N>"] = actions.cycle_history_next,
              ["<C-P>"] = actions.cycle_history_prev,
              ["<C-J>"] = actions.move_selection_next,
              ["<C-K>"] = actions.move_selection_previous,
            },
            n = { q = actions.close },
          },
        },
      }
    end,
}
