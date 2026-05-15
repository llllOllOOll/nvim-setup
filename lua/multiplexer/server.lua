-- Server module for preventing nested nvim instances
-- Creates helper script for integration with parent nvim (fish version)

local home = vim.env.HOME
local bin_dir = home .. "/.local/bin"

-- Ensure bin directory exists
vim.fn.mkdir(bin_dir, "p")

-- Create ~/.local/bin/v script (fish)
local v_script = [[#!/usr/bin/env fish

if set -q NVIM
    # Resolve absolute path before sending to parent nvim
    set abs_path (realpath $argv[1])
    nvim --server $NVIM --remote $abs_path
else
    nvim $argv
end
]]

-- Write v script
vim.fn.writefile(vim.split(v_script, "\n"), bin_dir .. "/v", "b")
-- Make executable
vim.fn.system("chmod +x " .. bin_dir .. "/v")

-- Notify user
vim.notify("Multiplexer server script installed to " .. bin_dir, vim.log.levels.INFO)