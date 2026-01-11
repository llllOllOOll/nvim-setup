vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "Open Parent Directory in Oil" })
vim.keymap.set("n", "gl", function()
	vim.diagnostic.open_float()
end, { desc = "Open Diagnostics in Float" })

-- Trouble.nvim keymaps
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle focus=true<cr>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle focus=true filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
vim.keymap.set("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP Definitions / references / ... (Trouble)" })
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle focus=true<cr>", { desc = "Location List (Trouble)" })
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle focus=true<cr>", { desc = "Quickfix List (Trouble)" })

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

-- Toggle Markdown rendering
vim.keymap.set("n", "<leader>tm", ":RenderMarkdown<CR>", { desc = "Toggle Markdown rendering" })
vim.keymap.set("n", "<leader>te", ":RenderMarkdownEnable<CR>", { desc = "Enable Markdown rendering" })
vim.keymap.set("n", "<leader>td", ":RenderMarkdownDisable<CR>", { desc = "Disable Markdown rendering" })

-- Run current file with bun
vim.keymap.set("n", "<leader>rb", ":!bun %<CR>", { desc = "Run current file with bun" })

-- Delete all comments starting with //
vim.keymap.set("n", "<leader>dc", ":%g@^\\s*//@d<CR>", { desc = "Delete all // comments" })

-- Delete all comments starting with //
vim.keymap.set("n", "<leader>dc", ":%g@^\\s*//@d<CR>", { desc = "Delete all // comments" })

-- Delete all comments starting with //
vim.keymap.set("n", "<leader>dc", ":%g@^\\s*//@d<CR>", { desc = "Delete all // comments" })

-- Delete all comments starting with //
vim.keymap.set("n", "<leader>dc", ":%g@^\\s*//@d<CR>", { desc = "Delete all // comments" })



-- Escape insert mode with jk
vim.keymap.set("i", "jk", "<Esc>", { desc = "Escape insert mode" })

-- Escape visual mode with jk
-- vim.keymap.set("v", "jk", "<Esc>", { desc = "Escape visual mode" })

-- Open a live terminal split at the bottom and run the exact same command :make uses
local function run_in_split()
  local cmd = vim.fn.expandcmd(vim.o.makeprg)   -- respects your current makeprg + % replacements
  vim.cmd("below 15split | terminal " .. cmd)   -- 15 lines high, you can change the number
end

-- Two-key workflow exactly like Tsoding
vim.keymap.set("n", "<leader>c", ":make<CR>", { silent = true, desc = "Compile/Run (quickfix)" })
vim.keymap.set("n", "<leader>r", run_in_split, { silent = true, desc = "Re-run in live split" })
vim.keymap.set("n", "<leader>e", ":cnext<CR>", { silent = true, desc = "Next compilation error" })
vim.keymap.set("n", "<leader>E", ":cprev<CR>", { silent = true, desc = "Previous compilation error" })

-- Toggle completion
vim.keymap.set("n", "<leader>tc", function()
	require("config.completion").toggle_completion()
end, { desc = "[T]oggle [C]ompletion" })

-- disable auto comment continuation
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})