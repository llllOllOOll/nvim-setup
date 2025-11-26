-- Automatic makeprg for C language
vim.api.nvim_create_autocmd("FileType", {
  pattern = "c",
  callback = function()
    vim.bo.makeprg = "gcc -Wall -Wextra -std=c11 -g % -o %<"
    vim.bo.errorformat = "%f:%l:%c: %t%*[^:]: %m,%f:%l: %t%*[^:]: %m,%-G%f:%l: %trror: %m,%-G%f:%l: %tarning: %m"
  end,
})

-- Automatic makeprg for Zig language
vim.api.nvim_create_autocmd("FileType", {
  pattern = "zig",
  callback = function()
    vim.bo.makeprg = "zig build run"
    vim.bo.errorformat = "%f:%l:%c: %m,%f:%l: %m"
  end,
})