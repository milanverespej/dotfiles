local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function fetch_merge_requests()
    local handle = io.popen("glab mr list | tail +2 | awk NF | awk '{$2=\"\"; print $0}'")
	if (handle == nil) then
		print('failed running command')
		return
	end

	local output = handle:read("*a")

	handle:close()

    local merge_requests = {}
    for mr in output:gmatch("[^\n]+") do
        local entry = {mr:match("([^%s]+)%s(.*)")}
        table.insert(entry, entry[2]:match("%(([^%(%)]+)%)$"))
        table.insert(merge_requests, entry)
    end
	return merge_requests
end

local function merge_requests(opts)
    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "Merge Requests",
        finder = finders.new_table({
            results = fetch_merge_requests(),
            entry_maker = function (entry)
               return {
                   value = entry,
                   display = entry[1] .. entry[2],
                   ordinal = entry[1]
               }
            end
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()

        vim.cmd("tabnew")
        vim.cmd("Git worktree add --checkout --guess-remote ../reviews/reponame/test " .. selection.value[3])
        vim.cmd("tcd ../reviews/reponame/test")
        require("gitlab").review()
      end)
      return true
    end,
    }):find()
end

return {
    merge_requests = merge_requests,
}
