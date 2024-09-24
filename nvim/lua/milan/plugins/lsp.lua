return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "mfussenegger/nvim-lint",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "folke/neodev.nvim",
        { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
        require("mason").setup()
        require("neodev").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "bashls",
                "lua_ls",
                "gopls",
                "golangci_lint_ls",
            },
            handlers = {
                function(server_name) -- default handler
                    require("lspconfig")[server_name].setup({})
                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = require('cmp_nvim_lsp').default_capabilities(),
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim" }
                                },
                                hint = {
                                    enable = true,
                                }
                            }
                        }
                    }
                end,
                ["gopls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.gopls.setup({
                        capabilities = require('cmp_nvim_lsp').default_capabilities(),
                        settings = {
                            gopls = {
                                semanticTokens = true,
                                usePlaceholders = true,
                                analyses = {
                                    unusedwrite = true,
                                },
                                codelenses = {
                                    generate = true, -- show the `go generate` lens.
                                    tidy = true,
                                    upgrade_dependency = true,
                                },
                                hints = {
                                    assignVariableTypes = true,
                                    compositeLiteralFields = true,
                                    compositeLiteralTypes = true,
                                    constantValues = true,
                                    functionTypeParameters = true,
                                    parameterNames = true,
                                    rangeVariableTypes = true,
                                },

                            }
                        },
                    })
                end,
                ["golangci_lint_ls"] = function()
                    local lspconfig = require("lspconfig")
                    local configs = require("lspconfig/configs")

                    if not configs.golangcilsp then
                        configs.golangcilsp = {
                            default_config = {
                                cmd = { "golangci-lint-langserver" },
                                root_dir = lspconfig.util.root_pattern(".git", "go.mod"),
                                init_options = {
                                    -- command = { "golangci-lint", "run", "--enable-all", "--disable", "lll", "--out-format", "json", "--issues-exit-code=1" },
                                    command = { "golangci-lint", "run", "--enable-all", "--out-format", "json", "--issues-exit-code=1" },
                                }
                            },
                        }
                    end
                    lspconfig.golangci_lint_ls.setup {
                        filetypes = { "go", "gomod" }
                    }
                end
            }
        })
        require('lint').linters_by_ft = {
            openapi = { 'vacuum', }
        }
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            callback = function()
                -- try_lint without arguments runs the linters defined in `linters_by_ft`
                -- for the current filetype
                require("lint").try_lint()
            end,
        })
        local cmp = require("cmp")
        cmp.setup({
            experimental = {
                ghost_text = true,
            },
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-p>"] = cmp.mapping.select_prev_item(),
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
            }, {
                { name = 'path' },
                { name = "buffer", keyword_length = 5 },
            })
        })
    end
}
