return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        style = "storm",
        transparent = true,
    },
    config = function()
        vim.cmd("colorscheme tokyonight")
    end,
}
