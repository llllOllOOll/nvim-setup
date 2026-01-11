local M = {
	completion_enabled = false,
}

function M.toggle_completion()
	M.completion_enabled = not M.completion_enabled
	local status = M.completion_enabled and "enabled" or "disabled"
	vim.notify("Completion " .. status, vim.log.levels.INFO)
	
	-- Trigger completion setup to reconfigure
	vim.api.nvim_exec_autocmds("User", {
		pattern = "CompletionToggled",
	})
end

function M.is_completion_enabled()
	return M.completion_enabled
end

function M.setup()
	-- Create user autocmd for completion changes
	vim.api.nvim_create_augroup("CompletionToggle", { clear = true })
end

-- Initialize setup when module is loaded
M.setup()

return M