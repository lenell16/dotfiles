local M = {}

function M.setup()
	local status_ok, gitsigns = pcall(require, "gitsigns")
	if not status_ok then
		vim.notify("gitsigns failed")
		return
	end

	gitsigns.setup({
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "契" },
			topdelete = { text = "契" },
			changedelete = { text = "▎" },
		},
	})
end

return M
