call plug#begin()

" A file system explorer
Plug 'preservim/nerdtree'

" A command-line fuzzy finder (instead of ctrlp)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" A class outline viewer
Plug 'preservim/tagbar'

" Lean & mean status/tabline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'enricobacis/vim-airline-clock'

" Adds file type icons to Vim plugins
Plug 'ryanoasis/vim-devicons'

" A collection of language packs
Plug 'sheerun/vim-polyglot'

" Asynchronous Lint Engine
Plug 'dense-analysis/ale'

" The LSP client
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" vim-lsp
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
"Plug 'rhysd/vim-lsp-ale'

" A Git wrapper
Plug 'tpope/vim-fugitive'

" A multi-language debugging system
Plug 'puremourning/vimspector'
" Maximizes and restores the current window
Plug 'szw/vim-maximizer'

" Color schemes
" This is a fork of morhetz/gruvbox that attempts to make the Haskell
" and PureScript highlighting a bit more consistent and colourful.
Plug 'dkasak/gruvbox'

" Auto close pair of characters
Plug 'Townk/vim-autoclose'

" Haskell
" Syntax Highlighting and Indentation for Haskell and Cabal
Plug 'neovimhaskell/haskell-vim'

" Erlang
Plug 'vim-erlang/vim-erlang-omnicomplete' " autocompletion
Plug 'vim-erlang/vim-erlang-compiler' " syntax checking and compiler
Plug 'vim-erlang/vim-erlang-runtime' " indentation, syntax and ftplugin scripts
Plug 'vim-erlang/vim-erlang-tags' " creates a tags file

" C
Plug 'mrtazz/DoxygenToolkit.vim'

" Python
" The jedi autocompletion library
Plug 'davidhalter/jedi-vim'

" Integration between Vim and Jupyter
Plug 'jupyter-vim/jupyter-vim'

" Initialize plugin system
call plug#end()

" LEADER KEY SETTINGS - MUST BE DEFINED BEFORE ANY MAPPINGS!
" These settings define the prefix keys for custom mappings.
let mapleader=","
let maplocalleader=","

" TAGS SETTINGS
set tags=tags;
set tags^=$HOME/trunk/arch/proj/tags/erlang/otp/lib/tags
set tags^=$HOME/trunk/arch/proj/tags/c/glibc/tags
"set tags^=$HOME/trunk/arch/proj/tags/c/linux-6.10.8/tags

" ==========================================================================
" Plugins
" ==========================================================================

" --------------------------------------------------------------------------
" nerdtree
" --------------------------------------------------------------------------
map <C-n> :NERDTreeToggle<CR>
map <Leader>n :NERDTreeFind<CR> " Reveal current file in NERDTree

" --------------------------------------------------------------------------
" fzf
" --------------------------------------------------------------------------
nmap ; :Buffers<CR>           " Search open buffers
nmap <Leader>t :Files<CR>     " Find files in project
nmap <Leader>r :Tags<CR>      " Search tags (symbols)
nmap <Leader>g :Rg<CR>        " Search text in files (ripgrep)
nmap <Leader>l :Lines<CR>     " Search lines in buffers
nmap <Leader>h :History<CR>   " Search command history
nmap <Leader>c :Commits<CR>   " Search git commits (requires fugitive)

" --------------------------------------------------------------------------
" tagbar (uses the tags above)
" --------------------------------------------------------------------------
map <Leader>rr :TagbarToggle<CR>

let g:tagbar_type_haskell = {
    \ 'ctagsbin'  : 'hasktags',
    \ 'ctagsargs' : '-x -c -o-',
    \ 'kinds'     : [
        \  'm:modules:0:1',
        \  'd:data: 0:1',
        \  'd_gadt: data gadt:0:1',
        \  't:type names:0:1',
        \  'nt:new types:0:1',
        \  'c:classes:0:1',
        \  'cons:constructors:1:1',
        \  'c_gadt:constructor gadt:1:1',
        \  'c_a:constructor accessors:1:1',
        \  'ft:function types:1:1',
        \  'fi:function implementations:0:1',
        \  'i:instance:0:1',
        \  'o:others:0:1'
    \ ],
    \ 'sro'        : '.',
    \ 'kind2scope' : {
        \ 'm' : 'module',
        \ 'c' : 'class',
        \ 'd' : 'data',
        \ 't' : 'type',
        \ 'i' : 'instance'
    \ },
    \ 'scope2kind' : {
        \ 'module'   : 'm',
        \ 'class'    : 'c',
        \ 'data'     : 'd',
        \ 'type'     : 't',
        \ 'instance' : 'i'
    \ }
\ }

