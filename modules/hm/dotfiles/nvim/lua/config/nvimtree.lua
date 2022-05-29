local M = {}

function M.setup()
  local status_ok, nvimtree = pcall(require, 'nvim-tree')
	if not status_ok then
		vim.notify 'nvim-tree failed'
		return
	end

  nvimtree.setup {
    disable_netrw = true,
    hijack_netrw = true,
    view = {
      number = true,
      relativenumber = true,
    },
    filters = {
      custom = { ".git" },
    },
    update_cwd = true,
    update_focused_file = {
      enable = true,
      update_cwd = true,
    },
  }

  vim.g.nvim_tree_respect_buf_cwd = 1
end

return M