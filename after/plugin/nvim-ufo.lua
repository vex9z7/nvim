local setup = function()
    -- FIXME: use auto command after theme switched
    vim.cmd("hi clear Folded")
end

try(setup, vim.notify)
