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

				-- Extend svelte to include html snippets
				luasnip.filetype_extend("svelte", { "html" })

				-- Setup completion sources function
				local function get_completion_sources()
					if not completion_toggle.is_completion_enabled() then
						return {}
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
							["<C-Space>"] = cmp.mapping.complete(),
							["<C-e>"] = cmp.mapping.abort(),
							["<C-j>"] = cmp.mapping.select_next_item(),
							["<C-k>"] = cmp.mapping.select_prev_item(),
							["<CR>"] = cmp.mapping.confirm({ select = true }),
							["<Tab>"] = cmp.mapping(function(fallback)
								if luasnip.expand_or_jumpable() then
									luasnip.expand_or_jump()
								elseif cmp.visible() then
									cmp.select_next_item()
								else
									fallback()
								end
							end, { "i", "s" }),
							["<S-Tab>"] = cmp.mapping(function(fallback)
								if luasnip.jumpable(-1) then
									luasnip.jump(-1)
								elseif cmp.visible() then
									cmp.select_prev_item()
								else
									fallback()
								end
							end, { "i", "s" }),
						}),
						sources = get_completion_sources(),
						completion = {
							completeopt = "menu,menuone,noinsert",
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
