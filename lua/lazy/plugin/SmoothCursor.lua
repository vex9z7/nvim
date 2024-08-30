function setup_symbols_colors()
  local autocmd = vim.api.nvim_create_autocmd

  -- TODO: align the color with status bar
  autocmd({ 'ModeChanged' }, {
    callback = function()
      local current_mode = vim.fn.mode()
      if current_mode == 'n' then
        vim.api.nvim_set_hl(0, 'SmoothCursor', { fg = '#8aa872' })
        vim.fn.sign_define('smoothcursor', { text = '' })
      elseif current_mode == 'v' then
        vim.api.nvim_set_hl(0, 'SmoothCursor', { fg = '#bf616a' })
        vim.fn.sign_define('smoothcursor', { text = '' })
      elseif current_mode == 'V' then
        vim.api.nvim_set_hl(0, 'SmoothCursor', { fg = '#bf616a' })
        vim.fn.sign_define('smoothcursor', { text = '' })
      elseif current_mode == '�' then
        vim.api.nvim_set_hl(0, 'SmoothCursor', { fg = '#bf616a' })
        vim.fn.sign_define('smoothcursor', { text = '' })
      elseif current_mode == 'i' then
        vim.api.nvim_set_hl(0, 'SmoothCursor', { fg = '#668aab' })
        vim.fn.sign_define('smoothcursor', { text = '' })
      end
    end,
  })
end

local matrix_chars = {
  'ｱ', 'ｲ', 'ｳ', 'ｴ', 'ｵ',
  'ｶ', 'ｷ', 'ｸ', 'ｹ', 'ｺ',
  'ｻ', 'ｼ', 'ｽ', 'ｾ', 'ｿ',
  'ﾀ', 'ﾁ', 'ﾂ', 'ﾃ', 'ﾄ',
  'ﾅ', 'ﾆ', 'ﾇ', 'ﾈ', 'ﾉ',
  'ﾊ', 'ﾋ', 'ﾌ', 'ﾍ', 'ﾎ',
  'ﾏ', 'ﾐ', 'ﾑ', 'ﾒ', 'ﾓ',
  'ﾔ', 'ﾕ', 'ﾖ',
  'ﾗ', 'ﾘ', 'ﾙ', 'ﾚ', 'ﾛ',
  'ﾜ', 'ｦ', 'ﾝ',
  '○', 'x', '△', '□', '▽',
}


return {
  'gen740/SmoothCursor.nvim',
  config = function()
    require('smoothcursor').setup({
      type = "exp", -- Cursor movement calculation method, choose "default", "exp" (exponential) or "matrix".

      cursor = "", -- Cursor shape (requires Nerd Font). Disabled in fancy mode.
      texthl = "nil", -- Highlight group. Default is { bg = nil, fg = "#FFD400" }. Disabled in fancy mode.
      linehl = nil, -- Highlights the line under the cursor, similar to 'cursorline'. "CursorLine" is recommended. Disabled in fancy mode.

      fancy = {
        enable = true, -- enable fancy mode
        head = false,  -- false to disable fancy head
        body = {
          { cursor = "󰝥", texthl = "SmoothCursorRed" },
          { cursor = "󰝥", texthl = "SmoothCursorOrange" },
          { cursor = "•", texthl = "SmoothCursorYellow" },
          { cursor = "•", texthl = "SmoothCursorGreen" },
          { cursor = "•", texthl = "SmoothCursorAqua" },
          { cursor = ".", texthl = "SmoothCursorBlue" },
          { cursor = ".", texthl = "SmoothCursorPurple" },
        }
        ,
        tail = false, -- false to disable fancy tail
      },

      matrix = { -- Loaded when 'type' is set to "matrix"
        head = {
          cursor = nil,
          linehl = nil,
          texthl = nil,
        },
        body = {
          length = 4,            -- Specifies the length of the cursor body
          -- Picks a random character from this list for the cursor body text
          cursor = matrix_chars, -- require('smoothcursor.matrix_chars'),
          -- Picks a random highlight from this list for each segment of the cursor body
          texthl = {
            'SmoothCursorRed',
            'SmoothCursorOrange',
            'SmoothCursorYellow',
            'SmoothCursorGreen',
            'SmoothCursorAqua',
            'SmoothCursorBlue',
            'SmoothCursorPurple',
          },
        },
        tail = {
          -- Picks a random character from this list for the cursor tail (if any)
          cursor = nil,
          -- Picks a random highlight from this list for the cursor tail
          texthl = {
            'SmoothCursor',
          },
        },
        unstop = false, -- Determines if the cursor should stop or not (false means it will stop)
      },

      autostart = true,          -- Automatically start SmoothCursor
      always_redraw = true,      -- Redraw the screen on each update
      flyin_effect = 'bottom',   -- Choose "bottom" or "top" for flying effect
      speed = 50,                -- Max speed is 100 to stick with your current position
      intervals = 50,            -- Update intervals in milliseconds
      priority = 10,             -- Set marker priority
      timeout = 99999,           -- Timeout for animations in milliseconds
      threshold = 0,             -- Animate only if cursor moves more than this many lines
      max_threshold = nil,       -- If you move more than this many lines, don't animate (if `nil`, deactivate check)
      disable_float_win = false, -- Disable in floating windows
      enabled_filetypes = nil,   -- Enable only for specific file types, e.g., { "lua", "vim" }
      disabled_filetypes = nil,  -- Disable for these file types, ignored if enabled_filetypes is set. e.g., { "TelescopePrompt", "NvimTree" }
      -- Show the position of the latest input mode positions.
      -- A value of "enter" means the position will be updated when entering the mode.
      -- A value of "leave" means the position will be updated when leaving the mode.
      -- `nil` = disabled
      show_last_positions = nil,
    })
  end
}
