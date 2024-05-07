return {
  "lewis6991/gitsigns.nvim",
  enabled = vim.fn.executable "git" == 1,
  config = function ()
    local maps = { n={}, i={}, t={}, v={} }

    -- keymaps from astronvim
    -- maps.n["<Leader>g"] = vim.tbl_get(opts, "_map_sections", "g")
    maps.n["]g"] = { function() require("gitsigns").next_hunk() end, desc = "Next Git hunk" }
    maps.n["[g"] = { function() require("gitsigns").prev_hunk() end, desc = "Previous Git hunk" }
    maps.n["<Leader>gl"] = { function() require("gitsigns").blame_line() end, desc = "View Git blame" }
    maps.n["<Leader>gL"] =
    { function() require("gitsigns").blame_line { full = true } end, desc = "View full Git blame" }
    maps.n["<Leader>gp"] = { function() require("gitsigns").preview_hunk_inline() end, desc = "Preview Git hunk" }
    maps.n["<Leader>gh"] = { function() require("gitsigns").reset_hunk() end, desc = "Reset Git hunk" }
    maps.n["<Leader>gr"] = { function() require("gitsigns").reset_buffer() end, desc = "Reset Git buffer" }
    maps.n["<Leader>gs"] = { function() require("gitsigns").stage_hunk() end, desc = "Stage Git hunk" }
    maps.n["<Leader>gS"] = { function() require("gitsigns").stage_buffer() end, desc = "Stage Git buffer" }
    maps.n["<Leader>gu"] = { function() require("gitsigns").undo_stage_hunk() end, desc = "Unstage Git hunk" }
    maps.n["<Leader>gd"] = { function() require("gitsigns").diffthis() end, desc = "View Git diff" }
    -- keymaps from astronvim

    for mode, mode_maps  in pairs(maps) do
      for key, map in pairs(mode_maps) do
        vim.keymap.set(mode, '<Leader>' .. key, map[1], {desc = map.desc})
      end
    end
  end,
  opts = function()
    -- local get_icon = require("astroui").get_icon
    return {
      -- signs = {
      --   add = { text = get_icon "GitSign" },
      --   change = { text = get_icon "GitSign" },
      --   delete = { text = get_icon "GitSign" },
      --   topdelete = { text = get_icon "GitSign" },
      --   changedelete = { text = get_icon "GitSign" },
      --   untracked = { text = get_icon "GitSign" },
      -- },
      worktrees = require("astrocore").config.git_worktrees,
    }
  end,
}
