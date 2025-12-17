return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typecriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				kotlin = { "ktfmt" },
				zig = { "zig fmt" },
				zon = { "zig fmt" },
			},
	format_on_save = function(bufnr)
				-- Disable auto-format for kotlin files
				if vim.bo[bufnr].filetype == "kotlin" then
					return false
				end
				return {
					lsp_fallback = true,
					async = false,
					timeout_ms = 500,
				}
			end,
			formatters = {
				prettier = {
					args = { "--tab-width", "2", "--print-width", "80" },
				},
				stylua = {
					args = { "--search-parent-directories", "--stdin-filepath", "$FILENAME", "--column-width", "80" },
				},
			},
		})
		vim.keymap.set({ "n", "v" }, "<leader>cf", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			})
		end)
	end,
}
