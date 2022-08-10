if &shell =~# 'fish$'
    set shell=sh
endif

" 80-char line coloring
if exists('+colorcolumn')
    set colorcolumn=80
endif

augroup NoTrailingWhitespace
    " Remove all trailing whitespace
    autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif
augroup end

" Restore cursor position when opening file
augroup JumpCursorOnEdit
    au!
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |
        \ exe "normal! g`\"" |
        \ endif
augroup end

if exists('+undofile')
    " undofile - This allows you to use undos after exiting and restarting
    " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
    " :help undo-persistence
    " This is only present in 7.3+
    if isdirectory($HOME . '/.vim/undo') == 0
        :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
    endif
    set undodir=./.vim-undo//
    set undodir+=~/.vim/undo//
    set undofile
endif

" Automatically set paste on Ctrl+Shift+V (https://coderwall.com/p/if9mda/)
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

" Plugins!
call plug#begin()

" Plug 'andreypopp/vim-colors-plain'
" Plug 'aradunovic/perun.vim'
" Plug 'dracula/vim', { 'as': 'dracula' }
" Plug 'arcticicestudio/nord-vim'
Plug 'ayu-theme/ayu-vim'
" LaTeX tools
Plug 'lervag/vimtex'
" Go tools
" Plug 'fatih/vim-go'
" Autocompletion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Fuzzy file finder FZF
Plug 'junegunn/fzf.vim'
" Fish syntax highlighting
Plug 'dag/vim-fish'
" Jade syntax highlighting
" Plug 'statianzo/vim-jade'
Plug 'vim-scripts/indentpython.vim' " Python indentation
Plug 'zchee/deoplete-jedi' " Python autocomplete
Plug 'nvie/vim-flake8' " Python syntax checking
" JS syntax and indentation
" Plug 'pangloss/vim-javascript'
" JS autocomplete
" Plug 'carlitux/deoplete-ternjs'
" Pug syntax and indentation
" Plug 'digitaltoad/vim-pug'
" Agda support
" Plug 'derekelkins/agda-vim'
" Markdown
Plug 'plasticboy/vim-markdown'
" Racket
" Plug 'wlangstroth/vim-racket'
" Haskell
" Plug 'neovimhaskell/haskell-vim'
" LimeLight - highlight only current section
Plug 'junegunn/limelight.vim'
" Goyo - distraction free writing
Plug 'junegunn/goyo.vim'
Plug 'tpope/vim-surround'
" Git diffs.
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lua/plenary.nvim'
Plug 'sindrets/diffview.nvim'
" Git integration.
Plug 'tpope/vim-fugitive'

call plug#end()

"vim general ignores
set wildignore+=*.so,*.swp,*.zip,*.exe,*.dll,*.pyc,*.pdf,*.dvi,*.aux
set wildignore+=*.png,*.jpg,*.gif

" -------------- Global ----------

" Color scheme
set termguicolors                    " Enable GUI colors for the terminal to get truecolor
let ayucolor="dark"
colorscheme ayu

" Shows what you're typing as a command
set showcmd
set foldmethod=indent
set nofoldenable
set foldnestmax=10
set foldlevel=1

" Proper syntax highlighting
filetype plugin indent on
syntax enable

augroup SetFileTypes
    au!
    au BufRead,BufNewFile **.tex set filetype=tex

" Indenting
set smartindent
set autoindent
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set breakindent

" Fix hashtag jumping back.
inoremap # X<BS>#

" Ruler rules
set ruler

" Auto-completion
let g:deoplete#enable_at_startup = 1
call deoplete#custom#var('omni', 'input_patterns', {
        \ 'tex': g:vimtex#re#deoplete
        \})

" Tab for autocompletion
function! SuperTab()
    if (strpart(getline('.'),col('.')-2,1)=~'^\W\?$')
        return "\<Tab>"
    else
        return "\<C-n>"
    endif
endfunction
inoremap <Tab> <C-R>=SuperTab()<CR>

