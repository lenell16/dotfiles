local M = {}

function M.setup()
	local shared = require("config.mason.shared")
	shared.setup_diagnostics()
	shared.setup_float_handlers()

	local mason = nil
	local masonLsp = nil
	local lspConf = nil
	import("mason", function(_)
		mason = _
	end)
	import("mason-lspconfig", function(_)
		masonLsp = _
	end)
	import("lspconfig", function(_)
		lspConf = _
	end)
	assert(mason)
	assert(masonLsp)
	assert(lspConf)

	mason.setup()

	masonLsp.setup({
		ensure_installed = { "tsserver", "tailwindcss", "taplo", "rnix", "sumneko_lua" },
	})

	local config = shared.get_config()
	masonLsp.setup_handlers({
		function(server_name)
			lspConf[server_name].setup(config)
		end,
		["tsserver"] = function()
			import("typescript", function(ts_utils)
				ts_utils.setup({
					server = config,
				})
			end)
		end,
		["sumneko_lua"] = function()
			import("lua-dev", function(luadev)
				local luaConfig = luadev.setup()
				lspConf.sumneko_lua.setup(luaConfig)
			end)
		end,
	})
end

return M
