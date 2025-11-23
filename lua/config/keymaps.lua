vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "Open Parent Directory in Oil" })
vim.keymap.set("n", "gl", function()
	vim.diagnostic.open_float()
end, { desc = "Open Diagnostics in Float" })

vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({
		lsp_format = "fallback",
	})
end, { desc = "Format current file" })

vim.keymap.set("n", "<leader>cF", function()
	require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
end, { desc = "Format Injected Langs" })

-- Map <leader>fp to open projects
vim.keymap.set("n", "<leader>fp", ":ProjectFzf<CR>", { noremap = true, silent = true })

-- Save file with Shift+S
vim.keymap.set("n", "S", ":w<CR>", { noremap = true, silent = true, desc = "Save file" })

-- Move lines up/down in normal mode
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })

-- Move blocks up/down in visual mode
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move block down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move block up" })

-- Toggle Showkeys
vim.keymap.set("n", "<leader>sk", ":ShowkeysToggle<CR>", { desc = "Toggle Showkeys" })

-- Run current file with bun
vim.keymap.set("n", "<leader>rb", ":!bun %<CR>", { desc = "Run current file with bun" })

-- Run current file with Zig (only for Zig files)
vim.keymap.set("n", "zr", function()
  if vim.bo.filetype == "zig" then
    vim.cmd("!zig build run")
  else
    print("This keymap only works for Zig files")
  end
end, { desc = "Run current Zig file" })

-- Escape insert mode with jk
vim.keymap.set("i", "jk", "<Esc>", { desc = "Escape insert mode" })

-- Escape visual mode with jk
-- vim.keymap.set("v", "jk", "<Esc>", { desc = "Escape visual mode" })

-- disable auto comment continuation
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})