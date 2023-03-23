




		use({
			"startup-nvim/startup.nvim",
			requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
			config = function()
				require("config.startup").setup()
			end,
		})

		use({
			"numToStr/FTerm.nvim",
			opt = true,
			module = "FTerm",
			config = function()
				require("config.FTerm").setup()
			end,
		})

		use({ "mrjones2014/legendary.nvim", opt = true })

		use({
			"numToStr/Comment.nvim",
			opt = true,
			keys = { "gc", "gcc", "gbc" },
			config = function()
				require("Comment").setup({})
			end,
		})

		use({
			"kylechui/nvim-surround",
			event = "BufRead",
			config = function()
				require("nvim-surround").setup({
					-- Configuration here, or leave empty to use defaults
				})
			end,
		})

		-- Motions
		-- use { "wellle/targets.vim", event = "CursorMoved" }
		-- use { "unblevable/quick-scope", event = "CursorMoved", disable = false }
		--
		-- -- Easy hopping
		-- use {
		--   "phaazon/hop.nvim",
		--   cmd = { "HopWord", "HopChar1" },
		--   config = function()
		--     require("hop").setup {}
		--   end,
		-- }
		--

		--Auto pairs
		use({
			"windwp/nvim-autopairs",
			wants = "nvim-treesitter",
			module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
			config = function()
				require("config.autopairs").setup()
			end,
		})
		use({
			"andymass/vim-matchup",
			wants = "nvim-treesitter",
			event = "InsertEnter",
		})

		-- Auto tag
		-- use {
		--   "windwp/nvim-ts-autotag",
		--   wants = "nvim-treesitter",
		--   event = "InsertEnter",
		--   config = function()
		--     require("nvim-ts-autotag").setup { enable = true }
		--   end,
		-- }







				{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
				"cljoly/telescope-repo.nvim",
				"nvim-telescope/telescope-file-browser.nvim",


				{
					-- only needed if you want to use the commands with "_with_window_picker" suffix
					"s1n7ax/nvim-window-picker",
					tag = "v1.*",
					config = function()
						require("window-picker").setup({
							autoselect_one = true,
							include_current = false,
							filter_rules = {
								-- filter using buffer options
								bo = {
									-- if the file type is one of following, the window will be ignored
									filetype = { "neo-tree", "neo-tree-popup", "notify", "quickfix" },
									-- if the buffer type is one of following, the window will be ignored
									buftype = { "terminal" },
								},
							},
							other_win_hl_color = "#e35e4f",
						})
					end,
				},
			},


 {
				"hrsh7th/cmp-nvim-lua",
				"ray-x/cmp-treesitter",
				"hrsh7th/cmp-cmdline",
			},