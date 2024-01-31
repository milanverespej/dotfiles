-- local plugin="rebelot/kanagawa.nvim"
-- local color="kanagawa"
-- local theme="dragon"
-- local plugin="sainnhe/everforest"
-- local color="everforest"
-- local theme=""
local plugin="arcticicestudio/nord-vim"
local color="nord"
return {
    {
        plugin,
        name = color,
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000,
        config = function()
            vim.cmd("colorscheme nord")
        end
    }
}
