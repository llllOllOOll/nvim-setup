require("config.lazy")
require("config.makeprg")
require("snippets.svelte")


-- fzf-lua shortcut for zig/lib search
vim.keymap.set('n', '<leader>zl', function()
  require("fzf-lua").files({ cwd = "~/zig/lib" })
end, { desc = "Search in ~/zig/lib" })

-- fzf-lua shortcut for zig/lib grep
vim.keymap.set('n', '<leader>zg', function()
  require("fzf-lua").live_grep({ cwd = "~/zig/lib" })
end, { desc = "Grep in ~/zig/lib" })


vim.cmd("colorscheme seven") -- O tema deve vir PRIMEIRO

local hl = vim.api.nvim_set_hl

-- Use estas definições SEM o campo 'force'
hl(0, "@string", { fg = "#ffffff" })
hl(0, "@lsp.type.string", { fg = "#ffffff" })
hl(0, "@lsp.type.string.zig", { fg = "#ffffff" })

-- void e tipos embutidos (White)
hl(0, "@lsp.type.type.builtin", { fg = "#ffffff" })
hl(0, "@type.builtin", { fg = "#ffffff" })
hl(0, "@lsp.mod.defaultLibrary", { fg = "#ffffff" })

-- Força o void (Type) para branco logo em seguida
vim.cmd("highlight Type guifg=#ffffff")
vim.cmd("highlight @type.builtin guifg=#ffffff")
