local M = {}

function M.setup()
	local status_ok, rose_pine = pcall(require, 'rose-pine')
	if not status_ok then
		vim.notify "rose-pine failed"
		return
	end

	rose_pine.setup({
		dark_variant = 'moon'
	})

	vim.cmd[[colorscheme rose-pine]]
end

return M
