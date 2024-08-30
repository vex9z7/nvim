local function setup()
  local animate = require('mini.animate')
  animate.setup({
    cursor = {
      timing = animate.gen_timing.exponential({ duration = 80, unit = 'total' })
    },
    scroll = {
      timing = animate.gen_timing.exponential({ duration = 80, unit = 'total' }),
      subscroll = animate.gen_subscroll.equal({ max_output_steps = 20}),
    }
  })
end

try(setup, vim.notify)
