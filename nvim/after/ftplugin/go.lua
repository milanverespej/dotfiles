vim.opt.colorcolumn = "130"

vim.keymap.set("n", "<leader>ve", function()
        local exportedName = vim.fn.expand("<cword>"):gsub("^%l", string.upper)
        vim.lsp.buf.rename(exportedName)
    end,
    { buffer = true })
local MilanGoGroup = vim.api.nvim_create_augroup("MilanGo", {})
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = MilanGoGroup,
    pattern = "*.go",
    callback = vim.lsp.buf.format
})

local current_func = function()
    local node = vim.treesitter.get_node()
    while node do
        local node_type = node:type()
        if node_type == "function_declaration" or node_type == "method_declaration" then
            local name_type
            if node_type == "function_declaration" then
                name_type = "identifier"
            else
                name_type = "field_identifier"
            end
            for child in node:iter_children() do
                if child:type() == name_type then
                    return vim.treesitter.get_node_text(child, vim.api.nvim_get_current_buf())
                end
            end
            break
        end
        node = node:parent()
    end
    return ""
end

local genTests = function()
    local func_name = current_func()
    if func_name == "" then
        vim.notify("not in function", "warning", {})
        return
    end
    local args = { "gotests" }
    table.insert(args, "-template")
    table.insert(args, "testify")
    table.insert(args, "-only")
    table.insert(args, func_name)
    local gofile = vim.fn.expand("%")
    table.insert(args, "-w")
    table.insert(args, gofile)
    print(vim.inspect(args))
    vim.fn.jobstart(args, {
        stdout_buffered = true,
        on_stdout = function(_, data, _)
            print("unit tests generate " .. vim.inspect(data))
        end,
    })
end

vim.api.nvim_create_user_command("GoModTidy", "execute('!go mod tidy') | LspRestart", {})
vim.api.nvim_create_user_command("GoGenTest", genTests, {})
