return {
  'ruifm/gitlinker.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local gitlinker = require('gitlinker')

    gitlinker.setup({
      opts = {
        remote = nil, -- force the use of a specific remote
        -- adds current line nr in the url for normal mode
        add_current_line_on_normal_mode = true,
        -- callback for what to do with the url
        action_callback = require "gitlinker.actions".copy_to_clipboard,
        -- print the url after performing the action
        print_url = true,
      },
      callbacks = {
        ["github.com"] = require "gitlinker.hosts".get_github_type_url,
        ["gitlab.com"] = require "gitlinker.hosts".get_gitlab_type_url,
        ["try.gitea.io"] = require "gitlinker.hosts".get_gitea_type_url,
        ["codeberg.org"] = require "gitlinker.hosts".get_gitea_type_url,
        ["bitbucket.org"] = require "gitlinker.hosts".get_bitbucket_type_url,
        ["try.gogs.io"] = require "gitlinker.hosts".get_gogs_type_url,
        ["git.sr.ht"] = require "gitlinker.hosts".get_srht_type_url,
        ["git.launchpad.net"] = require "gitlinker.hosts".get_launchpad_type_url,
        ["repo.or.cz"] = require "gitlinker.hosts".get_repoorcz_type_url,
        ["git.kernel.org"] = require "gitlinker.hosts".get_cgit_type_url,
        ["git.savannah.gnu.org"] = require "gitlinker.hosts".get_cgit_type_url
      },
      -- default mapping to call url generation with action_callback
      mappings = nil
      -- FIXME: cannot disable the default mapping, the causing line
      -- https://github.com/ruifm/gitlinker.nvim/blob/cc59f732f3d043b626c8702cb725c82e54d35c25/lua/gitlinker/mappings.lua#L20
    })

    for mode, description in pairs({ n = 'Copy the permanent link to current line', v = 'Copy the permanent link to selected lines' }) do
      vim.keymap.set(mode, "<leader><leader>gy", function()
        gitlinker.get_buf_range_url(mode)
      end, { silent = false, noremap = true, desc = description })
    end
  end
}
