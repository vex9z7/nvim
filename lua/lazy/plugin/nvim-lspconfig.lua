function attach_auto_formatter(client, bufnr, opts)
  opts = vim.F.if_nil(opts, {})
  if false and client.supports_method("textDocument/rangeFormatting") then
    local result = require("lsp-format-modifications").attach(client, bufnr,
      {
        format_on_save = true,
        experimental_empty_line_handling = true,
        format_callback = function(diff)
          vim.lsp.buf.format(vim.tbl_extend("keep", opts, diff))
        end,
      })
    if result.success then
      vim.notify("Ranger formatter " .. client.name .. " is attached to the buffer")
    else
      vim.notify("Ranger formatter " .. client.name .. " cannot be attached to the buffer")
    end
  elseif client.supports_method("textDocument/formatting") then
    local augroup = vim.api.nvim_create_augroup("LspFileFormatting", {})
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre",
      {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format(opts)
        end,
      })
    vim.notify("Formatter " .. client.name .. " is attached to the buffer")
  end
end

-- A workaround to fix the exception that occurs on jumping to a css style.
-- 2 Steps solution:
--    1. disable tsserver go to definition for it. See more details at https://github.com/neovim/neovim/issues/19237#issuecomment-2259638650
--    2. install and config cssmodules-language-server from Mason. A nice catch from https://github.com/neovim/neovim/issues/19237#issuecomment-1509945822
local tsHandlers = {
  ["textDocument/definition"] = function(err, result, params, ...)
    if result == nil or vim.tbl_isempty(result) then
      return nil
    end

    if vim.islist(result) then
      for _, value in pairs(result) do
        local uri = value.targetUri
        if uri == nil then
          return nil
        else
          -- definition of disbaled file extensions
          local extensions_to_check = { ".less", ".scss", ".css" } -- INFO: not sure if we should disable css as well

          local function ends_with(str, suffix)
            local str_len = string.len(str)
            local suffix_len = string.len(suffix)

            return str_len >= suffix_len and string.sub(str, -suffix_len) == suffix
          end

          for _, extension in ipairs(extensions_to_check) do
            if ends_with(uri, extension) then
              return nil
            end
          end
        end
      end
    end
    return vim.lsp.handlers['textDocument/definition'](err, result, params, ...)
  end,
}


return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "j-hui/fidget.nvim",
  },

  config = function()
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities()
    )

    require("fidget").setup({})
    require("mason").setup()

    local lspconfig = require("lspconfig")

    require("mason-lspconfig").setup({
      ensure_installed = {
        "tsserver",
        "stylelint_lsp",
        "cssmodules_ls",
        -- "pyright",
        "lua_ls",
        "rust_analyzer",
        "gopls",
        "cssls",
        -- "markdown"
        "marksman",
        -- "css_variables",
      },
      handlers = {
        function(server_name) -- default handler (optional)
          lspconfig[server_name].setup({
            capabilities = capabilities,
          })
        end,
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = "Lua 5.1" },
                diagnostics = {
                  globals = { "vim", "it", "describe", "before_each", "after_each" },
                },
              },
            },
            on_attach = function(client, bufnr)
              attach_auto_formatter(client, bufnr, { name = "lua_ls" })
            end
          })
        end,
        ["tsserver"] = function()
          lspconfig.tsserver.setup({
            handlers = tsHandlers,
            on_attach = function(client)
              -- disable the formatting from tsserver
              client.server_capabilities.documentFormattingProvider = false
              client.server_capabilities.documentRangeFormattingProvider = false
            end,
            capabilities = capabilities,
            init_options = {
              preferences = {
                importModuleSpecifierPreference = "relative",
                importModuleSpecifierEnding = "minimal",
                -- inlay hints
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          })


          local augroup = vim.api.nvim_create_augroup("TsserverCleanImports", {})
          vim.api.nvim_clear_autocmds({ group = augroup })

          vim.api.nvim_create_autocmd("BufWritePre",
            {
              -- FIXME:  resolve dependency on null-ls formatter finish
              group = augroup,
              pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
              callback = function()
                local params = {
                  command = "_typescript.organizeImports",
                  arguments = { vim.api.nvim_buf_get_name(0) },
                  title = "CleanImports"
                }
                vim.lsp.buf.execute_command(params)
              end,
            })
        end,
        -- TODO: add custom config if pyright conflicts with linter or formatter
        -- ["pyright"] = function() end,
      },
    })


    vim.diagnostic.config({
      -- update_in_insert = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
  end,
}
