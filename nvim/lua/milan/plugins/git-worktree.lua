return {
    "ThePrimeagen/git-worktree.nvim",
    config = function ()
        require("git-worktree").setup()
        require("telescope").load_extension("git_worktree")

        vim.keymap.set("n", "<leader>gt", require("telescope").extensions.git_worktree.git_worktrees)
        vim.keymap.set("n", "<leader>gct", require("telescope").extensions.git_worktree.create_git_worktree)
    end
}
