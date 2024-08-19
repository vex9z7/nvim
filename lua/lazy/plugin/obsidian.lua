-- TODO: walkthough the config documents
-- see https://github.com/epwalsh/obsidian.nvim?tab=readme-ov-file#configuration-options

local vaultRoot = "~/Documents/the-vault/"
return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  -- only load obsidian.nvim for markdown files in your vault:
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"

    "BufReadPre "
    .. vaultRoot
    .. "**.md",
    "BufNewFile " .. vaultRoot .. "**.md",
  },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter",
  },
  keys = {
    -- :ObsidianOpen [QUERY] to open a note in the Obsidian app. This command has one optional argument: a query used to resolve the note to open by ID, path, or alias. If not given, the note corresponding to the current buffer is opened.
    { "<leader><leader>oo", "<cmd>ObsidianOpen<cr>",            desc = "Open Obsidian" },
    -- :ObsidianQuickSwitch to quickly switch to (or open) another note in your vault, searching by its name using ripgrep with your preferred picker (see plugin dependencies below).
    { "<leader><leader>of", "<cmd>ObsidianQuickSwitch<cr>",     desc = "Find Obsidian files by names" },
    -- :ObsidianSearch [QUERY] to search for (or create) notes in your vault using ripgrep with your preferred picker.
    { "<leader><leader>ow", "<cmd>ObsidianSearch<cr>",          desc = "Find Obsidian files by words" },
    -- :ObsidianTags [TAG ...] for getting a picker list of all occurrences of the given tags.
    { "<leader><leader>ot", "<cmd>ObsidianTags<cr>",            desc = "Find Obsidian file by tags" },

    -- TODO: uncomment rename when it becomes stable
    --:ObsidianRename [NEWNAME] [--dry-run] to rename the note of the current buffer or reference under the cursor, updating all backlinks across the vault. Since this command is still relatively new and could potentially write a lot of changes to your vault, I highly recommend committing the current state of your vault (if you're using version control) before running it, or doing a dry-run first by appending "--dry-run" to the command, e.g. :ObsidianRename new-id --dry-run.
    -- { "<leader><leader>or", "<cmd>ObsidianRename<cr>",      desc = "Obsidian Rename current note" },

    -- :ObsidianDailies [OFFSET ...] to open a picker list of daily notes. For example, :ObsidianDailies -2 1 to list daily notes from 2 days ago until tomorrow.
    { "<leader><leader>od", "<cmd>ObsidianDailies -1000 1<cr>", desc = "Open Obsidian daily notes" },
    -- :TODO: introduce template into workflow
    -- :ObsidianTemplate [NAME] to insert a template from the templates folder, selecting from a list using your preferred picker. See "using templates" for more information.
    -- { "<leader><leader>ot",         "<cmd>ObsidianTemplate<cr>",        desc = "Insert Obsidian Template into file" },
  },
  opts = {
    workspaces = {
      {
        name = "overall",
        path = "~/Documents/the-vault",
      },
    },

    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      -- folder = "notes/dailies",
      folder = "mujin/daily",
      -- Optional, if you want to change the date format for the ID of daily notes.
      date_format = "%Y-%m-%d",
      -- Optional, if you want to change the date format of the default alias of daily notes.
      -- alias_format = "%B %-d, %Y",
      -- Optional, default tags to add to each new daily note created.
      default_tags = { "daily-notes" },
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      template = "daily.template"
    },
    -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
    completion = {
      -- Set to false to disable completion.
      nvim_cmp = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },
    -- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
    -- way then set 'mappings = {}'.
    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ["gd"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- TODO:
      -- -- Toggle check-boxes.
      -- ["<leader>ch"] = {
      --   action = function()
      --     return require("obsidian").util.toggle_checkbox()
      --   end,
      --   opts = { buffer = true },
      -- },
      -- -- Smart action depending on context, either follow link or toggle checkbox.
      -- ["<cr>"] = {
      --   action = function()
      --     return require("obsidian").util.smart_action()
      --   end,
      --   opts = { buffer = true, expr = true },
      -- }
    },

    -- Optional, customize how note IDs are generated given an optional title.
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      local suffix = ""
      for _ = 1, 4 do
        suffix = suffix .. string.char(math.random(65, 90))
      end
      return tostring(os.time()) .. "-" .. suffix
    end,

    -- Optional, alternatively you can customize the frontmatter data.
    ---@return table
    note_frontmatter_func = function(note)
      -- Add the title of the note as an alias.
      if note.title then
        note:add_alias(note.title)
      end

      local out = { id = note.id, aliases = note.aliases, tags = note.tags }

      -- `note.metadata` contains any manually added fields in the frontmatter.
      -- So here we just make sure those fields are kept in the frontmatter.
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      return out
    end,
    -- Optional, for templates (see below).
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      -- A map for custom variables, the key should be the variable and the value a function
      substitutions = {},
    },
    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    -- URL it will be ignored but you can customize this behavior here.
    ---@param url string
    follow_url_func = function(url)
      -- Open the URL in the default web browser.
      vim.fn.jobstart({ "open", url }) -- Mac OS
      -- vim.fn.jobstart({"xdg-open", url})  -- linux
      -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
      -- vim.ui.open(url) -- need Neovim 0.10.0+
    end,
    -- Optional, configure additional syntax highlighting / extmarks.
    -- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
    ui = {
      enable = true,          -- set to false to disable all additional syntax features
      update_debounce = 200,  -- update delay after a text change (in milliseconds)
      max_file_length = 5000, -- disable UI features for files with more than this many lines
      -- Define how various check-boxes are displayed
      checkboxes = {
        -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        ["!"] = { char = "", hl_group = "ObsidianImportant" },
        -- Replace the above with this if you don't have a patched font:
        -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
        -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

        -- You can also add more custom ones...
      },
      -- Use bullet marks for non-checkbox lists.
      bullets = { char = "•", hl_group = "ObsidianBullet" },
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      -- Replace the above with this if you don't have a patched font:
      -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = "ObsidianRefText" },
      highlight_text = { hl_group = "ObsidianHighlightText" },
      tags = { hl_group = "ObsidianTag" },
      block_ids = { hl_group = "ObsidianBlockID" },
      hl_groups = {
        -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
        ObsidianTodo = { bold = true, fg = "#f78c6c" },
        ObsidianDone = { bold = true, fg = "#89ddff" },
        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        ObsidianTilde = { bold = true, fg = "#ff5370" },
        ObsidianImportant = { bold = true, fg = "#d73128" },
        ObsidianBullet = { bold = true, fg = "#89ddff" },
        ObsidianRefText = { underline = true, fg = "#c792ea" },
        ObsidianExtLinkIcon = { fg = "#c792ea" },
        ObsidianTag = { italic = true, fg = "#89ddff" },
        ObsidianBlockID = { italic = true, fg = "#89ddff" },
        ObsidianHighlightText = { bg = "#75662e" },
      },
    },

    -- see below for full list of options 👇
  },
}

-- TODO: use them after design a workflow with links
-- ? is it better to go with auto completion?
-- :ObsidianLink [QUERY] to link an inline visual selection of text to a note. This command has one optional argument: a query that will be used to resolve the note by ID, path, or alias. If not given, the selected text will be used as the query.
-- ? is it better to go with auto completion?
-- :ObsidianLinkNew [TITLE] to create a new note and link it to an inline visual selection of text. This command has one optional argument: the title of the new note. If not given, the selected text will be used as the title.
--
-- :ObsidianExtractNote [TITLE] to extract the visually selected text into a new note and link to it.
-- :ObsidianBacklinks for getting a picker list of references to the current buffer.
-- :ObsidianFollowLink [vsplit|hsplit] to follow a note reference under the cursor, optionally opening it in a vertical or horizontal split.
-- TODO: integrate it after switch to an emulator that supports image
-- :ObsidianPasteImg [IMGNAME] to paste an image from the clipboard into the note at the cursor position by saving it to the vault and adding a markdown image link. You can configure the default folder to save images to with the attachments.img_folder option.
