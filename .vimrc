set nocompatible

silent! call pathogen#runtime_append_all_bundles()

" Load ftplugins and indent files
filetype plugin on
filetype indent on

" Misc important stuff
set backspace=indent,eol,start  " Allow backspacing over everything in insert mode
set hidden                      " Can change buffer without saving
let mapleader = ","

" GUI-specific
if has("gui_running")
    syntax on
    set guifont=Monaco:h12
    set guioptions=m   " Show menu
    set guioptions+=e  " Use GUI tabline
    set antialias
    colorscheme darktango
endif

" Tabbing and indenting
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set autoindent
autocmd BufReadPost * :DetectIndent
let g:detectindent_preferred_expandtab=1
let g:detectindent_preferred_indent=4

" Matching
set showmatch
set mat=5
set nohlsearch
set incsearch
set ignorecase
set smartcase

" Vim UI
set wildmenu
set wildmode=list:longest
set laststatus=2
"set statusline=%F%M\ %=b%n\ [%l,%v]\ %P
set scrolloff=3      " lines at top/bottom for context
set nowrap
set sidescroll=1
set sidescrolloff=7  " Lines at right/left for context
set list
set listchars=extends:>,precedes:<,tab:>-,trail:-
set fillchars=vert:\ ,stl:\ ,stlnc:\ 
set shortmess=atI

" No bells
set vb t_vb=
set noerrorbells

" When .vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc

" Easier window nav
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l

" Scroll faster
noremap <C-e> 3<C-e>
noremap <C-y> 3<C-y>

" Toggle NERDTree
noremap <leader>d :NERDTreeToggle<CR>


"statusline setup
set statusline=%f       "tail of the filename

"display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%y      "filetype
set statusline+=%r      "read only flag
set statusline+=%m      "modified flag

"display a warning if &et is wrong, or we have mixed-indenting
set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

set statusline+=%{StatuslineTrailingSpaceWarning()}

"display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set laststatus=2

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")
        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let tabs = search('^\t', 'nw') != 0
        let spaces = search('^ ', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        else
            let b:statusline_tab_warning = ''
        endif
    endif
    return b:statusline_tab_warning
endfunction

