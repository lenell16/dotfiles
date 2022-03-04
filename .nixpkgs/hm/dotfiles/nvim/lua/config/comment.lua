local M = {}

function M.setup()
	local status_ok, comment = pcall(require, 'Comment')
	if not status_ok then
		vim.notify 'comment failed'
		return
	end

	comment.setup()
end

return M
