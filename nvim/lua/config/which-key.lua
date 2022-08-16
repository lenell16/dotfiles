local M = {}

function M.setup()
	import("which-key", function(whichKey)
		import("legendary", function(legendary)
			legendary.setup({
				commands = {
					{ ":Telescope <CR>", description = "Command with argument", unfinished = true },
				},
			})
		end)
		whichKey.setup({
			plugins = {
				marks = false,
				registers = false,
				spelling = {
					enable = false,
				},
				presets = {
					operators = false,
					motions = false,
					text_objects = false,
					windows = false,
					nav = false,
					z = false,
					g = false,
				},
			},
		})
		whichKey.register({
			["<A-i>"] = { '<cmd>lua require("FTerm").toggle()<cr>', "Toggle Terminal" },
			["%"] = "Mathup forward",
			g = {
				["%"] = "Matchup backward",
				c = {
					name = "Comment Linewase",
					c = { "Comment Linewise" },
				},
				b = {
					name = "Comment block",
					c = "Comment block",
				},
			},
			["<leader>"] = {
				name = "+leader",
				w = { "<cmd>update!<CR>", "Save" },
				q = { "<cmd>q!<CR>", "Quit" },

				b = {
					name = "Buffer",
					c = { "<Cmd>bd!<Cr>", "Close current buffer" },
					D = { "<Cmd>%bd|e#|bd#<Cr>", "Delete all buffers" },
					f = { "<cmd>Neotree buffers<cr>", "Buffers" },
				},

				f = {
					name = "File",
					f = { "<cmd>lua require('utils.finder').find_files()<cr>", "Files" },
					e = { "<cmd>Neotree reveal<cr>", "Explorer" },
					w = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Current Buffer" },
					r = { "<cmd>Telescope file_browser<cr>", "Browser" },
					g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
					o = { "<cmd>Telescope oldfiles<cr>", "Old Files" },
					c = { "<cmd>Telescope commands<cr>", "Commands" },
					d = { "<cmd>lua require('utils.finder').find_dotfiles()<cr>", "Dotfiles" },
				},

				c = {
					name = "Change",
					s = { "Colorscheme" },
				},

				n = {
					name = "New",
					f = { "File" },
				},

				z = {
					name = "System",
					s = { "<cmd>PackerSync<cr>", "Sync" },
					c = { "<cmd>PackerCompile<cr>", "Compile" },
					i = { "<cmd>PackerInstall<cr>", "Install" },
					p = { "<cmd>PackerProfile<cr>", "Profile" },
					S = { "<cmd>PackerStatus<cr>", "Status" },
					u = { "<cmd>PackerUpdate<cr>", "Update" },
					r = { "<cmd>Telescope reloader<cr>", "Reload Module" },
				},

				m = {
					function()
						local picked_window_id = require("window-picker").pick_window()
							or vim.api.nvim_get_current_win()
						vim.api.nvim_set_current_win(picked_window_id)
					end,
					"Pick Window",
				},
			},
		})

		whichKey.register(
			{ ["<A-i>"] = { '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', "Toggle Terminal" } },
			{ mode = "t" }
		)
	end)
end

return M
