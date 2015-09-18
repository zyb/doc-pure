" General "{{{
set nocompatible	" bundle need, be iMproved, required
filetype off	" bundle need, required

syntax on	" Enable syntax highlighting
" set term=color_xterm
set ffs=unix	" Default to Unix LF line endings
set history=4096	" Number of things to remember in history.
set cursorline	" 光标高亮显示
set cursorcolumn	" 光标垂直高亮
" set mouse=a	"支持鼠标滚轮,但会导致中键的粘贴作用无效
" set whichwrap=b,s,<,>,[,] "让退格，空格，上下箭头遇到行首行尾时自动移到下一行（包括insert模式）
autocmd! bufwritepost .vimrc source ~/.vimrc " auto reload vimrc when editing it
set paste

set ignorecase	" Do case in sensitive matching with
set smartcase	" be sensitive when there's a capital letter
set hlsearch	" highlight search
set incsearch
" "}}}

" Formatting "{{{
" set fo-=o " Do not automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode.
" set fo-=r " Do not automatically insert a comment leader after an enter
" set fo-=t " Do no auto-wrap text using textwidth (does not apply to comments)

" set nowrap
set textwidth=0	" Don't wrap lines by default
set tabstop=2
set softtabstop=2
set shiftwidth=2

set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
" "}}}

" colors "{{{
colorscheme molokai
let g:molokai_original = 1
let g:rehash256 = 1
"}}}

" bad habit "{{{
" using the arrow keys is a bad habit
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" faster
" noremap h <NOP>
" noremap j <NOP>
" noremap k <NOP>
" noremap l <NOP>
"}}}

" Bundle "{{{
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Plugin 'Powerline'
" Plugin 'powerline/powerline'
" set laststatus=2
" set t_Co=256
" let g:Powerline_symbols = 'unicode'
" set encoding=utf8
" set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}

Plugin 'scrooloose/nerdtree'
map <A-h> :NERDTreeToggle<CR>
let NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.obj$', '\.o$', '\.so$', '\.egg$', '^\.git$', '^\.svn$', '^\.hg$' ]
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | end	" close vim if the only window left open is a NERDTree

Plugin 'majutsushi/tagbar'
map <A-l> :TagbarToggle<CR>
" let g:tagbar_autofocus = 1

Plugin 'fatih/vim-go'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
" "}}}

" Bundle example&help "{{{ 
"
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" > Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" > Plugin 'L9'
" Git plugin not hosted on GitHub
" > Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" > Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" > Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
" > Plugin 'user/L9', {'name': 'newL9'}
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
" see :h vundle for more details or wiki for FAQ
