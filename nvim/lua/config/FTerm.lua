local M = {}

function M.setup()
	local status_ok, FTerm = pcall(require, "FTerm")
	if not status_ok then
		vim.notify("Fterm Failed")
		return
	end

	FTerm.setup({})
	vim.keymap.set("n", "<A-i>", '<CMD>lua require("FTerm").toggle()<CR>')
	vim.keymap.set("t", "<A-i>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
end

return M
