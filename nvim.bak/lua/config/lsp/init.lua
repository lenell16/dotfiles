
  tsserver = {
    root_dir = nvim_lsp.util.root_pattern "package.json",
  },
  vimls = {},
  denols = {
    root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
  },
}

local lsp_signature = require "lsp_signature"
lsp_signature.setup {
  bind = true,
  handler_opts = {
    border = "rounded",
  },
}

