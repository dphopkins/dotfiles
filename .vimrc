" Manage plugins
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'jhuttner/pbcopy.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tpope/vim-commentary'
Plugin 'tomasr/molokai'
" Plugin 'Shougo/deoplete.nvim'
" Plugin 'davidhalter/jedi-vim'
" Plugin 'zchee/deoplete-jedi'
Plugin 'neomake/neomake'
Plugin 'ervandew/supertab'
" Plugin 'Yggdroot/indentLine'

call vundle#end()
filetype plugin indent on

" :PluginList           - list configured plugins
" :PluginInstall        - installs plugins
" :PluginUpdate         - updates plugins
" :PluginSearch foo     - searches for foo; append `!` to refresh local cache
" :PluginClean          - removes unused plugins; append `!` to force

" I need scrolling to work in tmux
set mouse=a

" Enable buffer switching w/o saving
set hidden
set confirm

" Change indent line character
" let g:indentLine_char = '|'

" Default scroll behavior
let g:SuperTabDefaultCompletionType = "<c-n>"

" Activate deoplete by default
let g:deoplete#enable_at_startup = 1

" Show docstring in a preview window
let g:deoplete#sources#jedi#show_docstring = 1

" Follow symbolic links in Ctrl-P
let g:ctrlp_follow_symlinks = 1

" " Neomake settings
" let g:neomake_python_enabled_makers = ['flake8']
" let g:neomake_python_flake8_maker = { 'args': ['--ignore=E501,E402'], }
" autocmd BufWritePost * Neomake

" Syntax highlighting
syntax on

" Color scheme
let g:rehash256 = 1
set background=dark
colorscheme molokai

" Buffer commands
" :ls List current buffers
" :b <num> Switch to corresponding buffer (no space needed)
" :b <partial> Switch to first buffer matching the partial name
" :bd Delete buffer
" :bw REALLY delete buffer
nmap <leader>t :enew<CR>
nmap <leader>h :bprevious<CR>
nmap <leader>l :bnext<CR>
nmap <leader>d :bdelete<CR>

" Never hit escape again!
imap jk <Esc>

" Toggle highlight current line (makes nvim syntax mad slow)
nmap <leader>c :set cursorline!<CR>

" More speed
set ttyfast

" Use 256 colors
set t_Co=256

" utf-8 encoding baby!
set encoding=utf-8

" Bye, bye arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Line numbers
set number

" Columns
set ruler

" Get them 80 columns
set colorcolumn=80
highlight ColorColumn ctermbg=8

" Cool tab completion stuff
set wildmenu
set wildmode=list:longest,full
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc

" Highlight search results
set hlsearch
set incsearch

" Make search case insensitive
set ignorecase

" Who wants an 8 character tab? Not me!
set shiftwidth=4
set softtabstop=4

" Who doesn't like auto-indent?
set autoindent
set copyindent

" default: spaces are better than tabs
set expandtab
set smarttab

" Add status line elements to the vim command line (saves a row!)
set laststatus=0
" TODO: have to figure out a truncation method. 100 is not going to work on
" splits %X(sdfsdf%), where X is an int
set rulerformat=%(%f%m%r%=%v\ %l/%L%)

" Set that backspace to work
set backspace=indent,eol,start

" Why backup when you can git?
set nobackup
set noswapfile

" Die annoying beep die!!!
set visualbell
set noerrorbells

function TabsOrSpaces()
    " Determines whether to use spaces or tabs on the current buffer.
    if getfsize(bufname("%")) > 256000
        " if file is very large, just use the default.
        return
    endif

    let numTabs=len(filter(getbufline(bufname("%"), 1, 250), 'v:val =~ "^\\t"'))
    let numSpaces=len(filter(getbufline(bufname("%"), 1, 250), 'v:val =~ "^ "'))

    if numTabs > numSpaces
        setlocal noexpandtab
        setlocal nosmarttab
    endif
endfunction

" Call the function after opening a buffer
autocmd BufReadPost * call TabsOrSpaces()

" Map :w!! to allow writing file as sudo if opened normally
cmap w!! w !sudo tee > /dev/null %

" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" Groovy syntax highlighting for Jenkinsfiles
autocmd BufNewFile,BufRead Jenkinsfile setf groovy
