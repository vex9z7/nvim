return {
    "AstroNvim/astrolsp",
    config = function ()
        local maps = require("astrocore").empty_map_table()
        -- maps.v["<Leader>l"] = { desc = require("astroui").get_icon("ActiveLSP", 1, true) .. "Language Tools" }

        -- TODO: Remove mapping after dropping support for Neovim v0.9, it's automatic
        if vim.fn.has "nvim-0.10" == 0 then
            maps.n["crr"] = {
                function() vim.lsp.buf.code_action() end,
                desc = "LSP code action",
                cond = "testDocument/codeAction", -- LSP client capability string
            }
            maps.v["<C-R>r"] = maps.n["crr"]
            maps.v["<C-R><C-R>"] = maps.n["<C-R>r"]
        end
        maps.n["<Leader>la"] = {
            function() vim.lsp.buf.code_action() end,
            desc = "LSP code action",
            cond = "testDocument/codeAction", -- LSP client capability string
        }
        maps.v["<Leader>la"] = maps.n["<Leader>la"]

        maps.n["<Leader>ll"] =
        { function() vim.lsp.codelens.refresh() end, desc = "LSP CodeLens refresh", cond = "textDocument/codeLens" }
        maps.n["<Leader>lL"] =
        { function() vim.lsp.codelens.run() end, desc = "LSP CodeLens run", cond = "textDocument/codeLens" }
        maps.n["<Leader>uL"] = {
            function() require("astrolsp.toggles").codelens() end,
            desc = "Toggle CodeLens",
            cond = "textDocument/codeLens",
        }

        maps.n["gD"] = {
            function() vim.lsp.buf.declaration() end,
            desc = "Declaration of current symbol",
            cond = "textDocument/declaration",
        }
        maps.n["gd"] = {
            function() vim.lsp.buf.definition() end,
            desc = "Show the definition of current symbol",
            cond = "textDocument/definition",
        }

        local formatting_enabled = function(client)
            local disabled = true
            -- local disabled = opts.formatting.disabled
            -- return false
            return client.supports_method "textDocument/formatting"
                and disabled ~= true
                and not vim.tbl_contains(disabled, client.name)
        end
        maps.n["<Leader>lf"] = {
            function() vim.lsp.buf.format(require("astrolsp").format_opts) end,
            desc = "Format buffer",
            cond = formatting_enabled,
        }
        maps.v["<Leader>lf"] = maps.n["<Leader>lf"]
        maps.n["<Leader>uf"] = {
            function() require("astrolsp.toggles").buffer_autoformat() end,
            desc = "Toggle autoformatting (buffer)",
            cond = formatting_enabled,
        }
        maps.n["<Leader>uF"] = {
            function() require("astrolsp.toggles").autoformat() end,
            desc = "Toggle autoformatting (global)",
            cond = formatting_enabled,
        }

        -- TODO: Remove mapping after dropping support for Neovim v0.9, it's automatic
        if vim.fn.has "nvim-0.10" == 0 then
            maps.n["K"] = { function() vim.lsp.buf.hover() end, desc = "Hover symbol details", cond = "textDocument/hover" }
        end

        maps.n["gI"] = {
            function() vim.lsp.buf.implementation() end,
            desc = "Implementation of current symbol",
            cond = "textDocument/implementation",
        }

        maps.n["<Leader>uh"] = {
            function() require("astrolsp.toggles").buffer_inlay_hints() end,
            desc = "Toggle LSP inlay hints (buffer)",
            cond = vim.lsp.inlay_hint and "textDocument/inlayHint" or false,
        }
        maps.n["<Leader>uH"] = {
            function() require("astrolsp.toggles").inlay_hints() end,
            desc = "Toggle LSP inlay hints (global)",
            cond = vim.lsp.inlay_hint and "textDocument/inlayHint" or false,
        }

        -- TODO: Remove mapping after dropping support for Neovim v0.9, it's automatic
        if vim.fn.has "nvim-0.10" == 0 then
            maps.n["gr"] = {
                function() vim.lsp.buf.references() end,
                desc = "References of current symbol",
                cond = "textDocument/references",
            }
        end
        maps.n["<Leader>lR"] =
        { function() vim.lsp.buf.references() end, desc = "Search references", cond = "textDocument/references" }

        maps.n["<Leader>lr"] =
        { function() vim.lsp.buf.rename() end, desc = "Rename current symbol", cond = "textDocument/rename" }
        -- TODO: Remove mapping after dropping support for Neovim v0.9, it's automatic
        if vim.fn.has "nvim-0.10" == 0 then
            maps.n["crn"] =
            { function() vim.lsp.buf.rename() end, desc = "Rename current symbol", cond = "textDocument/rename" }
        end

        maps.n["<Leader>lh"] =
        { function() vim.lsp.buf.signature_help() end, desc = "Signature help", cond = "textDocument/signatureHelp" }
        maps.n["gK"] =
        { function() vim.lsp.buf.signature_help() end, desc = "Signature help", cond = "textDocument/signatureHelp" }

        maps.n["gy"] = {
            function() vim.lsp.buf.type_definition() end,
            desc = "Definition of current type",
            cond = "textDocument/typeDefinition",
        }

        maps.n["<Leader>lG"] =
        { function() vim.lsp.buf.workspace_symbol() end, desc = "Search workspace symbols", cond = "workspace/symbol" }

        maps.n["<Leader>uY"] = {
            function() require("astrolsp.toggles").buffer_semantic_tokens() end,
            desc = "Toggle LSP semantic highlight (buffer)",
            cond = function(client) return client.server_capabilities.semanticTokensProvider and vim.lsp.semantic_tokens end,
        }
        -- opts.mappings = require("astrocore").extend_tbl(opts.mappings, maps)

        for mode, mode_maps  in pairs(maps) do
            for astro_key, map in pairs(mode_maps) do
                local key = string.sub(astro_key, 1, #'<Leader>') == '<Leader>' and '<Leader>' .. astro_key or astro_key
                vim.keymap.set(mode, key, map[1], {desc = map.desc})
            end
        end
    end
}