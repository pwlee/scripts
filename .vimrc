" ----------------------------------------------------------------
" ------------------------- vim settings -------------------------
" ----------------------------------------------------------------

" General
set number	        " Show line numbers
set relativenumber      " Show relative line numbers
set linebreak	        " Break lines at word (requires Wrap lines)
set showbreak=+++	" Wrap-broken line prefix
set textwidth=100	" Line wrap (number of cols)
set showmatch	        " Highlight matching brace
 
set hlsearch	        " Highlight all search results
set smartcase	        " Enable smart-case search
set incsearch	        " Searches for strings incrementally
 
set autoindent	        " Auto-indent new lines
set expandtab	        " Use spaces instead of tabs
set shiftwidth=4	" Number of auto-indent spaces
set smartindent         " Enable smart-indent
set smarttab	        " Enable smart-tabs
set softtabstop=4	" Number of spaces per Tab
 
" Advanced
set ruler	        " Show row and column ruler information
set undolevels=1000	" Number of undo levels
set backspace=indent,eol,start	" Backspace behaviour

" Key mappings
noremap <C-n> :NERDTreeToggle<CR>
noremap <C-_> :NERDTreeFind<CR>
noremap <C-p> :FZF<CR>

" ----------------------------------------------------------------
" ----------------------- vim plug plugins -----------------------
" ----------------------------------------------------------------

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf'
Plug 'terryma/vim-multiple-cursors'
Plug 'preservim/nerdtree'
Plug 'morhetz/gruvbox'

call plug#end()

augroup NERDTree
    au!
 
    let NERDTreeShowHidden=1

    " Auto-start NERDTree when opening vim
    autocmd VimEnter * NERDTree 

    " Auto-start NERDTree when opening new tabs
    autocmd BufWinEnter * NERDTreeMirror | wincmd p 
 
    " Set focus window to NERDTree if no file or a directory was specified
    autocmd VimEnter * if argc() == 1 && !isdirectory(argv()[0]) | wincmd p | endif
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | wincmd p | ene | exe 'cd '.argv()[0] | wincmd p | endif

    " Close vim if NERDTree is the only tab open
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    " Prevent opening files in NERDTree buffer
    autocmd FileType nerdtree let t:nerdtree_winnr = bufwinnr('%')
    autocmd BufWinEnter * call PreventBuffersInNERDTree()

    function! PreventBuffersInNERDTree()
      if bufname('#') =~ 'NERD_tree' && bufname('%') !~ 'NERD_tree'
        \ && exists('t:nerdtree_winnr') && bufwinnr('%') == t:nerdtree_winnr
        \ && &buftype == '' && !exists('g:launching_fzf')
        let bufnum = bufnr('%')
        close
        exe 'b ' . bufnum
        NERDTree
        wincmd p
      endif

      if exists('g:launching_fzf') | unlet g:launching_fzf | endif

    endfunction
augroup END

" Configure FZF to open in window
let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.5, 'yoffset': 1, 'border': 'top' } }

" Set gruvbox dark theme when starting vim
autocmd vimenter * colorscheme gruvbox
set background=dark    " Setting dark mode
