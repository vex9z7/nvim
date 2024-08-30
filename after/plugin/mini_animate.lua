local function setup()
  require('mini.animate').setup()
end

try(setup, vim.notify)
