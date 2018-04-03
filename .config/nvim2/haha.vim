"==============================================================================
"|                       PLUGINS INITIALIZATION                               |
"==============================================================================
set nocompatible
filetype off

" Initiate Vundle
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin('~/.config/nvim/bundle')

Plugin 'VundleVim/Vundle.vim'

" EasyMotion - Allows <leader><leader>(b|e) to jump to (b)eginning or (end)
" of words.
Plugin 'easymotion/vim-easymotion'
" Ctrl-P - Fuzzy file search
Plugin 'kien/ctrlp.vim'
" Neomake build tool (mapped below to <c-b>)
Plugin 'benekastah/neomake'
" Remove extraneous whitespace when edit mode is exited
Plugin 'thirtythreeforty/lessspace.vim'
" Nerd Tree and commenter
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
" Buffergator
Plugin 'jeetsukumaran/vim-buffergator'
" Autocomplete for python
Plugin 'davidhalter/jedi-vim'
Plugin 'Shougo/deoplete.nvim'
Plugin 'zchee/deoplete-jedi'
" Working with ipython qtconsole
Plugin 'bfredl/nvim-ipy'
" Status bar mods
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'airblade/vim-gitgutter'

" Tab completion
Plugin 'ervandew/supertab'

" After all plugins...
call vundle#end()
filetype plugin indent on
"call deoplete#enable()
let g:deoplete#enable_at_startup = 1
"==============================================================================
"|                          GENERAL CONFIGURATION                             |
"==============================================================================

""""""" Colorscheme """""""
set background=dark " or light for white-oriented solarized
"colorscheme solarized
colorscheme default
"let g:airline_theme='base16_solarized'
"let g:airline_theme=1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"

""""""" General coding stuff """""""
" Highlight 80th column
"set colorcolumn=80
" Always show status bar
set laststatus=2
" Let plugins show effects after 500ms, not 4s
set updatetime=500
" Disable mouse click to go to position
" set mouse=a
" Don't let autocomplete affect usual typing habits
set completeopt=menuone,preview,noinsert
" Highliting searches
set hlsearch
" Searches start right from start of typing
set incsearch
" Searching ignores cases
set ignorecase
" Chuj wie co to robi
set smartcase
" Don't create backup of file
set nobackup
set nowritebackup
" Don't create swap file
set noswapfile

" folding functions and indented stuff for clear code
set foldmethod=indent
set foldlevel=99
" folding with space
nnoremap <space> za
"==============================================================================
"|                      SuperTab CONFIGURATION                                |
"==============================================================================

"let g:SuperTabDefaultCompletionType = "<c-x><c-u>"
"function! Completefunc(findstart, base)
    "return "\<c-x>\<c-p>"
"endfunction

"call SuperTabChain(Completefunc, '<c-n>')

"let g:SuperTabCompletionContexts = ['g:ContextText2']


"
"==============================================================================
"|                       GitGutter CONFIGURATION                              |
"==============================================================================
"
" Let vim-gitgutter do its thing on large files
let g:gitgutter_max_signs=10000


"==============================================================================
"|                   PYTHON DEVELOPMENT CONFIGURATION                         |
"==============================================================================

" Enable python syntax
syntax enable
set number showmatch
" Automatic indents
set softtabstop=4 autoindent
" Highlight python keywords
let python_highlight_all = 1
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
" Quick running python script in shell
autocmd FileType python nnoremap <buffer> <Leader>r :exec '!clear; python3' shellescape(@%, 1)<cr>
" make jedi-vim use py3
let g:jedi#force_py_version = 3
" virtualenv as python path
let g:python3_host_prog = '/usr/bin/python3.6'
let g:python_host_prog = '/usr/bin/python'
" yapf formatting on leader y
autocmd FileType python nnoremap <leader>y :0,$!yapf<Cr>
" To close preview window of deoplete automagically
autocmd CompleteDone * pclose
"==============================================================================
"|                              KEYBINDINGS                                   |
"==============================================================================

" Set up leaders
let mapleader=","
let maplocalleader="\\"
" Quick exit/save
noremap <Leader>e :quit<CR>
noremap <Leader>E :qa!<CR>

map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

set bs=2

"==============================================================================
"|                                 PLUGINS                                    |
"|                              CONFIGURATION                                 |
"|                               KEYBINDINGS                                  |
"==============================================================================

"==============================================================================
"|                                  CTRLP                                     |
"==============================================================================

" Use a leader instead of the actual named binding
nmap <leader>p :CtrlP<cr>

" Use the nearest .git directory as the cwd
" This makes a lot of sense if you are working on a project that is in version
" control. It also supports works with .svn, .hg, .bzr.
let g:ctrlp_working_path_mode = 'r'

" Easy bindings for its various modes
nmap <leader>bb :CtrlPBuffer<cr>
nmap <leader>bm :CtrlPMixed<cr>
nmap <leader>bs :CtrlPMRU<cr>

" Setup some default ignores for files
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|mp3|mp4|wmv|mkv|webm|wav|dll|class|png|pdf|zip|rar|jpg|jpeg)$',
\}

" Setup some default ignores for paths
set wildignore+=*.pyc
set wildignore+=*build/*
set wildignore+=*dist/*
set wildignore+=*.egg-info/*
set wildignore+=*/coverage/*

" Show hidden files in CtrlP
let g:ctrlp_show_hidden = 1
" Maximum height of CtrlP
let g:ctrlp_max_height = 30
" new splits to the right
set splitright

"==============================================================================
"|                                BUFFERGATOR                                 |
"==============================================================================

" Use the right side of the screen
let g:buffergator_viewport_split_policy = 'L'
" I want my own keymappings...
let g:buffergator_suppress_keymaps = 1
" Looper buffers
"let g:buffergator_mru_cycle_loop = 1
" Go to the previous buffer open
nmap <leader>jj :BuffergatorMruCyclePrev<cr>
" Go to the next buffer open
nmap <leader>kk :BuffergatorMruCycleNext<cr>
" View the entire list of buffers open
nmap <leader>bl :BuffergatorOpen<cr>
" New empty buffer
nmap <leader>T :enew<cr>
" Delete buffer
nmap <leader>bq :bp <BAR> bd #<cr>
" Enable the list of buffers in airline
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
" Powerline fonts for airline
let g:airline_powerline_fonts = 1


"==============================================================================
"          ==================================================
"             =========================================
"==============================================================================



