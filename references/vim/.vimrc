" Use the Solarized Dark theme
set background=dark
colorscheme solarized
"colorscheme lucario
"colorscheme monokai

" Make vim more useful
set nocompatible

" Use the OS clipboard by default (on versions compiled with +clipboard)
set clipboard=unnamed

" Do not create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Enable line numbers
set number

" Enable syntax highlighting
if !exists("g:syntax_on")
    syntax enable
endif

" Highlight current line
"set cursorline

" Set tabs as wide as 4 spaces
set tabstop=4

" Show invisible characters
"set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
"set list

" Highlight searches
set hlsearch

" Ignore case of searches
set ignorecase

" Enable mouse in all modes
set mouse=a

" Show the cursor position
set ruler

" Strip trailing whitespace (,ss)
function! StripWhitespace()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    :%s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

" Automatic commands
if has("autocmd")
    " Enable file type detection
    filetype on
    " Treat .json files as .js
    autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
    " Treat .md files as Markdown
    autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
    " Remove trailing spaces for .c, .cpp, .java, .php
    " autocmd FileType c,cpp,java,php autocmd BufWritePre <buffer> :%s/\s\+$//e
endif

" Move to matching braces
set showmatch

" No line wrappings
set nowrap

" How many columns text is indented with the reindent operations (<< >>)
set shiftwidth=4
set expandtab

" Fix backspace issues
fixdel
set bs=2
set backspace=indent,eol,start

" Auto indenting
set autoindent
filetype indent on
set smartindent
set smarttab

" Set Paste Toggle to paste without any indenting issues
set pastetoggle=<F1>
