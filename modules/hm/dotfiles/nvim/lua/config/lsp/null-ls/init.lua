local M = {}

local nls = require "null-ls"
local nls_utils = require "null-ls.utils"
local b = nls.builtins

local with_diagnostics_code = function(builtin)
  return builtin.with {
    diagnostics_format = "#{m} [#{c}]",
  }
end

local with_root_file = function(builtin, file)
  return builtin.with {
    condition = function(utils)
      return utils.root_has_file(file)
    end,
  }
end
local with_root_matches = function(builtin, file)
  return builtin.with {
    condition = function(utils)
      return utils.root_matches(file)
    end,
  }
end

local sources = {
  -- formatting
  with_root_matches(b.formatting.prettier, "package.json"),
  -- b.formatting.prettierd,
  b.formatting.shfmt,
  b.formatting.fixjson,
  b.formatting.black.with { extra_args = { "--fast" } },
  -- b.formatting.isort,
  b.formatting.stylua,
  -- with_root_file(b.formatting.stylua, "stylua.toml"),

  -- diagnostics
  -- b.diagnostics.write_good,
  -- b.diagnostics.markdownlint,
  with_root_matches(b.diagnostics.eslint_d, "package.json"),
  -- b.diagnostics.flake8,
  with_root_matches(b.diagnostics.tsc, "package.json"),
  -- with_root_file(b.diagnostics.selene, "selene.toml"),
  b.diagnostics.selene,
  with_diagnostics_code(b.diagnostics.shellcheck),

  -- code actions
  with_root_matches(b.code_actions.eslint_d, "package.json"),
  b.code_actions.gitsigns,
  b.code_actions.gitrebase,

  -- hover
  b.hover.dictionary,
}

function M.setup(opts)
  nls.setup {
    -- debug = true,
    debounce = 150,
    save_after_format = false,
    sources = sources,
    on_attach = opts.on_attach,
    root_dir = nls_utils.root_pattern ".git",
  }
end

return M
