require("config.lazy")

vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")

local opt = vim.opt
-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- Highlight when yanking (copying) text
-- Try it with `yap` normal mode
-- See `:help vim.highlight.on_yank()`

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking ( copying ) text",
    group = vim.api.nvim_create_augroup("anyword", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
