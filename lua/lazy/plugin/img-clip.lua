-- INFO: system dependencies:
-- Linux: xclip on <F2>11 or wl-clipboard on wayland
-- MacOS: pngpaste

local function is_zk_note()
    local current_file = vim.api.nvim_buf_get_name(0)
    local zk_dir = vim.env.ZK_NOTEBOOK_DIR
    return zk_dir and current_file:find(zk_dir, 1, true)
end

return {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
        default = {
            dir_path = function()
                if is_zk_note() then
                    return vim.env.ZK_NOTEBOOK_DIR .. "/attachments"
                end
                return "asserts"
            end,
            prompt_for_file_name = false,
        },
        filetypes = {
            markdown = {
                download_images = true,
            },
        },
    },
    keys = {
        -- suggested keymap
        {
            "<leader>P",
            "<cmd>PasteImage<cr>",
            desc = "Paste image from system clipboard",
        },
    },
}
