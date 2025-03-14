---@module "snacks"
---@class snacks.dim.Config
return {
    enabled = true,
    scope = {
        min_size = 5,
        max_size = 20,
        siblings = true,
        enabled = true,
        cursor = true,
    },
    -- animate scopes. Enabled by default for Neovim >= 0.10
    -- Works on older versions but has to trigger redraws during animation.
    ---@type snacks.animate.Config|{enabled?: boolean}
    animate = {
        enabled = false,
        -- enabled = vim.fn.has("nvim-0.10") == 1,
        easing = "outQuad",
        duration = {
            step = 10, -- ms per step
            total = 300, -- maximum duration
        },
    },
    -- what buffers to dim
    filter = function(buf)
        return vim.g.snacks_dim ~= false
            and vim.b[buf].snacks_dim ~= false
            and vim.bo[buf].buftype == ""
    end,
}
