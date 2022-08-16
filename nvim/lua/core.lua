local g = vim.g
local g = vim.g
local opt = vim.opt

-- Remap leader and local leader to <Space>
vim.keymap.set("", "<Space>", "<Nop>", { silent = true })
g.mapleader = " "
g.maplocalleader = ","
-- Disable some builtin vim plugins
local disabled_built_ins = {
	"2html_plugin",
	"getscript",
	"getscriptPlugin",
	"gzip",
	"logipat",
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"matchit",
	"matchparen",
	"tar",
	"tarPlugin",
	"rrhelper",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
	g["loaded_" .. plugin] = 1
end
