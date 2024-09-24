vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- move visual lines up and down side to side like a roller coaster
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- when joining lines keep cursor where it was
vim.keymap.set("n", "J", "mzJ`z")

-- paste but keep og term for pasting
vim.keymap.set("x", "<leader>p", [["_dP]])

-- yank to system clipboard (very useful)
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- quickfix mappings
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
-- loclist mappings
vim.keymap.set("n", "<M-j>", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<M-k>", "<cmd>lprev<CR>zz")
vim.keymap.set("n", "<leader>lt", function()
    local id = vim.fn.getloclist(0, { winid = 0 }).winid
    if id == 0 then
        vim.cmd("lopen")
        return
    end
    vim.cmd("lclose")
end)
-- fill in command to replace the word cursor is in (for a whole file)
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- set file executable from inside the file (no need to exit)
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- run review function alias
--vim.keymap.set("n", "<leader>mr", "<cmd>terminal review<CR>")

local MilanRemap = vim.api.nvim_create_augroup("Milan_remap", { clear = true })
-- remove empty spaces at the end of lines on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = MilanRemap,
    pattern = "*",
    command = [[%s/\s\+$//e]]
})

-- lsp format on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = MilanRemap,
    pattern = "*",
    callback = function()
        vim.lsp.buf.format({
            filter = function(client) return client.name ~= "golangci_lint_ls" end
        })
    end
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = MilanRemap,
    callback = function(ev)
        local opts = { buffer = ev.buf }
        local builtin = require('telescope.builtin')
        vim.keymap.set("n", "gd", builtin.lsp_definitions, opts)
        vim.keymap.set("n", "gD", builtin.lsp_type_definitions, opts)
        vim.keymap.set("n", "gr", function() builtin.lsp_references({ include_declaration = false }) end, opts)
        vim.keymap.set("n", "gi", builtin.lsp_implementations, opts)
        --vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>ws", builtin.lsp_dynamic_workspace_symbols, opts)
        vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols, opts)
        vim.keymap.set("n", "<leader>do", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>df", function() vim.diagnostic.setqflist() end, opts)
        vim.keymap.set("n", "<leader>dl", function() vim.diagnostic.setloclist() end, opts)
        -- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        -- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set({ "i", "s" }, "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    end
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = MilanRemap,
    callback = function()
        vim.highlight.on_yank()
    end,
})
