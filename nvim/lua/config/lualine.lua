local M = {}

function M.setup()
  -- local status_ok, gps = pcall(require, "nvim-gps")
  -- if not status_ok then
  --   vim.notify "gps failed"
  --   return
  -- end

  local status_ok, lualine = pcall(require, "lualine")
  if not status_ok then
    vim.notify "lualine failed"
    return
  end

  lualine.setup {
    options = {
      icons_enabled = true,
      section_separators = "",
      component_separators = "",
			globalstatus = false,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = {
        { "filename" },
        -- {
        --   gps.get_location,
        --   cond = gps.is_available,
        --   color = { fg = "#f3ca28" },
        -- },
      },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    -- winbar = {
    --   lualine_a = {},
    --   lualine_b = {},
    --   lualine_c = { "filename" },
    --   lualine_x = {},
    --   lualine_y = {},
    --   lualine_z = {},
    -- },
    --
    -- inactive_winbar = {
    --   lualine_a = {},
    --   lualine_b = {},
    --   lualine_c = { "filename" },
    --   lualine_x = {},
    --   lualine_y = {},
    --   lualine_z = {},
    -- },
    extensions = {},
  }
end

return M
