local M = {}

function M.setup()
  -- local status_ok, bufferline = pcall(require, 'bufferline')
  -- if not status_ok then
  -- 	vim.notify 'bufferline'
  -- 	return
  -- end

  require("bufferline").setup {}

  vim.cmd [[
		nnoremap <silent>[b :BufferLineCycleNext<CR>
		nnoremap <silent>b] :BufferLineCyclePrev<CR>
	]]
end

return M
