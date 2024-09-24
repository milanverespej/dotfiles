return {
    {
        "nvim-telescope/telescope.nvim",
        tag          = "0.1.5",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
        },
        config       = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown()
                    },
                },
            })
            pcall(require('telescope').load_extension, 'ui-select')
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", function()
                builtin.find_files({ no_ignore = true })
            end, {})
            vim.keymap.set("n", "<C-p>", builtin.git_files, {})
            vim.keymap.set("n", "<leader>F", builtin.live_grep, {})
            vim.keymap.set("n", "<leader>fw", function()
                local word = vim.fn.expand("<cword>")
                builtin.grep_string({ search = word })
            end)
            vim.keymap.set("n", "<leader>fW", function()
                local word = vim.fn.expand("<cWORD>")
                builtin.grep_string({ search = word })
            end)
            vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find)
            vim.keymap.set("n", "<leader>mr",
                function()
                    require("milan.mr_picker").merge_requests(require("telescope.themes").get_dropdown {})
                end)
        end
    },
}
