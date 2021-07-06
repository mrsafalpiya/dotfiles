" Plugins
let g:mapleader = "\<Space>"

call plug#begin('~/.config/nvim/autoload/plugged')

Plug 'mrsafalpiya/base16-vim'

Plug 'sheerun/vim-polyglot'
Plug 'lukas-reineke/indent-blankline.nvim'
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

Plug 'rust-lang/rust.vim'
let g:rust_recommended_style = 0
let g:rustfmt_autosave = 1
Plug 'mhinz/vim-crates'
if has('nvim')
	autocmd BufRead Cargo.toml call crates#toggle()
endif

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'ray-x/lsp_signature.nvim'
Plug 'hrsh7th/vim-vsnip'
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

set completeopt=menuone,noselect,preview,noinsert,noselect
let g:compe = {}
let g:compe.preselect = 'disable'
let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.latex_symbols = v:true
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <C-y>     compe#confirm('<CR>')
Plug 'GoldsteinE/compe-latex-symbols'
autocmd FileType markdown let b:compe_latex_insert_code = v:true

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
set inccommand=split
set switchbuf=usetab
set visualbell t_vb=

" Indentation
set shiftwidth=4
set tabstop=4
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
set listchars=eol:¬,tab:»·,nbsp:·,trail:·,extends:…,precedes:…
set colorcolumn=80

set termguicolors
colorscheme base16-default-dark

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
lua << EOF
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
	require'lsp_signature'.on_attach()
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	-- Mappings.
	local opts = { noremap=true, silent=true }
	buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
	buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '<leader>ld', '<cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<cr>', opts)

	-- Set autocommands conditional on server_capabilities
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec([[
		hi LspReferenceRead cterm=bold ctermbg=red guibg=Gray
		hi LspReferenceText cterm=bold ctermbg=red guibg=Gray
		hi LspReferenceWrite cterm=bold ctermbg=red guibg=Gray
		]], false)
		buf_set_keymap('n', '<C-h>', '<cmd>lua vim.lsp.buf.document_highlight()<CR>', opts)
	end

	-- Set some keybinds conditional on server capabilities
	if client.resolved_capabilities.document_formatting then
		buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	end
	if client.resolved_capabilities.document_range_formatting then
		buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
	end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = {
	'documentation',
	'detail',
	'additionalTextEdits',
	}
}

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
local servers = { "clangd", "gopls", "tsserver", "html", "cssls", "pyls", "rust_analyzer" }
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup { on_attach = on_attach, capabilities = capabilities }
end
EOF

" Markdown
command PdfConvert !pandoc --pdf-engine=xelatex -o "%:p:h/%:t:r.pdf" "%:p:h/%:t" --filter pandoc-crossref
command PdfOpen !xdg-open "%:p:h/%:t:r.pdf" &
autocmd FileType vimwiki,markdown setlocal colorcolumn=0
autocmd FileType vimwiki,markdown setlocal listchars=eol:¬,tab:\ \ ,nbsp:·,trail:·,extends:…,precedes:…
autocmd FileType vimwiki,markdown nnoremap <buffer> <leader>tp :Topdf<CR>
autocmd FileType vimwiki,markdown nnoremap <buffer> <leader>op :silent Openpdf<CR>
