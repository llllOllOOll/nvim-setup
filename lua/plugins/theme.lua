return {
	"navarasu/onedark.nvim",
	priority = 1000,
	config = function()
		require("onedark").setup({
			-- Choose a style variant
			style = "warm", -- 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'
		})
		vim.cmd("colorscheme onedark")
	end,
	-- "catppuccin/nvim",
	-- name = "catppuccin",
	-- priority = 1000,
	-- config = function()
	--     require("catppuccin").setup({
	--         flavour = "mocha",
	--     })
	--     vim.cmd("colorscheme catppuccin")
	-- end,
}
