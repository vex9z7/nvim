local dict = {
  ["*"] = { "/usr/share/dict/words" },
}

local function setup()
  local cmp_dictionary = require('cmp_dictionary')

  cmp_dictionary.setup({
    paths = dict["*"],
    exact_length = 2,
    first_case_insensitive = true,
    document = {
      enable = true,
      command = { "wn", "${label}", "-over" },
    },
  })
end

try(setup, vim.notify)