" Better file auto-completion
set wildmode=list:longest,full
set wildmenu

" Enable mouse
set mouse=a

" Casing
set ignorecase
set smartcase

" hl search results
set hlsearch

" When I close a tab, remove the buffer
set nohidden

" Set of the other paren
highlight MatchParen ctermbg=4

" Set 7 lines to the curors when moving vertical
set so=10

" increased search
set incsearch

" It's a kinda
set magic

" show matching bracket
set showmatch

" word wrapping at line breaks
set wrap
set linebreak

" No double spaces when joining lines
set nojoinspaces

" Highlight current line
set cul

" Make backspace work
set backspace=indent,eol,start

" BASH
set shell=bash

" -------- Mappings ----------

"Set the mapleader
let mapleader = ","

" Macro to split line into lines by ". "
let @v = 'vap:s/\. /.\r/g'
'

"Toggle line numbers with leader-l
set number

function! NumberToggle()
  if(&number != 1)
    set number
  else
    set nonumber
  endif
endfunc

nnoremap <leader>l :call NumberToggle()<cr>

" Tab configuration
noremap <leader>tn :tabnew<cr>
noremap <leader>te :tabedit
noremap <leader>tc :tabclose<cr>
noremap <leader>tm :tabmove

" Reselect visual block after indend/outdent
vnoremap < <gv
vnoremap > >gv

"Open last alternate buffer
noremap <leader><leader> <C-^>

"Make Y work like D and C
map Y y$

" Make navigation work as expected
nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap <silent> $ g$
nnoremap <silent> ^ g^
vnoremap <silent> j gj
vnoremap <silent> k gk
vnoremap <silent> $ g$
vnoremap <silent> ^ g^

" navigation in insert mode
inoremap <C-h> <Left>
inoremap <C-j> <esc>gja
inoremap <C-k> <esc>gka
inoremap <C-l> <Right>

" Swap ; and : since you use the last one way more often, so why make it
" harder
nnoremap ; :

"Easier split window navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
nnoremap <up> <C-w>k
nnoremap <down> <C-w>j
nnoremap <left> <C-w>h
nnoremap <right> <C-w>l
" Fix mapping of <C-j> so it doesn't get overwritten
noremap <SID>herrderr <Plug>IMAP_JumpForward

" Opening newlines from insert mode
imap <M-o> <esc>o
imap <C-o> <esc>O

" Better indentation shortcuts that preserve cursor position
nmap <C-t> a<C-t><esc>
nmap <C-d> a<C-d><esc>

" Workaround for https://github.com/neovim/neovim/issues/2048
if has('nvim')
    nmap <BS> <C-W>h
endif

" Better split window opening
set splitbelow
set splitright

" Turn off highlight
noremap <silent><leader>' :nohls<CR>

" Easier comment toggle
map <C-_> <plug>NERDCommenterToggle
vmap <C-_> <plug>NERDCommenterToggle<CR>gv

" Realtime substitute preview.
if exists('&incommand')
    set incommand=nosplit
endif

" Local .vimrc
set exrc
set secure

" Open FZF
command FFZF call fzf#run(fzf#wrap('filtered-fzf', {'source': 'ag --hidden --nocolor -g ""'}, <bang>0))
map <C-P> :FFZF<CR>

" Automatic pep8 checking
autocmd BufWritePost *.py call Flake8()

" Link Goyo and other stuff
function! s:goyo_enter()
    set nu
    Limelight
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave Limelight!

" Fix LaTeX speed
au FileType tex
    \ set nocursorline |
    \ let g:loaded_matchparen=0 |

" VimTeX settings
let maplocalleader="\\"

let g:tex_conceal=""
let conceallevel=0
let g:tex_flavor = 'latex'
let g:vimtex_indent_on_ampersands=0

let g:vimtex_compiler_latexmk = {
    \ 'callback' : 0,
    \}

let g:vimtex_compiler_progname="nvr"
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
