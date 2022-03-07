local api = vim.api
local g = vim.g
local opt = vim.opt

-- Remap leader and local leader to <Space>
api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
g.mapleader = " "
g.maplocalleader = " "

	-- opt.undofile = true
	-- opt.signcolumn = "yes"
opt.backup = false
opt.clipboard = "unnamedplus"
opt.cmdheight = 2
opt.cursorline = true
opt.fileencoding = "utf-8"
opt.hlsearch = true
opt.ignorecase = true
opt.mouse = "a"
opt.number = true
opt.pumheight = 10
opt.relativenumber = true
opt.scrolloff = 8
opt.shiftwidth = 2
opt.sidescrolloff = 8
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.tabstop = 2
opt.termguicolors = true
opt.timeoutlen = 300
opt.updatetime = 250
opt.wrap = false
opt.writebackup = false


opt.shortmess:append "c"
opt.whichwrap:append "<>[]hl"
opt.iskeyword:append "-"

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

-- Treesitter based folding
vim.cmd [[
  set foldlevel=20
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()
]]