-- local content = [[
-- # Hello World
--
-- ![This is a remote image](https://gist.ro/s/remote.png)
-- ]]
--
-- vim.schedule(function()
--   local buf = vim.api.nvim_create_buf(false, true)
--   vim.api.nvim_buf_set_lines(buf, 0, -1, true, vim.split(content, "\n"))
--   vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
--   vim.api.nvim_set_current_buf(buf)
--   vim.cmd("split")
-- end)

return {
    "3rd/image.nvim",
    dependencies = {
        "kiyoon/magick.nvim",
    },
    enabled = false,
    config = function()
        require("image").setup({
            backend = "kitty",
            integrations = {
                markdown = {
                    enabled = true,
                    clear_in_insert_mode = false,
                    download_remote_images = true,
                    only_render_image_at_cursor = false,
                    filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
                    resolve_image_path = function(
                        document_path,
                        image_path,
                        fallback
                    )
                        -- document_path is the path to the file that contains the image
                        -- image_path is the potentially relative path to the image. for
                        -- markdown it's `![](this text)`

                        -- you can call the fallback function to get the default behavior
                        --
                        document_path = string.gsub(document_path, "/daily", "")
                        vim.print(document_path)

                        return fallback(document_path, image_path)
                    end,
                },
                neorg = {
                    enabled = true,
                    clear_in_insert_mode = false,
                    download_remote_images = true,
                    only_render_image_at_cursor = false,
                    filetypes = { "norg" },
                },
                html = {
                    enabled = false,
                },
                css = {
                    enabled = false,
                },
            },
            max_width = nil,
            max_height = nil,
            max_width_window_percentage = nil,
            max_height_window_percentage = 50,
            window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
            window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
            editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
            tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
            hijack_file_patterns = {
                "*.png",
                "*.jpg",
                "*.jpeg",
                "*.gif",
                "*.webp",
                "*.avif",
            }, -- render image files as images when opened
        })
    end,
}
