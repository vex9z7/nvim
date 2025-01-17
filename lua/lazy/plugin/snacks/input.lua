---@module "snacks"
---@class snacks.input.Config
---@field enabled? boolean
---@field win? snacks.win.Config|{}
---@field icon? string
---@field icon_pos? snacks.input.Pos
---@field prompt_pos? snacks.input.Pos
return {
    enabled = false,
    icon = " ",
    icon_hl = "SnacksInputIcon",
    icon_pos = "left",
    prompt_pos = "title",
    win = { style = "input" },
    expand = true,
}
