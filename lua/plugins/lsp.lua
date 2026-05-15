return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
	},
	config = function()
		-- zig.vim settings
		vim.g.zig_fmt_parse_errors = 0
		vim.g.zig_fmt_autosave = 0

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
			virtual_text = false,
			signs = true,
			severity_sort = true,
			float = { border = "rounded" },
		})

		vim.fn.sign_define("DiagnosticSignError", { text = "✘", texthl = "DiagnosticSignError" })
		vim.fn.sign_define("DiagnosticSignWarn", { text = "▲", texthl = "DiagnosticSignWarn" })
		vim.fn.sign_define("DiagnosticSignInfo", { text = "ℹ", texthl = "DiagnosticSignInfo" })
		vim.fn.sign_define("DiagnosticSignHint", { text = "⚑", texthl = "DiagnosticSignHint" })

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
			html = {},
			htmx = {},
			clangd = {},
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
				filetypes = { "zig", "zir" },
				root_markers = { "build.zig", ".git" },
				workspace_required = false,
				settings = {
					zls = {
						semantic_tokens = "partial",
						zig_exe_path = "/home/seven/zig/zig",
					},
				},
			},
		}

		-- Ensure tools are installed
		local ensure = vim.tbl_filter(function(server)
			return server ~= "zls"
		end, vim.tbl_keys(servers))
		vim.list_extend(ensure, { "stylua", "prettier", "htmx-lsp", "html-lsp" })

		require("mason-tool-installer").setup({
			ensure_installed = ensure,
		})

		-- Setup LSP servers via native API
		for server, opts in pairs(servers) do
			opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {})
			vim.lsp.config(server, opts)
			vim.lsp.enable(server)
		end

		-- Format-on-save for Zig files using ZLS
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = { "*.zig", "*.zon" },
			callback = function(ev)
				vim.lsp.buf.format({ bufnr = ev.buf })
			end,
		})

	end,
}
