return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        {"j-hui/fidget.nvim", opts = {}},
    },
    config = function ()
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "gopls"
            },
            handlers = {
                function (server_name) -- default handler
                    require("lspconfig")[server_name].setup({})
                end,
           ["lua_ls"] = function ()
               local lspconfig = require("lspconfig")
               lspconfig.lua_ls.setup {
                   settings = {
                       Lua = {
                           diagnostics = {
                               globals = { "vim" }
                           }
                       }
                   }
               }
           end,
            }
        })
        local cmp = require("cmp")
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['C-p'] = cmp.mapping.select_prev_item(cmp_select),
                ['C-n'] = cmp.mapping.select_next_item(cmp_select),
                ['<Tab>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                {name = "nvim_lsp"},
                {name = "luasnip"},
            }, {
                {name = "buffer"},
            })
        })
    end
}
