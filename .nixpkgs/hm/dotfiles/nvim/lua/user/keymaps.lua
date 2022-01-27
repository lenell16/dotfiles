vim.g.mapleader = " "

local nest = require('nest')

nest.applyKeymaps {
    -- Remove silent from ; : mapping, so that : shows up in command mode
    { ';', ':' , options = { silent = false } },
    { ':', ';' },
		{ '<A-i>', '<CMD>lua require("FTerm").toggle()<cr>' },

    -- Prefix  every nested keymap with <leader>
    { '<leader>', {
        -- Prefix every nested keymap with f (meaning actually <leader>f here)
        { 'f', {
            { 'f', require('telescope.builtin').find_files },
            -- This will actually map <leader>fl
            { 'b', require 'telescope'.extensions.file_browser.file_browser },
            { 'l', '<cmd>Telescope live_grep<cr>' },
            -- Prefix every nested keymap with g (meaning actually <leader>fg here)
            -- { 'g', {
            --     { 'b', '<cmd>Telescope git_branches<cr>' },
            --     -- This will actually map <leader>fgc
            --     { 'c', '<cmd>Telescope git_commits<cr>' },
            --     { 's', '<cmd>Telescope git_status<cr>' },
            -- }},
        }},

    }},

    -- Use insert mode for all nested keymaps
		{ mode = 't', {
			{ '<A-i>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<cr>' },
		}},
}
