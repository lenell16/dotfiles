return {
	{
		"nvim-treesitter",
		dependencies = {
			{
				"axelvc/template-string.nvim",
				event = { "InsertEnter" },
				opts = {
					filetypes = { "typescript", "javascript", "typescript", "javascriptreact" },
					jsx_brackets = true,
				},
				config = function(_, opts)
					require("template-string").setup(opts)
				end,
			},
			{ "RRethy/nvim-treesitter-endwise", event = { "InsertEnter" } },
		},
		opts = {
			endwise = {
				enable = true,
			},
		},
	},
}
