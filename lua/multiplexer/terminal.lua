-- Terminal configuration for the multiplexer module
-- Sets up fish shell, scrollback, path, and keybindings

-- Set shell to fish
vim.opt.shell = "/usr/bin/fish"

-- Set scrollback to 1,000,000 lines
vim.opt.scrollback = 1000000

-- Set path to include current directory and all subdirectories
vim.opt.path = ".,**"

-- Terminal mode mappings (removed <C-l> to avoid conflict with fish clear screen)
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', 'jk', '<C-\\><C-n>', { noremap = true, silent = true, desc = "Exit terminal mode" })
vim.api.nvim_set_keymap('t', '<C-h>', '<C-\\><C-n><C-w>h', { noremap = true, silent = true })
-- Note: <C-l> is intentionally omitted to pass through to fish (clear screen)
-- Note: <C-j> and <C-k> are NOT mapped globally because they conflict with
-- fzf-lua navigation (fzf uses <C-j>/<C-k> natively). They are applied as
-- buffer-local mappings only in non-fzf terminals via the TermOpen autocmd below.

-- Automatically enter insert mode and apply terminal navigation mappings
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function()
        vim.cmd("startinsert")
        if vim.bo.filetype ~= "fzf" then
            vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', '<C-\\><C-n><C-w>j', { noremap = true, silent = true })
            vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', '<C-\\><C-n><C-w>k', { noremap = true, silent = true })
        end
    end,
})

-- Leader keybinds for terminal
-- <leader>t: open terminal in a new tab (fullscreen)
vim.api.nvim_set_keymap('n', '<leader>t', ':tabnew | terminal<CR>', { noremap = true, silent = true, desc = "Open terminal in fullscreen tab" })
-- <leader>s: open terminal in horizontal split (for running servers while editing code)
vim.api.nvim_set_keymap('n', '<leader>s', ':split | terminal<CR>', { noremap = true, silent = true, desc = "Open terminal in horizontal split" })
-- <leader>T: open terminal in horizontal split (alternative keybind)
vim.api.nvim_set_keymap('n', '<leader>T', ':split | terminal<CR>', { noremap = true, silent = true, desc = "Open terminal in horizontal split" })