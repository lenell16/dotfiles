local M = {}

-- Find a file either using git files or search the filesystem.
function M.find_files()
  local opts = {}
  local telescope = require "telescope.builtin"

  local ok = pcall(telescope.git_files, opts)
  if not ok then
    telescope.find_files(opts)
  end
end

-- Find dotfiles
function M.find_dotfiles()
  require("telescope.builtin").find_files {
    prompt_title = "<Dotfiles>",
    cwd = "$HOME/.nixpkgs/",
  }
end

return M
