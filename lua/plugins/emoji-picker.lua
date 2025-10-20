return {
    "Allaman/emoji.nvim",
    version = "1.0.0",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        enable_cmp_integration = true,
    },
    config = function(_, opts)
        require("emoji").setup(opts)
    end,
}