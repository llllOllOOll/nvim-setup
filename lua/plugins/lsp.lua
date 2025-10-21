
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason.nvim", config = true },
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    { "j-hui/fidget.nvim", opts = {} },
    "ibhagwan/fzf-lua", -- keep FZF integration
  },

  config = function()
    local lspconfig = require("lspconfig")
    local mason_lsp = require("mason-lspconfig")

    -- Capabilities (blink or cmp)
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- LSP keymaps (with FZF)
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(event)
        local fzf = require("fzf-lua")
        local map = function(keys, func, desc, mode)
          vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
        map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
        map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
        map("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
        map("<leader>ds", fzf.lsp_document_symbols, "[D]ocument [S]ymbols")
        map("<leader>ws", fzf.lsp_live_workspace_symbols, "[W]orkspace [S]ymbols")
        map("<leader>cr", vim.lsp.buf.rename, "[R]e[n]ame")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
        map("K", vim.lsp.buf.hover, "Hover Docs")
      end,
    })

    -- Diagnostic settings
    vim.diagnostic.config({
      severity_sort = true,
      float = { border = "rounded" },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅚 ",
          [vim.diagnostic.severity.WARN] = "󰀪 ",
          [vim.diagnostic.severity.INFO] = "󰋽 ",
          [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
      },
    })

    -- LSP servers configuration
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      },
      ts_ls = {},
      svelte = {
        settings = {
          svelte = {
            completions = { emmet = false },
          },
        },
      },
      tailwindcss = {},
      bashls = {},
      marksman = {},
    }

    -- Mason ensure installation
    local ensure = vim.tbl_keys(servers)
    vim.list_extend(ensure, { "stylua", "prettierd" })
    require("mason-tool-installer").setup({ ensure_installed = ensure })

    mason_lsp.setup({
      automatic_installation = true,
      handlers = {
        function(server)
          local opts = servers[server] or {}
          opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {})
          lspconfig[server].setup(opts)
        end,
      },
    })
  end,
}

