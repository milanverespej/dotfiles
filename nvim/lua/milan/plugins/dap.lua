return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "williamboman/mason.nvim",
        "rcarriga/nvim-dap-ui",
        "jay-babu/mason-nvim-dap.nvim",
        "theHamsta/nvim-dap-virtual-text",
        -- maybe once there is chance for connect instead of run adapter
        "leoluz/nvim-dap-go",
        "nvim-neotest/nvim-nio",
    },
    config = function()
        require("mason").setup()
        require("mason-nvim-dap").setup({
            ensure_installed = { "delve" },
        })
        require('dap-go').setup({
            dap_configurations = {
                {
                    type = "go",
                    name = "Attach remote",
                    mode = "remote",
                    request = "attach",
                    substitutePath = {
                        {
                            from = "${workspaceFolder}",
                            to = "nesc-nvs/server",
                        },
                    },
                    connect = {
                        host = "127.0.0.1",
                        port = "30000"
                    }
                },
            },
            delve = {
                port = "30000"
            },
        })
        require("nvim-dap-virtual-text").setup()
        require("dapui").setup( --[[ {
            layouts = {
                {
                    elements = {
                        {
                            id = "breakpoints",
                            size = 0.25
                        },
                        {
                            id = "stacks",
                            size = 0.25
                        },
                        {
                            id = "watches",
                            size = 0.25
                        },
                        {
                            id = "repl",
                            size = 0.25
                        },
                    },
                    position = "left",
                    size = 40
                },
                {
                    elements = {
                        {
                            id = "scopes",
                            size = 0.5
                        },
                        {
                            id = "console",
                            size = 0.10
                        },
                    },
                    position = "bottom",
                    size = 10
                },
            },
        } ]])
        local dap, dapui = require("dap"), require("dapui")
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        -- keymaps
        vim.keymap.set("n", "<F5>", function() dap.continue() end)
        vim.keymap.set("n", "<F6>", function() dap.step_over() end)
        vim.keymap.set("n", "<F7>", function() dap.step_into() end)
        vim.keymap.set("n", "<F8>", function() dap.step_out() end)
        vim.keymap.set("n", "<F10>", function() dap.terminate() end)
        vim.keymap.set("n", "<leader>b", function() dap.toggle_breakpoint() end)
        vim.keymap.set("n", "<leader>B", function()
            dap.toggle_breakpoint(vim.fn.input("Breakpoint condition: "))
        end)
    end
}
