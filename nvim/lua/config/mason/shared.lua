local M = {}

function M.setup_float_handlers()
	-- LSP handlers configuration
	local lsp = {
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
		},
	}

	-- Hover configuration
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, lsp.float)

	-- Signature help configuration
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, lsp.float)
end

-- return M
function M.setup_diagnostics()
	-- Diagnostic signs
	local diagnostic_signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}
	for _, sign in ipairs(diagnostic_signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
	end

	-- Diagnostic configuration
	vim.diagnostic.config({
		-- virtual_text = true,
		virtual_text = { spacing = 4, prefix = "●" },
		underline = true,
		update_in_insert = false,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
		},
	})
end

function M.get_config()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	import("cmp_nvim_lsp", function(cmpLsp)
		capabilities = cmpLsp.update_capabilities(capabilities)
	end)
	local config = {
		on_attach = function(client, bufnr)
			local function buf_set_keymap(mode, lhf, rhf, extraopts)
				local bufopts = { noremap = true, silent = true, buffer = bufnr }
				local opts = vim.tbl_deep_extend("force", {}, bufopts, extraopts)
				vim.keymap.set(mode, lhf, rhf, opts)
			end

			-- Mappings.
			-- See `:help vim.lsp.*` for documentation on any of the below functions
			buf_set_keymap("n", "gD", vim.lsp.buf.declaration, { desc = "Declaration" })
			buf_set_keymap("n", "gd", vim.lsp.buf.definition, { desc = "Definition" })
			buf_set_keymap("n", "gi", vim.lsp.buf.implementation, { desc = "Implementation" })
			buf_set_keymap("n", "gr", vim.lsp.buf.references, { desc = "" })
			buf_set_keymap("n", "K", vim.lsp.buf.hover, { desc = "" })
			buf_set_keymap("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "" })
			buf_set_keymap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Add Folder" })
			buf_set_keymap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove Folder" })
			buf_set_keymap("n", "<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, { desc = "List Folders" })

			buf_set_keymap("n", "<leader>e", vim.diagnostic.open_float, opts)
			buf_set_keymap("n", "[d", vim.diagnostic.goto_prev, opts)
			buf_set_keymap("n", "]d", vim.diagnostic.goto_next, opts)
			buf_set_keymap("n", "<localleader>q", vim.diagnostic.setloclist, opts)

			buf_set_keymap("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
			buf_set_keymap("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
			buf_set_keymap("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
			buf_set_keymap("n", "<leader>f", vim.lsp.buf.formatting, bufopts)
		end,
		capabilities = capabilities,
	}
	return config
end

return M