" --------------------------------------------------------------------------
" vim-airline
" --------------------------------------------------------------------------
" Enable Powerline symbols (requires patched font)
let g:airline_powerline_fonts = 1
let g:airline_theme = 'gruvbox'
let g:airline#extensions#tabline#enabled = 1
" Show only filename (without path) in tabline
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#buffer_nr_show = 1      " Show buffer numbers
let g:airline#extensions#tabline#show_buffers = 1        " Show all buffers
let g:airline#extensions#clock#format = '%H:%M'          " 24-hour clock
let g:airline#extensions#branch#enabled = 1              " Git branch info

" --------------------------------------------------------------------------
" vim-devicons
" --------------------------------------------------------------------------
" Set Vim font to a Nerd Font
" set guifont=AnonymicePro\ Nerd\ Font\ Mono\ 11

let g:webdevicons_enable = 1                    " Enable globally
let g:webdevicons_enable_nerdtree = 1           " NERDTree icons
let g:webdevicons_conceal_nerdtree_brackets = 1 " Cleaner NERDTree look
let g:webdevicons_enable_airline_tabline = 1    " Airline tabline icons
let g:webdevicons_enable_airline_statusline = 1 " Airline statusline icons
let g:webdevicons_enable_fzf = 1                " FZF icons
" File format specific icons
let g:WebDevIconsUnicodeDecorateFileNodes = 1   " Unicode icons
let g:WebDevIconsUnicodeGlyphDoubleWidth = 1    " Proper spacing
" Performance optimization
let g:WebDevIconsUnicodeDecorateFileNodesDefaultSymbol = 'ƒ'

" --------------------------------------------------------------------------
" ale
" --------------------------------------------------------------------------
" ALE integration with Erlang, C/C++.
" Enable only a particular set of linters for a file.
let g:ale_linters = {
    \ 'erlang': ['dialyzer', 'erlc'],
    \ 'cpp': ['ccls'],
    \ 'c': ['ccls']
\ }
let g:ale_erlang_erlc_options = "$(find . -type d -exec echo '-I {}' ';')"

" ALE quickfix
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
" ALE navigation between warnings and errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" ALE + Coc
let g:ale_disable_lsp = 1
let g:ale_completion_enabled = 0

" Completely disable ALE
"let g:ale_enabled = 0

" --------------------------------------------------------------------------
" coc.nvim
" --------------------------------------------------------------------------
" Fix coc.nvim localStorage issue with Node.js 25+
let g:coc_node_args = [
    \ '--localstorage-file=~/.local/share/nvim/coc-storage.json'
\ ]

" Preventing delays (default is 4000 ms = 4s)
set updatetime=300 

" Better completion experience
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <silent><expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"

" Navigate between errors and warnings
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Rename symbol and update all references
nmap <leader>rn <Plug>(coc-rename)

" Format code (entire file or selected range)

" Fast formatting: direct clang-format call (text-based, very fast)
nmap <leader>f :%!clang-format -style=file<CR>
vmap <leader>f :!clang-format -style=file<CR>
" Smart formatting: LSP-powered (context-aware, slower)
"nmap <leader>F <Plug>(coc-format-selected)
"xmap <leader>F <Plug>(coc-format-selected)

" Show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" COC EXTENSIONS STRATEGY
" Auto-setup: via coc-* extensions (:CocInstall + :CocCommand)
" Manual: via system LSP (pacman) + coc-settings.json
" Current: Manual LSP setup, coc-* for utilities
let g:coc_global_extensions = [
    \ 'coc-snippets',
    \ 'coc-json',
    \ 'coc-marketplace',
    \ 'coc-lists',
    \ 'coc-git',
    \ 'coc-fzf-preview'
\ ]

" --------------------------------------------------------------------------
" vim-lsp
" --------------------------------------------------------------------------
" Erlang Language Platform (ELP)
if executable('elp')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'elp',
        \ 'cmd': {server_info->['elp', 'server']},
        \ 'allowlist': ['erlang'],
        \ })
endif

" --------------------------------------------------------------------------
" vimspector
" --------------------------------------------------------------------------
let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_base_dir = expand('$HOME/.vim/plugged/vimspector')

" Vimspector mappings
"
" for normal mode - the word under the cursor
nmap <Leader>di <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <Leader>di <Plug>VimspectorBalloonEval
" for navigating up/down the stack
nmap <LocalLeader><F11> <Plug>VimspectorUpFrame
nmap <LocalLeader><F12> <Plug>VimspectorDownFrame
nmap <LocalLeader>B     <Plug>VimspectorBreakpoints
nmap <LocalLeader>D     <Plug>VimspectorDisassemble

