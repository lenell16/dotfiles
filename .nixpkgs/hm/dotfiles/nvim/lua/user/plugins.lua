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
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

-- Install your plugins here
return packer.startup({function(use)
  use 'wbthomason/packer.nvim' -- Have packer manage itself

  use 'nvim-lua/popup.nvim' -- An implementation of the Popup API from vim in Neovim
  use 'nvim-lua/plenary.nvim' -- Useful lua functions used ny lots of plugins

	use 'kyazdani42/nvim-web-devicons'

	use 'LionC/nest.nvim'
	use 'mrjones2014/legendary.nvim'

	use 'windwp/nvim-ts-autotag'
	use 'windwp/nvim-autopairs'
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

	use 'rose-pine/neovim'

	use 'numToStr/Comment.nvim'
  use 'numToStr/FTerm.nvim'

	use 'nvim-lualine/lualine.nvim'

	use 'akinsho/bufferline.nvim'

	use 'norcalli/nvim-colorizer.lua'

	use 'glepnir/dashboard-nvim'

	use 'lewis6991/gitsigns.nvim'

	use 'nvim-telescope/telescope.nvim'
	use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
	use { "nvim-telescope/telescope-file-browser.nvim" }
	use { 'nvim-telescope/telescope-packer.nvim' }
	use { 'nvim-telescope/telescope-github.nvim' }

	use 'folke/which-key.nvim'

	use 'j-hui/fidget.nvim'
	-- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require('packer').sync()
  end
end, config = {
  compile_path = require('packer.util').join_paths(vim.fn.stdpath('config'), 'nixpkgs', 'dotfiles', 'nvim', 'plugin', 'packer_compiled.lua'),
}})
