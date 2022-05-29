local M = {}

function M.setup()
	local status_ok, FTerm = pcall(require, 'FTerm')
	if not status_ok then
		vim.notify 'Fterm Failed'
		return
	end

	FTerm.setup({
		border = 'double',
		dimensions  = {
				height = 0.9,
				width = 0.9,
		},
	})
end

return M
