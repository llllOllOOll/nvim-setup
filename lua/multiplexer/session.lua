-- Session module for managing neovim sessions
-- Creates v-attach script to list and attach to nvim sessions

local home = vim.env.HOME
local bin_dir = home .. "/.local/bin"

-- Ensure bin directory exists
vim.fn.mkdir(bin_dir, "p")

-- Create ~/.local/bin/v-attach script
local v_attach_script = [[#!/usr/bin/env bash
# Script to list and attach to neovim sessions
# Usage: v-attach [session_name]

NVIM_LISTEN_ADDRESS=${NVIM_LISTEN_ADDRESS:-/tmp/nvimsocket}

if [ "$1" = "list" ]; then
    # List available nvim servers
    echo "Available nvim sessions:"
    ls -1 /tmp/nvimsocket* 2>/dev/null | xargs -I {} basename {}
elif [ -n "$1" ]; then
    # Attach to specific session
    nvim --server "/tmp/nvimsocket$1" --remote-ui
else
    # Interactive session selection
    echo "Available nvim sessions:"
    ls -1 /tmp/nvimsocket* 2>/dev/null | while read socket; do
        basename "$socket"
    done
    echo -n "Enter session name to attach (or new name to create): "
    read session
    if [ -n "$session" ]; then
        if [ -e "/tmp/nvimsocket$session" ]; then
            nvim --server "/tmp/nvimsocket$session" --remote-ui
        else
            nvim --server "/tmp/nvimsocket$session"
        fi
    fi
fi
]]

-- Write v-attach script
vim.fn.writefile(vim.split(v_attach_script, "\n"), bin_dir .. "/v-attach", "b")
-- Make executable
vim.fn.system("chmod +x " .. bin_dir .. "/v-attach")

-- Notify user
vim.notify("Multiplexer session script installed to " .. bin_dir .. "/v-attach", vim.log.levels.INFO)