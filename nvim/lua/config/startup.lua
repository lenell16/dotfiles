local M = {}

function M.setup()
  local settings = require "startup.themes.dashboard"
  settings.body.content = {
    { " Find File", "Telescope find_files", "<leader>ff" },
    { " Find Word", "Telescope live_grep", "<leader>fg" },
    { " Recent Files", "Telescope oldfiles", "<leader>fo" },
    { " File Browser", "Telescope file_browser", "<leader>fr" },
    { " Colorschemes", "Telescope colorscheme", "<leader>cs" },
    { " New File", "lua require'startup'.new_file()", "<leader>nf" },
  }
  vim.g.startup_disable_on_startup = true
  require("startup").setup(settings)
  vim.cmd [[autocmd VimEnter * lua if vim.fn.argc() == 0 then require("startup").display() end]]
  vim.cmd [[autocmd VimResized * lua if vim.bo.ft == "startup" then require"startup".redraw() end
        autocmd BufEnter * lua if vim.bo.ft == "startup" then require"startup".redraw() end]]
end

return M
