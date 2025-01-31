local empty_map_table = function()
    local maps = {}
    for _, mode in ipairs({
        "",
        "n",
        "v",
        "x",
        "s",
        "o",
        "!",
        "i",
        "l",
        "c",
        "t",
    }) do
        maps[mode] = {}
    end
    if vim.fn.has("nvim-0.10.0") == 1 then
        for _, abbr_mode in ipairs({ "ia", "ca", "!a" }) do
            maps[abbr_mode] = {}
        end
    end
    return maps
end

return {
    "AstroNvim/astrolsp",
    dependencies = {
        "AstroNvim/astrocore",
    },
    config = function()
        local maps = empty_map_table()

        -- TODO: Remove mapping after dropping support for Neovim v0.9, it's automatic
        maps.n["<Leader>la"] = {
            function()
                vim.lsp.buf.code_action()
            end,
            desc = "LSP code action",
            cond = "testDocument/codeAction", -- LSP client capability string
        }
        maps.v["<Leader>la"] = maps.n["<Leader>la"]

        maps.n["<Leader>ll"] = {
            function()
                vim.lsp.codelens.refresh()
            end,
            desc = "LSP CodeLens refresh",
            cond = "textDocument/codeLens",
        }
        maps.n["<Leader>lL"] = {
            function()
                vim.lsp.codelens.run()
            end,
            desc = "LSP CodeLens run",
            cond = "textDocument/codeLens",
        }
        maps.n["<Leader>uL"] = {
            function()
                require("astrolsp.toggles").codelens()
            end,
            desc = "Toggle CodeLens",
            cond = "textDocument/codeLens",
        }

        maps.n["gD"] = {
            function()
                vim.lsp.buf.declaration()
            end,
            desc = "Declaration of current symbol",
            cond = "textDocument/declaration",
        }
        maps.n["gd"] = {
            function()
                vim.lsp.buf.definition()
            end,
            desc = "Show the definition of current symbol",
            cond = "textDocument/definition",
        }

        -- TODO: Remove mapping after dropping support for Neovim v0.9, it's automatic
        if vim.fn.has("nvim-0.10") == 0 then
            maps.n["K"] = {
                function()
                    vim.lsp.buf.hover()
                end,
                desc = "Hover symbol details",
                cond = "textDocument/hover",
            }
        end

        maps.n["gI"] = {
            function()
                vim.lsp.buf.implementation()
            end,
            desc = "Implementation of current symbol",
            cond = "textDocument/implementation",
        }

        maps.n["<Leader>uh"] = {
            function()
                require("astrolsp.toggles").buffer_inlay_hints()
            end,
            desc = "Toggle LSP inlay hints (buffer)",
            cond = vim.lsp.inlay_hint and "textDocument/inlayHint" or false,
        }
        maps.n["<Leader>uH"] = {
            function()
                require("astrolsp.toggles").inlay_hints()
            end,
            desc = "Toggle LSP inlay hints (global)",
            cond = vim.lsp.inlay_hint and "textDocument/inlayHint" or false,
        }

        -- TODO: Remove mapping after dropping support for Neovim v0.9, it's automatic
        if vim.fn.has("nvim-0.10") == 0 then
            maps.n["gr"] = {
                function()
                    vim.lsp.buf.references()
                end,
                desc = "References of current symbol",
                cond = "textDocument/references",
            }
        end

        maps.n["<Leader>lr"] = {
            function()
                vim.lsp.buf.rename()
            end,
            desc = "Rename current symbol",
            cond = "textDocument/rename",
        }

        maps.n["<Leader>lh"] = {
            function()
                vim.lsp.buf.signature_help()
            end,
            desc = "Signature help",
            cond = "textDocument/signatureHelp",
        }
        maps.n["gK"] = {
            function()
                vim.lsp.buf.signature_help()
            end,
            desc = "Signature help",
            cond = "textDocument/signatureHelp",
        }

        maps.n["gy"] = {
            function()
                vim.lsp.buf.type_definition()
            end,
            desc = "Definition of current type",
            cond = "textDocument/typeDefinition",
        }

        maps.n["<Leader>lG"] = {
            function()
                vim.lsp.buf.workspace_symbol()
            end,
            desc = "Search workspace symbols",
            cond = "workspace/symbol",
        }

        maps.n["<Leader>uY"] = {
            function()
                require("astrolsp.toggles").buffer_semantic_tokens()
            end,
            desc = "Toggle LSP semantic highlight (buffer)",
            cond = function(client)
                return client.server_capabilities.semanticTokensProvider
                    and vim.lsp.semantic_tokens
            end,
        }
        maps.n["<Leader>ld"] = {
            function()
                vim.diagnostic.open_float()
            end,
            desc = "Hover diagnostics",
        }

        if vim.fn.has("nvim-0.10") == 0 then
            maps.n["[d"] = {
                function()
                    vim.diagnostic.goto_prev()
                end,
                desc = "Previous diagnostic",
            }
            maps.n["]d"] = {
                function()
                    vim.diagnostic.goto_next()
                end,
                desc = "Next diagnostic",
            }
        end
        maps.n["gl"] = {
            function()
                vim.diagnostic.open_float()
            end,
            desc = "Hover diagnostics",
        }

        for mode, mode_maps in pairs(maps) do
            for astro_key, map in pairs(mode_maps) do
                local key = string.sub(astro_key, 1, #"<Leader>") == "<Leader>"
                        and "<Leader>" .. astro_key
                    or astro_key
                vim.keymap.set(mode, key, map[1], { desc = map.desc })
            end
        end
    end,
}
