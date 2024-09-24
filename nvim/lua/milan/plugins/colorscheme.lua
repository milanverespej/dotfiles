return {
    {
        "Mofiqul/vscode.nvim",
        priority = 1000,
        config = function()
            require("vscode").load("dark")
        end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        -- priority = 1000,
        -- config = function()
        --     require("catppuccin").setup({})
        --     vim.cmd("colorscheme catppuccin-frappe")
        -- end
    },
    "AlexvZyl/nordic.nvim",
    { "miikanissi/modus-themes.nvim", priority = 1000 },
    {
        "mcchrish/zenbones.nvim",
        dependencies = { "rktjmp/lush.nvim" }
    },
}
