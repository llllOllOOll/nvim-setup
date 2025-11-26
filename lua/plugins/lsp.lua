return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
	},
	config = function()
		local lspconfig = require("lspconfig")
		local mason_lsp = require("mason-lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- LSP keymaps
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(event)
				local fzf = require("fzf-lua")
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
				map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
				map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
				map("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
				map("<leader>ds", fzf.lsp_document_symbols, "[D]ocument [S]ymbols")
				map("<leader>ws", fzf.lsp_live_workspace_symbols, "[W]orkspace [S]ymbols")
				map("<leader>cr", vim.lsp.buf.rename, "[C]ode [R]ename")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
				map("K", vim.lsp.buf.hover, "Hover Documentation")
			end,
		})

		-- Diagnostic configuration
		vim.diagnostic.config({
			severity_sort = true,
			float = { border = "rounded" },
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.INFO] = " ",
					[vim.diagnostic.severity.HINT] = " ",
				},
			},
		})

		-- LSP server configurations
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
			cssls = {},
			kotlin_language_server = {
				settings = {
					kotlin = {
						compiler = {
							jvm = {
								target = "21",
							},
						},
					},
				},
			},
			zls = {
				cmd = { "/home/seven/zls/zig-out/bin/zls" },
			},
		}

		-- Ensure tools are installed
		local ensure = vim.tbl_filter(function(server)
			return server ~= "zls"
		end, vim.tbl_keys(servers))
		vim.list_extend(ensure, { "stylua", "prettier" })

		require("mason-tool-installer").setup({
			ensure_installed = ensure,
		})

		-- Setup LSP servers
		mason_lsp.setup({
			automatic_installation = false,
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
