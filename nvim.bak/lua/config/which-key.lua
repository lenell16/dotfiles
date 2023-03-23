
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
