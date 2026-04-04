	return {
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"L3MON4D3/LuaSnip",
				"saadparwaiz1/cmp_luasnip",
				"rafamadriz/friendly-snippets",
				"onsails/lspkind.nvim",
			},
			config = function()
				local cmp = require("cmp")
				local luasnip = require("luasnip")
				local lspkind = require("lspkind")
				local completion_toggle = require("config.completion")

				-- Load VSCode-style snippets
				require("luasnip.loaders.from_vscode").lazy_load()

			-- Extend filetypes to include html snippets
			luasnip.filetype_extend("svelte", { "html" })
			luasnip.filetype_extend("html", { "html" })

				-- Setup completion sources function
				local function get_completion_sources()
					if not completion_toggle.is_completion_enabled() then
						return { { name = "nvim_lsp" } }  -- Only LSP sources when disabled
					end
					return {
						{ name = "nvim_lsp" },
						{ name = "luasnip" },
						{ name = "buffer" },
						{ name = "path" },
					}
				end

				-- Setup completion
				local function setup_completion()
					cmp.setup({
						snippet = {
							expand = function(args)
								luasnip.lsp_expand(args.body)
							end,
						},
						formatting = {
							format = lspkind.cmp_format({
								mode = "symbol_text",
								maxwidth = 50,
							}),
						},
						mapping = cmp.mapping.preset.insert({
							["<C-Space>"] = completion_toggle.is_completion_enabled() and cmp.mapping.complete() or nil,
							["<C-e>"] = completion_toggle.is_completion_enabled() and cmp.mapping.abort() or nil,
							["<C-j>"] = completion_toggle.is_completion_enabled() and cmp.mapping.select_next_item() or nil,
							["<C-k>"] = completion_toggle.is_completion_enabled() and cmp.mapping.select_prev_item() or nil,
							["<CR>"] = completion_toggle.is_completion_enabled() and cmp.mapping.confirm({ select = true }) or nil,
							["<Tab>"] = cmp.mapping(function(fallback)
								if not completion_toggle.is_completion_enabled() then
									fallback()
								elseif luasnip.expand_or_jumpable() then
									luasnip.expand_or_jump()
								elseif cmp.visible() then
									cmp.select_next_item()
								else
									fallback()
								end
							end, { "i", "s" }),
							["<S-Tab>"] = cmp.mapping(function(fallback)
								if not completion_toggle.is_completion_enabled() then
									fallback()
								elseif luasnip.jumpable(-1) then
									luasnip.jump(-1)
								elseif cmp.visible() then
									cmp.select_prev_item()
								else
									fallback()
								end
							end, { "i", "s" }),
						}),
						sources = get_completion_sources(),
						completion = completion_toggle.is_completion_enabled() and {
							completeopt = "menu,menuone,noinsert",
						} or {
							completeopt = "menu,noselect,noinsert",
						},
					})
				end

				-- Initial setup
				setup_completion()

				-- Setup autocmd to reconfigure when toggled
				vim.api.nvim_create_autocmd("User", {
					pattern = "CompletionToggled",
					callback = function()
						-- Reconfigure CMP with new sources
						setup_completion()
					end,
				})
			end,
		},
	}