" --------------------------------------------------------------------------
" haskell-vim
" --------------------------------------------------------------------------
" Features
let g:haskell_enable_quantification = 1   " highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " highlighting of type roles
let g:haskell_enable_static_pointers = 1  " highlighting of `static`
let g:haskell_backpack = 1                " highlighting of backpack keywords
" Highlighting
let g:haskell_classic_highlighting = 1
"let g:haskell_disable_TH = 1
" Indentation
let g:haskell_indent_if = 4
let g:haskell_indent_case = 4
let g:haskell_indent_let = 4
let g:haskell_indent_where = 4
let g:haskell_indent_before_where = 4
let g:haskell_indent_after_bare_where = 4
let g:haskell_indent_do = 4
let g:haskell_indent_in = 4
let g:haskell_indent_guard = 4
"let g:haskell_indent_disable = 1
let g:cabal_indent_section = 4

" --------------------------------------------------------------------------
" DoxygenToolkit.vim
" --------------------------------------------------------------------------
let g:DoxygenToolkit_authorName = "Denis Khorkin"
let g:DoxygenToolkit_licenseTag = "BSD-3-Clause License"
let g:DoxygenToolkit_briefTag_pre = "@brief "
let g:DoxygenToolkit_paramTag_pre = "@param "
let g:DoxygenToolkit_returnTag = "@return "

autocmd BufRead,BufNewFile Doxyfile set filetype=dosini

" --------------------------------------------------------------------------
" jupyter-vim
" --------------------------------------------------------------------------
" Pointer to the Python interpreter
set pyxversion=3

" Keybindings (:h map-modes)
" Connect to Jupyter
nnoremap <buffer> <silent> <localleader>J :JupyterConnect<CR>
" Run current file
nnoremap <buffer> <silent> <localleader>R :JupyterRunFile<CR>
nnoremap <buffer> <silent> <localleader>I :PythonImportThisFile<CR>
" Change to directory of current file
nnoremap <buffer> <silent> <localleader>d :JupyterCd %:p:h<CR>
" Send a selection of lines
nnoremap <buffer> <silent> <localleader>X :JupyterSendCell<CR>
nnoremap <buffer> <silent> <localleader>E :JupyterSendRange<CR>
nmap     <buffer> <silent> <localleader>e <Plug>JupyterRunTextObj
vmap     <buffer> <silent> <localleader>e <Plug>JupyterRunVisual
" Debugging maps
nnoremap <buffer> <silent> <localleader>b :PythonSetBreak<CR>
" Preventing the default keybindings
let g:jupyter_mapkeys = 0

" ==========================================================================
" Basics
" ==========================================================================
syntax on
filetype plugin indent on
colorscheme gruvbox
set background=dark
set number          " Show line numbers
set cursorline      " Highlight current line
set showcmd
set showmode
set colorcolumn=80
"match ErrorMsg '\%>80v.\+' " Line length marker

" Performance optimizations (for all file types)
set synmaxcol=200

set tabstop=4       " A tab is 4 spaces
set softtabstop=4   " Insert 4 spaces when tab is pressed
set shiftwidth=4    " An indent is 4 spaces
set expandtab       " Always uses spaces instead of tabs
set shiftround      " Round indent to nearest shiftwidth multiple

set hlsearch        " Highlight all search matches
set incsearch       " Incremental search

set encoding=utf8   " Sets the character encoding to UTF-8 to show glyphs

" Show non-printable characters
" In insert mode, we can use ctrl-vuXXXX (XXXX in hex format).
" In order to enter nbsp character, we have to enter ctrl-vu00A0.
set list lcs=trail:·,tab:»·,nbsp:␣

set mouse=nv        " Enable the use of the mouse (Normal and Visual modes)

" --------------------------------------------------------------------------
" C/C++ specific settings
" --------------------------------------------------------------------------

" File type detection: treat .h as C, not C++
augroup filetypedetect
    au! BufRead,BufNewFile *.h  setfiletype c
augroup END

" C-indenting
set autoindent      " Use indent from previous line
set smartindent     " Recognize C syntax for indentation
" cindent is more precise for C/C++ (overrides smartindent)
autocmd FileType c,cpp setlocal cindent
" Fine-tune cindent options
"   :N  - case labels align with switch
"   gN  - access specifiers align with class
"   +N  - continuation lines align with start
"   iN  - init list align with parent
"   (N  - unclosed parentheses indent
"   jN  - lambda formatting (1 = enable)
autocmd FileType c,cpp setlocal cinoptions=:0,g0,+0,i0,(0,j1

autocmd FileType cpp setlocal commentstring=//\ %s  " gc: visual comment
" folding: zo=open, zc=close, zR=open all, zM=close all, za=toggle
autocmd FileType cpp setlocal foldmethod=syntax
" mapping format: [mode] [args] {lhs} {rhs}
"   lhs = trigger
"   rhs = commands to run
autocmd FileType cpp nnoremap <buffer> <Leader>b :w<CR>
    \ :!g++ -std=c++20 -Wall -Wextra -pedantic -o %:r *.cpp && ./%:r<CR>
