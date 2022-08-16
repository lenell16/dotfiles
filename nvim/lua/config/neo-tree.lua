local M = {}

-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

function M.setup()
	import("neo-tree", function(neotree)
		neotree.setup({
			close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
			filesystem = {
				follow_current_file = true,
				filtered_items = {
					visible = true,
					-- hide_dotfiles = false,
					-- hide_gitignored = false,
					never_show = {
						".DS_Store",
						"thumbs.db",
					},
				},
				hijack_netrw_behavior = "open_current",
			},
			source_selector = {
				winbar = true,
			},
		})
	end)
end

return M
