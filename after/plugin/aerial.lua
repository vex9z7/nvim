function setup()
    local aerial = require("aerial")
    vim.keymap.set(
        "n",
        "<Leader><Leader>ln",
        aerial.nav_toggle,
        { desc = "Toggle aerial navigation window" }
    )
end

try(setup, vim.notify)
