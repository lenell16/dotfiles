vim.g.mapleader = " "

-- local nest = require('nest')
--
-- nest.applyKeymaps {
--     -- Remove silent from ; : mapping, so that : shows up in command mode
--     { ';', ':' , options = { silent = false } },
--     { ':', ';' },
-- 		{ '<A-i>', '<CMD>lua require("FTerm").toggle()<cr>' },
--
--     -- Prefix  every nested keymap with <leader>
--     { '<leader>', {
--         -- Prefix every nested keymap with f (meaning actually <leader>f here)
--         { 'f', {
--             { 'f', require('telescope.builtin').find_files },
--             -- This will actually map <leader>fl
--             { 'b', require 'telescope'.extensions.file_browser.file_browser },
--             { 'l', '<cmd>Telescope live_grep<cr>' },
--             -- Prefix every nested keymap with g (meaning actually <leader>fg here)
--             -- { 'g', {
--             --     { 'b', '<cmd>Telescope git_branches<cr>' },
--             --     -- This will actually map <leader>fgc
--             --     { 'c', '<cmd>Telescope git_commits<cr>' },
--             --     { 's', '<cmd>Telescope git_status<cr>' },
--             -- }},
--         }},
--
--     }},
--
--     -- Use insert mode for all nested keymaps
-- 		{ mode = 't', {
-- 			{ '<A-i>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<cr>' },
-- 		}},
-- }

local keymaps = {
	{ ';', ':', opts = { noremap = true, silent = false } },
	{ ':', ';', opts = { noremap = true } },
	{ '<A-i>', require('FTerm').toggle, opts = { noremap = true } },
	{ '<A-i>', require('FTerm').toggle, mode = 't', opts = { noremap = true } },

	{ '<leader>ff', require('telescope.builtin').find_files, opts = { noremap = true } },
	{ '<leader>fb', require('telescope').extensions.file_browser.file_browser, opts = { noremap = true } },
	{ '<leader>fl', require('telescope.builtin').live_grep, opts = { noremap = true } },
}

require('legendary').setup({
	include_builtin = false,
	keymaps = keymaps
})
