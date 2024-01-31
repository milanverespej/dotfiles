return {
	{
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        config  = function ()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', function ()
                builtin.find_files({no_ignore=true})
            end,{})
            vim.keymap.set('n', '<C-p>', builtin.git_files, {})
            vim.keymap.set('n', '<leader>F', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>ps', function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") })
            end)
            vim.keymap.set("n", "<leader>mr",
            function ()
                    require("milan.mr_picker").merge_requests(require("telescope.themes").get_dropdown{})
            end)
        end
	}
}
