return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            -- A list of parser names, or "all"
            -- see the full list at https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#supported-languages
            ensure_installed = "all",

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
            auto_install = true,

            indent = {
                enable = true,
            },

            highlight = {
                -- `false` will disable the whole extension
                enable = true,

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = { "markdown" },
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = {
                            query = "@function.outer",
                            desc = "function outer",
                        },
                        ["if"] = {
                            query = "@function.inner",
                            desc = "function.inner",
                        },
                        ["ac"] = {
                            query = "@class.outer",
                            desc = "class.outer",
                        },
                        ["ic"] = {
                            query = "@class.inner",
                            desc = "class.inner",
                        },
                        ["a,"] = {
                            query = "@parameter.outer",
                            desc = "parameter.outer",
                        },
                        ["i,"] = {
                            query = "@parameter.inner",
                            desc = "parameter.inner",
                        },
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["<leader>]f"] = {
                            query = "@function.outer",
                            desc = "function.outer",
                        },
                        ["<leader>]c"] = {
                            query = "@class.outer",
                            desc = "class.outer",
                        },
                        ["<leader>],"] = {
                            query = "@parameter.inner",
                            desc = "parameter.inner",
                        },
                    },
                    goto_next_end = {
                        ["<leader>]F"] = {
                            query = "@function.outer",
                            desc = "function.outer",
                        },
                        ["<leader>]C"] = {
                            query = "@class.outer",
                            desc = "class.outer",
                        },
                    },
                    goto_previous_start = {
                        ["<leader>[f"] = {
                            query = "@function.outer",
                            desc = "function.outer",
                        },
                        ["<leader>[c"] = {
                            query = "@class.outer",
                            desc = "class.outer",
                        },
                        ["<leader>[,"] = {
                            query = "@parameter.inner",
                            desc = "parameter.inner",
                        },
                    },
                    goto_previous_end = {
                        ["<leader>[F"] = {
                            query = "@function.outer",
                            desc = "function.outer",
                        },
                        ["<leader>[C"] = {
                            query = "@class.outer",
                            desc = "class.outer",
                        },
                    },
                },
            },
        })

        local treesitter_parser_config =
            require("nvim-treesitter.parsers").get_parser_configs()
        treesitter_parser_config.templ = {
            install_info = {
                url = "https://github.com/vrischmann/tree-sitter-templ.git",
                files = { "src/parser.c", "src/scanner.c" },
                branch = "master",
            },
        }

        vim.treesitter.language.register("templ", "templ")
    end,
}
