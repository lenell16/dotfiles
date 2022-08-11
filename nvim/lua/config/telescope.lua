local M = {}

function M.setup()
	import("telescope", function(telescope)
		local actions = require("telescope.actions")

		-- Custom actions
		local transform_mod = require("telescope.actions.mt").transform_mod
		local nvb_actions = transform_mod({
			file_path = function(prompt_bufnr)
				-- Get selected entry and the file full path
				local content = require("telescope.actions.state").get_selected_entry()
				local full_path = content.cwd .. require("plenary.path").path.sep .. content.value

				-- Yank the path to unnamed and clipboard registers
				vim.fn.setreg('"', full_path)
				vim.fn.setreg("+", full_path)

				-- Close the popup
				require("utils").info("File path is yanked ")
				require("telescope.actions").close(prompt_bufnr)
			end,
		})
		-- Custom previewer
		local previewers = require("telescope.previewers")
		local Job = require("plenary.job")
		local preview_maker = function(filepath, bufnr, opts)
			filepath = vim.fn.expand(filepath)
			Job:new({
				command = "file",
				args = { "--mime-type", "-b", filepath },
				on_exit = function(j)
					local mime_type = vim.split(j:result()[1], "/")[1]

					if mime_type == "text" then
						-- Check file size
						vim.loop.fs_stat(filepath, function(_, stat)
							if not stat then
								return
							end
							if stat.size > 500000 then
								return
							else
								previewers.buffer_previewer_maker(filepath, bufnr, opts)
							end
						end)
					else
						vim.schedule(function()
							vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY FILE" })
						end)
					end
				end,
			}):sync()
		end

		telescope.setup({
			defaults = {
				buffer_previewer_maker = preview_maker,
				mappings = {
					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-n>"] = actions.cycle_history_next,
						["<C-p>"] = actions.cycle_history_prev,
					},
				},
			},
			pickers = {
				find_files = {
					-- theme = "ivy",
					mappings = {
						n = {
							["y"] = nvb_actions.file_path,
						},
						i = {
							["<C-y>"] = nvb_actions.file_path,
						},
					},
				},
				git_files = {
					-- theme = "dropdown",
					mappings = {
						n = {
							["y"] = nvb_actions.file_path,
						},
						i = {
							["<C-y>"] = nvb_actions.file_path,
						},
					},
				},
			},
			extensions = {
				repo = {
					list = {
						search_dirs = {
							"~/Developer",
						},
					},
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("repo")
		telescope.load_extension("file_browser")
		-- require('telescope').load_extension('packer')
		-- require('telescope').load_extension('gh')

		vim.keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Old Files" })
		vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
		vim.keymap.set("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "Commands" })
		vim.keymap.set("n", "<leader>fr", "<cmd>Telescope file_browser<cr>", { desc = "Browser" })
		vim.keymap.set("n", "<leader>fw", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Current Buffer" })
	end)
end

return M
