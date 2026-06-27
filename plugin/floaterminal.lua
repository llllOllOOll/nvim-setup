local state = { buf = -1, win = -1 }

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

local function toggle_terminal()
  if vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_hide(state.win)
  else
    state = create_floating_window { buf = state.buf }
    if vim.bo[state.buf].buftype ~= "terminal" then
      vim.cmd("terminal env NVIM_FLOATERM=1 fish -C clear")
      vim.cmd("startinsert")
      state.buf = vim.api.nvim_win_get_buf(state.win)
    end
  end
end

local function send_to_terminal(cmd)
  if not vim.api.nvim_win_is_valid(state.win) then
    state = create_floating_window { buf = state.buf }
    if vim.bo[state.buf].buftype ~= "terminal" then
      vim.cmd("terminal env NVIM_FLOATERM=1 fish -C clear")
      vim.cmd("startinsert")
      state.buf = vim.api.nvim_win_get_buf(state.win)
    end
  end

  vim.api.nvim_set_current_win(state.win)
  vim.fn.chansend(vim.bo[state.buf].channel, { cmd .. "\r" })
end

vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<leader>tt", toggle_terminal, { desc = "Toggle floating terminal" })

vim.keymap.set("n", "<leader>c", function()
  send_to_terminal("zig build")
end, { desc = "Compile zig" })

vim.keymap.set("n", "<leader>r", function()
  send_to_terminal("zig build run")
end, { desc = "Build and run zig" })
