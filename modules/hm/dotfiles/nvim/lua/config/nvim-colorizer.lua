local M = {}

function M.setup()
	local status_ok, colorizer = pcall(require, 'colorizer')
	if not status_ok then
		vim.notify 'colorizer'
		return
	end

	colorizer.setup()
end

return M
