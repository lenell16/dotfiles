local M = {}

function M.setup()
	import('which-key', function (whichKey)
		whichKey.setup({
			plugins = {
				marks = false,
				registers = false,
				spelling = {
					enable = false,
				},
				presets = {
					operators = false,
					motions = false,
					text_objects = false,
					windows = false,
					nav = false,
					z = false,
					g = false,
				}
			}
		})
	end)
end

return M
