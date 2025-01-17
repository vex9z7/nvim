---@module "snacks"
---@class snacks.bigfile.Config
return {
    enabled = true,
    notify = true, -- show notification when big file detected
    size = 1.5 * 1024 * 1024, -- 1.5MB
    -- Enable or disable features when big file detected
    ---@param ctx {buf: number, ft:string}
    setup = function(ctx)
        if vim.fn.exists(":NoMatchParen") ~= 0 then
            vim.cmd([[NoMatchParen]])
        end
        Snacks.util.wo(
            0,
            { foldmethod = "manual", statuscolumn = "", conceallevel = 0 }
        )
        vim.b.minianimate_disable = true
        vim.schedule(function()
            vim.bo[ctx.buf].syntax = ctx.ft
        end)
    end,
}
