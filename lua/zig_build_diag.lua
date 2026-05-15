local ns = vim.api.nvim_create_namespace("zig_build_diag")
local current_handle = nil

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.zig" },
  group = vim.api.nvim_create_augroup("ZigBuildDiag", { clear = true }),
  callback = function(ev)
    local bufnr = ev.buf
    local root = vim.fs.root(bufnr, { "build.zig" })
    if not root then
      return
    end

    local zig_exe = vim.g.zig_build_diag_zig_exe or "/home/seven/zig/zig"
    local build_zig_path = root .. "/build.zig"
    local f = io.open(build_zig_path, "r")
    local use_check = false
    if f then
      local content = f:read("*a")
      f:close()
      use_check = content:find("check", 1, true) ~= nil
    end

    local cmd = { zig_exe, "build" }
    if use_check then
      table.insert(cmd, "check")
    end

    local filename = vim.api.nvim_buf_get_name(bufnr)
    local source_label = "zig build" .. (use_check and " check" or "")

    vim.diagnostic.reset(ns, bufnr)

    if current_handle then
      current_handle:kill("term")
      current_handle = nil
    end

    current_handle = vim.system(cmd, { cwd = root, text = true }, function(out)
      current_handle = nil
      local diags = {}

      for line in vim.gsplit(out.stderr or "", "\n") do
        local relfile, lnum, col, severity, msg = line:match(
          "^(.+):(%d+):(%d+): (%w+): (.+)$"
        )
        if not relfile then
          -- skip lines that don't match the error format
        elseif severity ~= "error" and severity ~= "warning" and severity ~= "note" then
          -- skip unknown severities
        else
          local absfile
          if relfile:sub(1, 1) == "/" then
            absfile = vim.fn.resolve(relfile)
          else
            absfile = vim.fn.resolve(root .. "/" .. relfile)
          end

          if absfile == filename
            and not absfile:find("/lib/zig/", 1, true)
            and not absfile:find("zig/lib/", 1, true)
          then
            local sev_map = {
              error = vim.diagnostic.severity.ERROR,
              warning = vim.diagnostic.severity.WARN,
              note = vim.diagnostic.severity.INFO,
            }
            table.insert(diags, {
              lnum = tonumber(lnum) - 1,
              col = tonumber(col) - 1,
              severity = sev_map[severity] or vim.diagnostic.severity.ERROR,
              message = msg,
              source = source_label,
            })
          end
        end
      end

      if #diags > 0 then
        vim.schedule(function()
          vim.diagnostic.set(ns, bufnr, diags)
        end)
      elseif out.code ~= 0 then
        vim.schedule(function()
          vim.notify(
            source_label .. " failed (exit " .. out.code .. ") but no diagnostics parsed",
            vim.log.levels.WARN
          )
        end)
      end
    end)
  end,
})
