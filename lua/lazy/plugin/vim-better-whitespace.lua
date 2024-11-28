return {
    "ntpeters/vim-better-whitespace",
    config = function()
        vim.g.strip_whitespace_on_save = true
        vim.g.strip_whitespace_confirm = false
        vim.g.strip_only_modified_lines = false
    end,
}
