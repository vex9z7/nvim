local vaultRoot = vim.fn.expand("~/Documents/the-vault/")

local function generateRandomHexString(length)
    local hexString = ""
    for i = 1, length do
        hexString = hexString .. string.format("%x", math.random(0, 15))
    end
    return hexString
end

local defaultOpts = {
    home = vaultRoot,
    dailies = vim.fs.joinpath(vaultRoot, "daily"),
    templates = vim.fs.joinpath(vaultRoot, "templates"),

    template_new_daily = vim.fs.joinpath(
        vaultRoot,
        "templates/telekasten.daily.template.md"
    ),
    template_new_note = vim.fs.joinpath(
        vaultRoot,
        "templates/telekasten.zettel.md"
    ),
    -- image_subdir = "assets",
    auto_set_filetype = false,
    journal_auto_open = true,
    sort = "modified",
    command_palette_theme = "dropdown",
    template_handling = "always_ask",
    new_note_filename = "uuid",
    uuid_sep = "-",
    uuid_type = function()
        local result = generateRandomHexString(6)
        vim.print(result)
        return result
    end,
    follow_url_fallback = "lua vim.ui.open({{url}})",
}

return {
    "renerocksai/telekasten.nvim",
    dependencies = {
        "renerocksai/calendar-vim",
        "nvim-telescope/telescope.nvim",
    },
    enabled = false,

    config = function()
        require("telekasten").setup(vim.tbl_extend("force", defaultOpts, {
            vaults = {
                projects = vim.tbl_extend(
                    "force",
                    defaultOpts,
                    { home = vim.fs.joinpath(vaultRoot, "projects") }
                ),
                areas = vim.tbl_extend(
                    "force",
                    defaultOpts,
                    { home = vim.fs.joinpath(vaultRoot, "areas") }
                ),
                zettel = vim.tbl_extend(
                    "force",
                    defaultOpts,
                    { home = vim.fs.joinpath(vaultRoot, "zettel") }
                ),
            },
        }))
    end,

    keys = {
        {
            "<leader><leader>z",
            function()
                require("telekasten").panel()
            end,
            desc = "telekasten panel",
        },
    },
}
