local M = {}

function M.setup()
	local packer_bootstrap = false

	local config = {
		profile = {
			enable = true,
			threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
		},
		display = {
			open_fn = function()
				return require("packer.util").float({
					border = "rounded",
				})
			end,
		},
	}

	local function packer_init()
		local fn = vim.fn

		-- Automatically install packer
		local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
		if fn.empty(fn.glob(install_path)) > 0 then
			packer_bootstrap = fn.system({
				"git",
				"clone",
				"--depth",
				"1",
				"https://github.com/wbthomason/packer.nvim",
				install_path,
			})
			print("Installing packer close and reopen Neovim...")
			vim.cmd([[packadd packer.nvim]])
		end

		-- Autocommand that reloads neovim whenever you save the plugins.lua file
		vim.cmd([[
			augroup packer_user_config
				autocmd!
				autocmd BufWritePost plugins.lua source <afile> | PackerCompile
			augroup end
		]])
	end

	local function plugins(use)
		use({ "wbthomason/packer.nvim" })

		use({ "nvim-lua/plenary.nvim", module = "plenary" })

		use({
			"EdenEast/nightfox.nvim",
			config = function()
				vim.cmd([[colorscheme nightfox]])
			end,
		})

		use({ "onsails/lspkind-nvim" })

		-- use 'LionC/nest.nvim'
		-- use 'mrjones2014/legendary.nvim
		use({
			"startup-nvim/startup.nvim",
			requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
			config = function()
				require("config.startup").setup()
			end,
		})
		-- Notification
		use({
			"rcarriga/nvim-notify",
			event = "VimEnter",
			config = function()
				vim.notify = require("notify")
			end,
		})

		use({
			"lewis6991/gitsigns.nvim",
			event = "BufReadPre",
			wants = "plenary.nvim",
			requires = { "nvim-lua/plenary.nvim" },
			config = function()
				require("config.gitsigns").setup()
			end,
		})

		use({
			"folke/which-key.nvim",
			event = "VimEnter",
			config = function()
				require("config.whichkey").setup()
			end,
		})

		-- -- IndentLine
		-- use {
		--   "lukas-reineke/indent-blankline.nvim",
		--   event = "BufReadPre",
		--   config = function()
		--     require("config.indentblankline").setup()
		--   end,
		-- }

		-- Better icons
		use({
			"kyazdani42/nvim-web-devicons",
			module = "nvim-web-devicons",
			config = function()
				require("nvim-web-devicons").setup({ default = true })
			end,
		})

		use({
			"numToStr/Comment.nvim",
			opt = true,
			keys = { "gc", "gcc", "gbc" },
			config = function()
				require("Comment").setup({})
			end,
		})

		-- Motions
		-- use { "andymass/vim-matchup", event = "CursorMoved" }
		-- use { "wellle/targets.vim", event = "CursorMoved" }
		-- use { "unblevable/quick-scope", event = "CursorMoved", disable = false }
		use({ "chaoren/vim-wordmotion" })
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
		-- -- Easy motion
		-- use {
		--   "ggandor/lightspeed.nvim",
		--   keys = { "s", "S", "f", "F", "t", "T" },
		--   config = function()
		--     require("lightspeed").setup {}
		--   end,
		-- }

		-- Status line
		use({
			"nvim-lualine/lualine.nvim",
			after = "nvim-treesitter",
			config = function()
				require("config.lualine").setup()
			end,
			requires = { "nvim-web-devicons" },
		})

		-- Treesitter
		use({
			"nvim-treesitter/nvim-treesitter",
			opt = true,
			event = "BufRead",
			run = ":TSUpdate",
			config = function()
				require("config.treesitter").setup()
			end,
			requires = {
				{ "nvim-treesitter/nvim-treesitter-textobjects" },
			},
		})

		use({
			"nvim-telescope/telescope.nvim",
			opt = true,
			config = function()
				require("config.telescope").setup()
			end,
			cmd = { "Telescope" },
			module = "telescope",
			keys = { "<leader>f", "<leader>p", "<leader>z" },
			wants = {
				"plenary.nvim",
				"popup.nvim",
				"telescope-fzf-native.nvim",
				"telescope-project.nvim",
				"telescope-repo.nvim",
				"telescope-file-browser.nvim",
				"project.nvim",
				"trouble.nvim",
			},
			requires = {
				"nvim-lua/popup.nvim",
				"nvim-lua/plenary.nvim",
				{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
				"nvim-telescope/telescope-project.nvim",
				"cljoly/telescope-repo.nvim",
				"nvim-telescope/telescope-file-browser.nvim",
				{
					"ahmedkhalf/project.nvim",
					config = function()
						require("project_nvim").setup({})
					end,
				},
			},
		})

		use({
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v2.x",
			requires = {
				"nvim-lua/plenary.nvim",
				"kyazdani42/nvim-web-devicons",
				"MunifTanjim/nui.nvim",
{
        -- only needed if you want to use the commands with "_with_window_picker" suffix
        's1n7ax/nvim-window-picker',
        tag = "v1.*",
        config = function()
          require'window-picker'.setup({
            autoselect_one = true,
            include_current = false,
            filter_rules = {
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { 'neo-tree', "neo-tree-popup", "notify", "quickfix" },

                -- if the buffer type is one of following, the window will be ignored
                buftype = { 'terminal' },
              },
            },
            other_win_hl_color = '#e35e4f',
          })
        end,
      },
			},
			config = function()
				require("config.neo-tree").setup()
			end,
		})
  --
		-- -- Buffer line
		-- use({
		-- 	"akinsho/bufferline.nvim",
		-- 	-- event = "BufReadPre",
		-- 	requires = "nvim-web-devicons",
		-- 	tag = "*",
		-- 	config = function()
		-- 		vim.opt.termguicolors = true
		-- 		require("bufferline").setup({})
		-- 		-- require("config.bufferline").setup()
		-- 	end,
		-- })

		-- User interface
		use({
			"stevearc/dressing.nvim",
			event = "BufEnter",
			config = function()
				require("dressing").setup({
					select = {
						backend = { "telescope", "fzf", "builtin" },
					},
				})
			end,
		})

		use({
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			opt = true,
			config = function()
				require("config.cmp").setup()
			end,
			wants = { "LuaSnip" },
			requires = {
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-nvim-lua",
				"ray-x/cmp-treesitter",
				"hrsh7th/cmp-cmdline",
				"saadparwaiz1/cmp_luasnip",
				-- "hrsh7th/cmp-nvim-lsp",
				{
					"L3MON4D3/LuaSnip",
					wants = "friendly-snippets",
					config = function()
						require("config.luasnip").setup()
					end,
				},
				"rafamadriz/friendly-snippets",
			},
		})

		--Auto pairs
		use({
			"windwp/nvim-autopairs",
			wants = "nvim-treesitter",
			module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
			config = function()
				require("config.autopairs").setup()
			end,
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

		-- End wise
		use({
			"RRethy/nvim-treesitter-endwise",
			wants = "nvim-treesitter",
			event = "InsertEnter",
		})

		-- use({
		-- 	"neovim/nvim-lspconfig",
		-- 	opt = true,
		-- 	event = "BufReadPre",
		-- 	wants = {
		-- 		"nvim-lsp-installer",
		-- 		"lsp_signature.nvim",
		-- 		"cmp-nvim-lsp",
		-- 		"lua-dev.nvim",
		-- 		"vim-illuminate",
		-- 		"null-ls.nvim",
		-- 		"schemastore.nvim",
		-- 		"nvim-lsp-ts-utils",
		-- 	},
		-- 	config = function()
		-- 		require("config.lsp").setup()
		-- 	end,
		-- 	requires = {
		-- 		"williamboman/nvim-lsp-installer",
		-- 		"ray-x/lsp_signature.nvim",
		-- 		"folke/lua-dev.nvim",
		-- 		"RRethy/vim-illuminate",
		-- 		"jose-elias-alvarez/null-ls.nvim",
		-- 		{
		-- 			"j-hui/fidget.nvim",
		-- 			config = function()
		-- 				require("fidget").setup({})
		-- 			end,
		-- 		},
		-- 		"b0o/schemastore.nvim",
		-- 		"jose-elias-alvarez/nvim-lsp-ts-utils",
		-- 	},
		-- })

		-- trouble.nvim
		use({
			"folke/trouble.nvim",
			event = "BufReadPre",
			wants = "nvim-web-devicons",
			cmd = { "TroubleToggle", "Trouble" },
			config = function()
				require("trouble").setup({
					use_diagnostic_signs = true,
				})
			end,
		})

		-- use {
		-- 	'numToStr/FTerm.nvim',
		-- 	config = function()
		-- 		require('config.FTerm').setup()
		-- 	end,
		-- }

		-- use { 'nvim-telescope/telescope-packer.nvim' }
		-- use { 'nvim-telescope/telescope-github.nvim' }
		-- use 'nvim-telescope/telescope-symbols.nvim'
		-- use 'jvgrootveld/telescope-zoxide'

		if packer_bootstrap then
			print("Restart Neovim required after installation!")
			require("packer").sync()
		end
	end

	-- Init and start packer
	packer_init() -- Use a protected call so we don't error out on first use
	local status_ok, packer = pcall(require, "packer")
	if not status_ok then
		vim.notify("packer failed")
		return
	end

	packer.init(config)
	packer.startup(plugins)
end

return M
