" Plugins
let g:mapleader = "\<Space>"

call plug#begin('~/.config/nvim/autoload/plugged')

Plug 'lukas-reineke/indent-blankline.nvim', { 'branch': 'lua' }
let g:indent_blankline_enabled = v:false
let g:indent_blankline_char = '▏'
Plug 'mbbill/undotree'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'jiangmiao/auto-pairs'
Plug 'andymass/vim-matchup'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'vimwiki/vimwiki'
Plug 'chrisbra/Colorizer'
Plug 'junegunn/goyo.vim'

Plug 'mattn/emmet-vim'
let g:user_emmet_leader_key='<C-Q>'
Plug 'alvan/vim-closetag'
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.php,*.js,*.jsx"
Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server'}
Plug 'maxmellon/vim-jsx-pretty'

Plug 'fatih/vim-go'
let g:go_gopls_enabled = 0
let g:go_code_completion_enabled = 0
let g:go_mod_fmt_autosave = 0
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_diagnostic_errors = 1
let g:go_highlight_diagnostic_warnings = 1

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
set completeopt=menuone,noselect,preview,noinsert,noselect
let g:compe = {}
let g:compe.preselect = 'disable'
let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.nvim_lsp = v:true
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <C-y>     compe#confirm('<CR>')
Plug 'norcalli/snippets.nvim'

call plug#end()

" General
set hidden
set noswapfile
set path=.,**
set ignorecase
set smartcase
set wildignorecase
set clipboard=unnamed
set undofile
autocmd FileType * setlocal formatoptions-=cro
set mouse=a

" Indentation
set shiftwidth=5
set tabstop=5
set smartindent

" Appearance
set title
set number
set relativenumber
set nowrap
set linebreak
set signcolumn=number
set guicursor=a:block
set shortmess-=S
set list
set listchars=eol:¬,tab:\ \ ,nbsp:·,trail:·,extends:…,precedes:…

" Jump to guide character
nmap <Space><Space> <Esc>/<++><Enter>"_c4l

" leader i to cycle between tab listchars
function! ToggleIndentLines()
	if &listchars =~ "tab:\ \ "
		set listchars=eol:¬,tab:\▏\ ,nbsp:·,trail:·,extends:…,precedes:…
		let g:indent_blankline_char = '▏'
		IndentBlanklineEnable!
	elseif &listchars =~ "tab:\▏\ "
		set listchars=eol:¬,tab:»·,nbsp:·,trail:·,extends:…,precedes:…
		IndentBlanklineDisable!
	else
		set listchars=eol:¬,tab:\ \ ,nbsp:·,trail:·,extends:…,precedes:…
		IndentBlanklineDisable!
	endif
endfunction
nnoremap <leader>i :call ToggleIndentLines()<CR>

" Trigger [num]j/k as jumps
function! JkJumps(key) range
	exec "normal! ".v:count1.a:key
	if v:count1 >= 2
		let target = line('.')
		let bkey = 'k'
		if (a:key == 'k')
			let bkey = 'j'
		endif
		exec "normal! ".v:count1.bkey
		exec "normal! ".target."G"
	endif
endfunction
nnoremap <silent> j :<C-U>call JkJumps('j')<CR>
nnoremap <silent> k :<C-U>call JkJumps('k')<CR>

" Highlight yanked text
augroup highlight_yank
	autocmd!
	au TextYankPost * silent! lua vim.highlight.on_yank{higroup="Substitute", timeout=400}
augroup END

" nvim-lsp
lua << eof
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local opts = { noremap=true, silent=true }

	vim.lsp.handlers["textdocument/publishdiagnostics"] = vim.lsp.with(
		vim.lsp.diagnostic.on_publish_diagnostics, {
			underline = false,
			virtual_text = false
		}
	)

	-- mappings
	buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
	buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
	buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
	buf_set_keymap('n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
	buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
	buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>', opts)
	buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', opts)
	buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', opts)
	buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>', opts)
	buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
	buf_set_keymap('n', '<leader>ld', '<cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<cr>', opts)

	-- set some keybinds conditional on server capabilities
	if client.resolved_capabilities.document_formatting then
		buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)
	elseif client.resolved_capabilities.document_range_formatting then
		buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)
	end
end

-- use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
local servers = { "clangd", "gopls", "tsserver", "html", "pyls" }
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup { on_attach = on_attach }
end
eof
