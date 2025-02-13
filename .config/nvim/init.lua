--  _
-- | |    __ _ _____   _
-- | |   / _` |_  / | | |
-- | |__| (_| |/ /| |_| |
-- |_____\__,_/___|\__, |
--                 |___/

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
	{
		"navarasu/onedark.nvim",
		priority = 1000, -- Ensure it loads first
		config = function()
			vim.cmd("colorscheme onedark")
		end,
	},
	"farmergreg/vim-lastplace",
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {}
	},
	"tpope/vim-surround",
	"tpope/vim-repeat",
	{
		"petertriho/nvim-scrollbar",
		config = function()
			require("scrollbar").setup()
		end,
	},
	-- {
	-- 	"nvim-zh/colorful-winsep.nvim",
	-- 	config = true,
	-- 	event = { "WinNew" },
	-- },
	{
		"vifm/vifm.vim",
		config = function()
			vim.cmd([[nmap <silent> <leader>v :Vifm<CR>]])
		end
	},
	{
		'stevearc/oil.nvim',
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				experimental_watch_for_changes = false,
				view_options = {
					show_hidden = true,
				},
				lsp_file_methods = {
					autosave_changes = true,
				},
			})
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		end
	},
	{
		"rgroli/other.nvim",
		config = function()
			require("other-nvim").setup({
				mappings = {
					"livewire",
					"angular",
					"laravel",
					"rails",
					"golang",
					"python",
					"rust",
				},
			})
		end
	},
	{
		"sbdchd/neoformat",
		config = function()
			vim.cmd([[
				let g:neoformat_enabled_css = ['prettierd', 'prettier']
				let g:neoformat_try_node_exe = 1
				let g:neoformat_enabled_javascript      = ['prettiereslint', 'prettierd', 'prettier']
				let g:neoformat_enabled_typescript      = ['prettiereslint', 'prettierd', 'prettier']
				let g:neoformat_enabled_javascriptreact = ['prettiereslint', 'prettierd', 'prettier']
				let g:neoformat_enabled_typescriptreact = ['prettiereslint', 'prettierd', 'prettier']
				nmap <silent> <leader>n :Neoformat<CR>
			]])
		end
	},
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true
		-- use opts = {} for passing setup options
		-- this is equalent to setup({}) function
	},
	{
		'windwp/nvim-ts-autotag',
		config = function()
			require('nvim-ts-autotag').setup({})

			-- Custom rules

			-- Add spaces between parentheses

			local npairs = require'nvim-autopairs'
			local Rule = require'nvim-autopairs.rule'
			local cond = require 'nvim-autopairs.conds'

			local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
			npairs.add_rules {
				-- Rule for a pair with left-side ' ' and right side ' '
				Rule(' ', ' ')
					-- Pair will only occur if the conditional function returns true
					:with_pair(function(opts)
						-- We are checking if we are inserting a space in (), [], or {}
						local pair = opts.line:sub(opts.col - 1, opts.col)
						return vim.tbl_contains({
							brackets[1][1] .. brackets[1][2],
							brackets[2][1] .. brackets[2][2],
							brackets[3][1] .. brackets[3][2]
						}, pair)
					end)
					:with_move(cond.none())
					:with_cr(cond.none())
					-- We only want to delete the pair of spaces when the cursor is as such: ( | )
					:with_del(function(opts)
						local col = vim.api.nvim_win_get_cursor(0)[2]
						local context = opts.line:sub(col - 1, col + 2)
						return vim.tbl_contains({
							brackets[1][1] .. '  ' .. brackets[1][2],
							brackets[2][1] .. '  ' .. brackets[2][2],
							brackets[3][1] .. '  ' .. brackets[3][2]
						}, context)
					end)
			}
			-- For each pair of brackets we will add another rule
			for _, bracket in pairs(brackets) do
				npairs.add_rules {
					-- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
					Rule(bracket[1] .. ' ', ' ' .. bracket[2])
						:with_pair(cond.none())
						:with_move(function(opts) return opts.char == bracket[2] end)
						:with_del(cond.none())
						:use_key(bracket[2])
						-- Removes the trailing whitespace that can occur without this
						:replace_map_cr(function(_) return '<C-c>2xi<CR><C-c>O' end)
				}
			end
		end,
	},
	{
		"luukvbaal/statuscol.nvim", config = function()
			local builtin = require("statuscol.builtin")
			require("statuscol").setup({
				relculright = true,
				segments = {
					{
						sign = { namespace = { "diagnostic/signs" }, maxwidth = 1, auto = false },
						click = "v:lua.ScSa"
					},
					{ text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
					{
						sign = { namespace = { "gitsigns" }, name = { ".*" }, maxwidth = 1, auto = false },
						click = "v:lua.ScSa",
					},
					{ text = { builtin.foldfunc, " " }, click = "v:lua.ScFa", sign = { auto = true } },
				}
			})
		end,
	},
	{
		'kevinhwang91/nvim-ufo',
		dependencies = 'kevinhwang91/promise-async',
		config = function()
			vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
			vim.o.foldcolumn = '1'
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
			vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

			-- Custom fold text

			local handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = (' 󰁂 %d '):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, {chunkText, hlGroup})
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, {suffix, 'MoreMsg'})
				return newVirtText
			end

			require('ufo').setup({
				fold_virt_text_handler = handler,
				provider_selector = function(bufnr, filetype, buftype)
					return {'treesitter', 'indent'}
				end,
			})
		end
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require('gitsigns').setup({
				signcolumn = true,
				numhl = false,
			})
		end
	},
	{
		"echasnovski/mini.animate",
		opts = function()
			-- don't use animate when scrolling with the mouse
			local mouse_scrolled = false
			for _, scroll in ipairs { "Up", "Down" } do
				local key = "<ScrollWheel" .. scroll .. ">"
				vim.keymap.set({ "", "i" }, key, function()
					mouse_scrolled = true
					return key
				end, { expr = true })
			end

			local animate = require("mini.animate")
			return {
				resize = {
					timing = animate.gen_timing.linear { duration = 33, unit = "total" },
				},
				scroll = {
					timing = animate.gen_timing.linear { duration = 50, unit = "total" },
					subscroll = animate.gen_subscroll.equal {
						predicate = function(total_scroll)
							if mouse_scrolled then
								mouse_scrolled = false
								return false
							end
							return total_scroll > 1
						end,
					},
				},
				cursor = {
					enable = false, -- We don't want cursor ghosting
					timing = animate.gen_timing.linear { duration = 26, unit = "total" },
				},
			}
		end,
	},
	"dhruvasagar/vim-zoom",
	{
		"nvim-telescope/telescope.nvim",
		config = function()
			require('telescope').setup({
				defaults = {
					layout_config = {
						vertical = { width = 0.5 }
					},
				},
			})

			vim.cmd([[
			nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files({layout_strategy='vertical',layout_config={width=0.95}})<cr>
			nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep({layout_strategy='vertical',layout_config={width=0.95}})<cr>
			nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers({layout_strategy='vertical',layout_config={width=0.95}})<cr>
			]])
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		'johnfrankmorgan/whitespace.nvim',
		config = function ()
			require('whitespace-nvim').setup({
				highlight = 'DiffDelete',
				ignored_filetypes = { 'TelescopePrompt', 'Trouble', 'help' },
				ignore_terminal = true,
				return_cursor = true,
			})

			vim.keymap.set('n', '<leader>t', require('whitespace-nvim').trim)
		end
	},
	{
		"mbbill/undotree",
		config = function()
			vim.cmd("nnoremap <leader>u :UndotreeToggle<CR>")
		end
	},
	-- "tpope/vim-sleuth",
	{
		"nmac427/guess-indent.nvim",
		opts = {},
	},
	"jghauser/mkdir.nvim",
	{
		"NvChad/nvim-colorizer.lua",
		opts = {
			user_default_options = {
				names = false,
			},
			filetypes = {
				"*",
				css = { names = true, css = true, css_fn = true },
			},
		},
	},
	"HiPhish/rainbow-delimiters.nvim",
	{
		'akinsho/bufferline.nvim',
		version = "*",
		dependencies = 'nvim-tree/nvim-web-devicons',
		config = function()
			local bufferline = require('bufferline')
			bufferline.setup{
				options = {
					mode = 'tabs',
					separator_style = 'slant',
					style_preset = bufferline.style_preset.no_italic,
				},
			}
		end
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function ()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = "all",
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})

			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			parser_config.blade = {
				install_info = {
					url = "https://github.com/EmranMR/tree-sitter-blade",
					files = { "src/parser.c" },
					branch = "main",
				},
				filetype = "blade",
			}
		end
	},
	{
		'numToStr/Comment.nvim',
		config = function ()
			require('Comment').setup {
				pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
				ignore = '^$',
			}
		end,
		lazy = false,
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
			'nvim-treesitter/nvim-treesitter',
		}
	},
	{
		'JoosepAlviste/nvim-ts-context-commentstring',
		opts = {
			enable_autocmd = false,
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {},
	},
	-- {
	-- 	"shellRaining/hlchunk.nvim",
	-- 	event = { "BufReadPre", "BufNewFile" },
	-- 	config = function()
	-- 		require("hlchunk").setup({
	-- 			chunk = {
	-- 				enable = true,
	-- 				delay = 1,
	-- 				style = "#AAB1BE",
	-- 			},
	-- 			indent = {
	-- 				enable = true,
	-- 				style = "#3B4048",
	-- 			},
	-- 			-- line_num = {
	-- 			-- 	enable = true,
	-- 			-- 	style = "#707070",
	-- 			-- },
	-- 			-- blank = {
	-- 			-- 	enable = true,
	-- 			-- 	chars = {
	-- 			-- 		" ",
	-- 			-- 	},
	-- 			-- 	style = {
	-- 			-- 		{ bg = "#434437" },
	-- 			-- 		{ bg = "#2f4440" },
	-- 			-- 		{ bg = "#433054" },
	-- 			-- 		{ bg = "#284251" },
	-- 			-- 	},
	-- 			-- },
	-- 		})
	-- 	end
	-- },
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require('lualine').setup({
				sections = {
					lualine_a = {},
					lualine_b = {'branch', 'diff', 'diagnostics'},
					lualine_c = {'filename'},
					lualine_x = {'encoding', 'fileformat', 'filetype'},
					lualine_y = {'progress', 'location'},
					lualine_z = {},
				},
			})
		end
	},

	{'williamboman/mason.nvim'},
	{'WhoIsSethDaniel/mason-tool-installer.nvim'},
	{'williamboman/mason-lspconfig.nvim'},
	{'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
	{'nvimtools/none-ls.nvim'},
	-- {
	-- 	"jay-babu/mason-null-ls.nvim",
	-- 	event = { "BufReadPre", "BufNewFile" },
	-- 	dependencies = {
	-- 		"williamboman/mason.nvim",
	-- 		"nvimtools/none-ls.nvim",
	-- 	},
	-- 	config = function()
	-- 		local null_ls = require 'null-ls'

	-- 		require("mason-null-ls").setup({
	-- 			ensure_installed = { "phpstan" },
	-- 			automatic_installation = true,
	-- 			automatic_setup = true,
	-- 			handlers = {
	-- 				phpstan = function(source_name, methods)
	-- 					null_ls.register(null_ls.builtins.diagnostics.phpstan.with({
	-- 						command = './vendor/phpstan/phpstan/phpstan',
	-- 					}))
	-- 				end,
	-- 			},
	-- 		})
	-- 	end,
	-- },
	{'hrsh7th/cmp-nvim-lsp'},
	{'hrsh7th/nvim-cmp'},
	{'L3MON4D3/LuaSnip'},
	{'saadparwaiz1/cmp_luasnip'},
	{"hrsh7th/cmp-nvim-lua"},
	{"onsails/lspkind.nvim"},
	{
		"j-hui/fidget.nvim",
		opts = {},
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
	},
	{
		'neovim/nvim-lspconfig',
		config = function ()
			local lsp_zero = require('lsp-zero')

			lsp_zero.on_attach(function(client, bufnr)
				lsp_zero.default_keymaps({buffer = bufnr})
				require "lsp_signature".on_attach({
					bind = true,
					handler_opts = {
						border = "rounded"
					},
					hint_prefix = {
						above = "↙ ",  -- when the hint is on the line above the current line
						current = "← ",  -- when the hint is on the same line
						below = "↖ "  -- when the hint is on the line below the current line
					},
					floating_window = false,
					toggle_key = '<C-s>',
					toggle_key_flip_floatwin_setting = true,
				}, bufnr)

				vim.keymap.set(
					"",
					"<Leader>d",
					require("lsp_lines").toggle,
					{ desc = "Toggle lsp_lines" }
				)
			end)

			lsp_zero.set_sign_icons({
				error = '✘',
				warn = '▲',
				hint = '⚑',
				info = '»'
			})

			-- Custom servers

			-- local lsp_configurations = require('lspconfig.configs')

			-- if not lsp_configurations.laravel_ls then
			-- 	lsp_configurations.laravel_ls = {
			-- 		default_config = {
			-- 			cmd = {"/home/safal/dl/ext/laravel-dev-tools/builds/laravel-dev-tools", "lsp"},
			-- 			filetypes = {"blade"},
			-- 			root_dir = function(fname)
			-- 				return require('lspconfig').util.find_git_ancestor(fname)
			-- 			end,
			-- 		}
			-- 	}
			-- end

			-- require('lspconfig').laravel_ls.setup({})

			-- Diagnostics

			vim.diagnostic.config({
				virtual_text = false,
				exclude = {'[d', ']d'},
			})
			vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', { buffer = bufnr })
			vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', { buffer = bufnr })

			vim.diagnostic.config({
				update_in_insert = false
			})

			-- Mason

			require('mason').setup({})
			require('mason-tool-installer').setup({
				ensure_installed = {'vtsls', 'eslint', 'pyright', 'intelephense', 'html', 'cssls', 'prettierd', 'pint', 'blade-formatter', 'tailwindcss', 'jsonls', 'clangd', 'gopls', 'goimports', 'golangci_lint_ls', 'golangci-lint'},
			})
			require('mason-lspconfig').setup({
				handlers = {
					function(server_name)
						require('lspconfig')[server_name].setup({})
					end,
					html = function()
						require('lspconfig').html.setup({
							filetypes = { "html", "templ", "blade" },
						})
					end,
					tailwindcss = function()
						require('lspconfig').tailwindcss.setup({
							root_dir = function(fname)
								local root_pattern = require("lspconfig").util.root_pattern(
									"tailwind.config.cjs",
									"tailwind.config.js",
									"postcss.config.js"
								)
								return root_pattern(fname)
							end,
						})
					end,
				},
			})

			-- Autocompletion

			local cmp = require('cmp')
			local cmp_action = require('lsp-zero').cmp_action()
			cmp.setup({
				sources = {
					{name = 'nvim_lsp'},
					{name = 'luasnip'},
					{name = 'nvim_lua'},
				},
				mapping = cmp.mapping.preset.insert({
					['<C-y>'] = cmp.mapping.confirm({select = true}),
					['<C-u>'] = cmp.mapping.scroll_docs(-4),
					['<C-d>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-j>'] = cmp_action.luasnip_jump_forward(),
					['<C-k>'] = cmp_action.luasnip_jump_backward(),
				}),
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				formatting = {
					format = require('lspkind').cmp_format({
						mode = 'symbol_text',
						maxwidth = 50,
						ellipsis_char = '...',
						before = function (entry, vim_item)
							vim_item = require('tailwindcss-colorizer-cmp').formatter(entry, vim_item)
							return vim_item
						end
					})
				},
			})

			-- Null ls

			-- local null_ls = require('null-ls')
			-- local null_opts = lsp_zero.build_options('null-ls', {})

			-- null_ls.setup({
			-- 	debug = true,
			-- 	on_attach = function(client, bufnr)
			-- 		null_opts.on_attach(client, bufnr)
			-- 		---
			-- 		-- you can add other stuff here....
			-- 		---
			-- 	end,
			-- 	sources = {}
			-- })
		end,
	},
	{
		'mfussenegger/nvim-lint',
		config = function()
			require('lint').linters_by_ft = {
				php = {'phpstan',}
			}

			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					require("lint").try_lint(nil, { ignore_errors = true })
				end,
			})
		end,
	},
	{
		'stevearc/aerial.nvim',
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons"
		},
		config = function()
			require("aerial").setup({})

			vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
		end,
	},
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		config = function()
			require("lsp_lines").setup()
			vim.diagnostic.config({ virtual_lines = false })
		end,
	},
	{
		"folke/trouble.nvim",
		opts = {},
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle focus=true filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
		},
	},
	{
		"dmmulroy/tsc.nvim",
		config = function()
			require('tsc').setup()
		end,
	},
	{
		'dmmulroy/ts-error-translator.nvim',
		config = function()
			require("ts-error-translator").setup()
		end,
	},
	{
		"roobert/tailwindcss-colorizer-cmp.nvim",
		config = function()
			require("tailwindcss-colorizer-cmp").setup({
				color_square_width = 1,
			})
		end
	},
	{
		"luckasRanarison/tailwind-tools.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {}
	},
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {},
	},

	-- Language specific plugins

	{
		"adalessa/laravel.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"tpope/vim-dotenv",
			"MunifTanjim/nui.nvim",
			"nvimtools/none-ls.nvim",
		},
		cmd = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
		keys = {
			{ "<leader>la", ":Laravel artisan<cr>" },
			{ "<leader>lr", ":Laravel routes<cr>" },
			{ "<leader>lm", ":Laravel related<cr>" },
		},
		event = { "VeryLazy" },
		config = true,
	},
	{
		'ricardoramirezr/blade-nav.nvim',
		dependencies = {
			'hrsh7th/nvim-cmp',
		},
		ft = {'blade', 'php'}
	},
	{
		"mattn/emmet-vim",
		init = function()
			vim.cmd([[
	let g:user_emmet_leader_key='<C-Q>'
	]])
		end,
		config = function()
			vim.cmd([[
	let g:user_emmet_settings = {
	\  'variables': {'lang': 'en'},
	\  'html': {
	\    'default_attributes': {
	\      'option': {'value': v:null},
	\      'textarea': {'id': v:null, 'name': v:null, 'cols': 10, 'rows': 10},
	\    },
	\    'snippets': {
	\      'html:5': "<!DOCTYPE html>\n"
	\              ."<html lang=\"${lang}\">\n"
	\              ."<head>\n"
	\              ."\t<meta charset=\"${charset}\">\n"
	\              ."\t<title></title>\n"
	\              ."\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n"
	\              ."</head>\n"
	\              ."<body>\n\t${child}|\n</body>\n"
	\              ."</html>",
	\    },
	\  },
	\}
	]])
		end,
	},
	-- {
	-- 	"lukas-reineke/headlines.nvim",
	-- 	dependencies = "nvim-treesitter/nvim-treesitter",
	-- 	config = true,
	-- },
	{
		'preservim/vim-markdown',
		dependencies = { 'godlygeek/tabular' },
		config = function()
			vim.cmd([[
			let g:vim_markdown_folding_disabled = 1
			]])
		end
	},
	-- {
	-- 	'MeanderingProgrammer/markdown.nvim',
	-- 	dependencies = { 'nvim-treesitter/nvim-treesitter' },
	-- 	config = function()
	-- 		require('render-markdown').setup({})
	-- 	end,
	-- },
	{
		"OXY2DEV/markview.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons"
		},
		config = function()
			require("markview").setup({
				modes = { "n", "i", "no", "c" },
				hybrid_modes = { "n", "i" },

				code_blocks = {
					pad_amount = 0,
				},

				list_items = {
					indent_size = 0,
					shift_width = 0,
					marker_minus = {
						add_padding = false,
					},
					marker_plus = {
						add_padding = false,
					},
					marker_star = {
						add_padding = false,
					},
					marker_dot = {
						add_padding = false,
					},
					marker_parenthasis = {
						add_padding = false,
					},
				},

				-- -- This is nice to have
				-- callbacks = {
				-- 	on_enable = function (_, win)
				-- 		vim.wo[win].conceallevel = 2;
				-- 		vim.wo[win].conecalcursor = "nc";
				-- 	end
				-- }
			})
		end,
	},
	-- {
	-- 	"3rd/image.nvim",
	-- 	build = false,
	-- 	opts = {
	-- 		processor = "magick_cli",
	-- 		backend = "ueberzug",
	-- 	},
	-- },
	"jwalton512/vim-blade",
	{
		'nvim-flutter/flutter-tools.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'stevearc/dressing.nvim', -- optional for vim.ui.select
		},
		config = function()
			require("flutter-tools").setup({})
		end,
		ft = "dart",
	},

	-- TODO: https://github.com/rockerBOO/awesome-neovim?tab=readme-ov-file#markdown-and-latex
	-- TODO: https://github.com/rockerBOO/awesome-neovim?tab=readme-ov-file#snippet
})


--  ____            _
-- | __ )  __ _ ___(_) ___ ___
-- |  _ \ / _` / __| |/ __/ __|
-- | |_) | (_| \__ \ | (__\__ \
-- |____/ \__,_|___/_|\___|___/

vim.cmd([[
" set mouse=
set clipboard=unnamed
set guicursor=a:block
set path=.,**
set lazyredraw
set undofile
set updatetime=100
set wildignorecase
set wildignore+=**/node_modules/**,**/dist/**,**/.git/**,**/*.o,**/venv/**,**/vendor/**
set number
set relativenumber
set termguicolors
set signcolumn=no
set ignorecase    " Case in-sensitive search
set smartcase     " Smart case sensitive search
set infercase     " Case in-sensitive insert-completion
set cursorline
set linebreak          " Wrap whole word
set breakindent
let &showbreak = '↳ '  " Character to show on the next line of a line wrap
set nowrap             " Disable line wraping
nnoremap <silent> <leader>w :set wrap!<CR>
let g:editorconfig = v:false " Disable editorconfig

set autoindent
set smartindent

set guifont=Monaco\ Nerd\ Font\ Mono:h12
set showtabline=2

set splitright
]])

--  _____                    _
-- |_   _|_      _____  __ _| | _____
--   | | \ \ /\ / / _ \/ _` | |/ / __|
--   | |  \ V  V /  __/ (_| |   <\__ \
--   |_|   \_/\_/ \___|\__,_|_|\_\___/

vim.cmd([[
" Highlight yanked lines
autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup='IncSearch', timeout=300}

" Use * and g* without cursor jump
nnoremap <silent> * :let @/= '\<' . expand('<cword>') . '\>' <bar> set hls <cr>
nnoremap <silent> g* :let @/=expand('<cword>') <bar> set hls <cr>

" Give files with no extension a lower priority when it comes to matching
" wildcards (To avoid opening executables accidently)
set suffixes+=,,

" Keep visual mode after indent
vnoremap > >gv
vnoremap < <gv

" Jump to guide character
nmap <Space><Space> <Esc>/<++><Enter>:noh<CR>"_c4l

" Triger `autoread` when files changes on disk
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
			\ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
" Notification after file change
autocmd FileChangedShellPost *
			\ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" Get highlight group
function! SynGroup()
	let l:s = synID(line('.'), col('.'), 1)
	echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
nnoremap <F6> :call SynGroup()<CR>


" Open current file with current line number in vscode
" ----------------------------------------------------

" First we need to get the proper root directory location
function! Get_VSCode_Open_Loc()
  " Prefer the location of `*.code-workspace`
  " Search in current and parent directories
  let l:code_workspace_file_current = get(split(glob('./*.code-workspace'), "\n"), 0, "")
  if l:code_workspace_file_current != ""
    return l:code_workspace_file_current
  endif
  let l:code_workspace_file_parent = get(split(glob('../*.code-workspace'), "\n"), 0, "")
  if l:code_workspace_file_parent != ""
    return l:code_workspace_file_parent
  endif
  return "."
endfunction

command Code call system('code ' . Get_VSCode_Open_Loc() . ' --goto "' . expand('%') . '":' . line('.'))

function! Source_Or_Open_VSCode()
  if filereadable("./debug.vim")
    source ./debug.vim
  else
    Code
  endif
endfunction

nnoremap <silent> <leader>b :call Source_Or_Open_VSCode()<CR>


" Get exact count of matches (No more >99)
" ----------------------------------------

const s:MAXCOUNT = 1000
const s:TIMEOUT = 500

augroup index_after_slash | au!
	au CmdlineLeave /,\? call s:index_after_slash()
augroup END

fu s:index_after_slash() abort
	if getcmdline() is# '' || state() =~# 'm'
		return
	endif
	call timer_start(0, {-> mode() =~# '[nv]' ? s:search_index() : 0})
endfu

fu s:search_index() abort
	try
		let result = searchcount(#{maxcount: s:MAXCOUNT, timeout: s:TIMEOUT})
		let [current, total, incomplete] = [result.current, result.total, result.incomplete]
	catch
		echohl ErrorMsg | echom v:exception | echohl NONE
		return ''
	endtry
	let msg = ''
	let pat = substitute(@/, '\%x00', '^@', 'g')
	if incomplete == 0
		let msg = printf('[%*d/%d] %s', len(total), current, total, pat)
	elseif incomplete == 1 " recomputing took too much time
		let msg = printf('[?/??] '..%s', pat)
	elseif incomplete == 2 " too many matches
		if result.total == (result.maxcount+1) && result.current <= result.maxcount
			let msg = printf('[%*d/>%d] %s', len(total-1), current, total-1, pat)
		else
			let msg = printf('[>%*d/>%d] %s', len(total-1), current-1, total-1, pat)
		endif
	endif
	if strchars(msg, 1) > (v:echospace + (&cmdheight-1)*&columns)
		let n = v:echospace - 3
		let [n1, n2] = n%2 ? [n/2, n/2] : [n/2-1, n/2]
		let msg = matchlist(msg, '\(.\{' .. n1 .. '}\).*\(.\{' .. n2 .. '}\)')[1:2]->join('...')
	endif
	echo msg
	return ''
endfu

nmap n <plug>(n)<plug>(search_index)
nmap N <plug>(N)<plug>(search_index)
nno <plug>(n) n
nno <plug>(N) N
nno <expr> <plug>(search_index) <sid>search_index()


" Toggle mouse
" ------------

nnoremap <leader>c :call ToggleMouse()<CR>

function! ToggleMouse()
    if &mouse == "a"
        set mouse=
        echo "Mouse disabled"
    else
        set mouse=a
        echo "Mouse enabled"
    endif
endfunction

" Run make
" --------

nnoremap <leader>m :make<CR>

" Filetype specific settings
" --------------------------

au FileType markdown set wrap spell
]])
