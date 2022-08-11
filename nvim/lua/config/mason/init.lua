local M = {}

function M.setup()
	import("mason", function (mason)
		mason.setup()
	end)
	import("mason-lspconfig",function (masonLspconfig)
		masonLspconfig.setup({
			ensure_installed = { "tsserver", "tailwindcss", "taplo", "rnix" },
		})

		import("lspconfig", function(lspconfig)
			local config = require("config.mason.shared.config")
		masonLspconfig.setup_handler({
			function(server_name)
				lspconfig[server_name].setup(config)
			end
		})
		end)
	end)
end
