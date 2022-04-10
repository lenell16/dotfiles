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
  require("startup").setup(settings)
end

return M
