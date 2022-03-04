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
				return require("packer.util").float {
					border = "rounded"
				}
			end,
		},
	}

	local function packer_init()
		local fn = vim.fn

		-- Automatically install packer
		local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
		if fn.empty(fn.glob(install_path)) > 0 then
			PACKER_BOOTSTRAP = fn.system {
				'git',
				'clone',
				'--depth',
				'1',
				'https://github.com/wbthomason/packer.nvim',
				install_path,
			}
			print 'Installing packer close and reopen Neovim...'
			vim.cmd [[packadd packer.nvim]]
		end

		-- Autocommand that reloads neovim whenever you save the plugins.lua file
		vim.cmd [[
			augroup packer_user_config
				autocmd!
				autocmd BufWritePost plugins.lua source <afile> | PackerCompile
			augroup end
		]]
	end

	local function plugins(use)
		use { 'wbthomason/packer.nvim' }

		use { 'nvim-lua/popup.nvim' }
    use { "nvim-lua/plenary.nvim", module = "plenary" }

		-- use 'kyazdani42/nvim-web-devicons'

		-- use 'LionC/nest.nvim'
		-- use 'mrjones2014/legendary.nvim'

		use 'windwp/nvim-ts-autotag'
		use 'windwp/nvim-autopairs'

		use {
			'rose-pine/neovim',
			config = function()
				require('config.rose-pine').setup()
			end,
		}

		use {
      "folke/which-key.nvim",
			event = "VimEnter",
      config = function()
        require("config.whichkey").setup()
      end,
    }

		-- IndentLine
		use {
			"lukas-reineke/indent-blankline.nvim",
			event = "BufReadPre",
			config = function()
				require("config.indentblankline").setup()
			end,
		}

		-- Better icons
		use {
			"kyazdani42/nvim-web-devicons",
			module = "nvim-web-devicons",
			config = function()
				require("nvim-web-devicons").setup { default = true }
			end,
		}

		use {
			'numToStr/Comment.nvim',
			opt = true,
      keys = { "gc", "gcc", "gbc" },
			config = function()
				require('config.comment').setup()
			end,
		}
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
    use {
      "nvim-lualine/lualine.nvim",
      event = "VimEnter",
      config = function()
        require("config.lualine").setup()
      end,
      requires = { "nvim-web-devicons" },
    }

    -- Treesitter
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        require("config.treesitter").setup()
      end,
    }
    use {
      "SmiteshP/nvim-gps",
      requires = "nvim-treesitter/nvim-treesitter",
      module = "nvim-gps",
      config = function()
        require("nvim-gps").setup()
      end,
    }

		-- use {
		-- 	'numToStr/FTerm.nvim',
		-- 	config = function()
		-- 		require('config.FTerm').setup()
		-- 	end,
		-- }

		-- use {
		-- 	'nvim-lualine/lualine.nvim',
		-- 	config = function()
		-- 		require('config.lualine').setup()
		-- 	end,
		-- }

		-- use {
		-- 	'akinsho/bufferline.nvim',
		-- 	config = function()
		-- 		require('config.bufferline').setup()
		-- 	end,
		-- }

		-- use {
		-- 	'norcalli/nvim-colorizer.lua',
		-- 	config = function()
		-- 		require('config.nvim-colorizer').setup()
		-- 	end,
		-- }

		-- use {
		-- 	'goolord/alpha-nvim',
		-- 	config = function()
		-- 		require("user.config.alpha").setup()
		-- 	end,
		-- }

		-- use {
		-- 	'lewis6991/gitsigns.nvim',
		-- 	config = function()
		-- 		require('config.gitsigns').setup()
		-- 	end,
		-- }

		-- use 'nvim-telescope/telescope.nvim'
		-- use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
		-- use { "nvim-telescope/telescope-file-browser.nvim" }
		-- use { 'nvim-telescope/telescope-packer.nvim' }
		-- use { 'nvim-telescope/telescope-github.nvim' }
		-- use 'nvim-telescope/telescope-symbols.nvim'
		-- use 'jvgrootveld/telescope-zoxide'
		-- use 'nvim-telescope/telescope-project.nvim'

		-- use {
		-- 	'j-hui/fidget.nvim',
		-- 	config = function()
		-- 		require('config.fidget').setup()
		-- 	end,
		-- }

		-- use 'neovim/nvim-lspconfig'

		-- use 'jose-elias-alvarez/null-ls.nvim'
		-- use 'stevearc/dressing.nvim'

		if packer_bootstrap then
			print 'Restart Neovim required after installation!'
			require('packer').sync()
		end
	end

	-- Use a protected call so we don't error out on first use
	local status_ok, packer = pcall(require, 'packer')
	if not status_ok then
		vim.notify 'packer failed'
		return
	end

	packer.init(config)
	packer.startup(plugins)
end

return M
