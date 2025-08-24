set nocompatible    " Prefer vim behaviour over vi when both have default values
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'mileszs/ack.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'dense-analysis/ale'
Plugin 'majutsushi/tagbar'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rails'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'ayu-theme/ayu-vim'
Plugin 'leafgarland/typescript-vim'

call vundle#end()

if has('autocmd')
  filetype plugin indent on " Identation based on file type
endif

syntax on

"set nocompatible    " Prefer vim behaviour over vi when both have default values
set encoding=utf-8  " File encoding to utf-8
set cursorline      " Highlight the current line
set hidden          " Hide buffer instead of close when abandoned
set laststatus=2    " Always display file status (name, lines, percentage...)
" set nobackup        " No backup file
set backupcopy=yes
set noswapfile      "
set relativenumber  " Show line number relative to current line
set visualbell      " No beep
set noerrorbells    "
set number          " Display line numbers...
set relativenumber  " ...relative to current line
set numberwidth=3   " Number of columns to show line numbers
set colorcolumn=80  " Display a column with different color in column 80
set scrolloff=3     " Provide 3 lines of context above and below cursor
set title           " Set filename in title
set showcmd         " Display command you are typing
set smartindent     " Self explanatory

" List chars
set list
set listchars=tab:▸\
set listchars+=eol:¬
set listchars+=extends:»
set listchars+=precedes:«

" Identation
set tabstop=2                   " The tab width is 2...
set shiftwidth=2                " ...spaces
set expandtab                   " Use spaces, not tabs
set nowrap                      " Dont show line when exceed the window size
set backspace=indent,eol,start  " Delete things the right way in insert mode

" Search
set hlsearch           " Highlight the current search
set incsearch          " Incremental search
set ignorecase         " Case insensitive when searching...
set smartcase          " ...except when using upcase characters
set gdefault           " When replacing, substitute all ocurrences in a line
nnoremap <CR> :noh<CR> " Remove search highlight when pressing Enter key

" Indentation for specific projects
" augroup ProjectSetup
" au BufRead,BufEnter /Users/laura/Code/kenaro/web set noet sts=2 cindent
" augroup END

" Terminal and GUI-specific settings
if has('gui_macvim')
  set transparency=5
  " set guifont=Monaco:h12
  set guifont=Monaco\ for\ Powerline:h12
  set guioptions-=T "Removes top toolbar
  set guioptions-=r "Removes right hand scrollbar
  set guioptions-=L "Removes left hand scrollbar
else
  " Terminal-specific improvements
  " Detect if we're on a server (no DISPLAY, SSH connection, etc.)
  let g:is_server = !exists('$DISPLAY') || exists('$SSH_CLIENT') || exists('$SSH_TTY') || $TERM == 'linux'

  " Conservative color support for servers
  if g:is_server
    " " Use 256 colors for better compatibility on servers
    " set t_Co=256
    " " Disable true colors on servers as they often don't support it
    " set notermguicolors
  else
    " Enable true color support if terminal supports it (local terminals)
    if has('termguicolors') && ($COLORTERM == 'truecolor' || $COLORTERM == '24bit' || $TERM_PROGRAM == 'iTerm.app' || $TERM_PROGRAM == 'Apple_Terminal')
      set termguicolors
    else
      set t_Co=256
    endif
  endif

  " Fix background color erase for terminals
  if &term =~# '^screen\|^tmux' && exists('&t_BE')
    set t_BE=
  endif
endif

" Color scheme setup with server-aware fallbacks
if exists('g:is_server') && g:is_server
  try
    set termguicolors
    let ayucolor="dark"
    colorscheme ayu
  catch
    try
      colorscheme slate
    catch
      try
        colorscheme darkblue
      catch
        colorscheme default
      endtry
    endtry
  endtry
else
  " Local terminal - try ayu first
  let ayucolor="dark" " for mirage version of theme
  try
    colorscheme ayu
  catch
    " Fallback to server-friendly schemes
    try
      colorscheme desert
    catch
      try
        colorscheme slate
      catch
        colorscheme default
      endtry
    endtry
  endtry
endif
" colorscheme lightning

" Source the vimrc file after saving it
augroup reload_vimrc " {
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

let mapleader=',' " Use comma as <Leader> key instead of \

" General remapings
imap jj    <Esc>

" Buffer remapings
nnoremap <Leader>w <C-w>v<C-w>l " Open a vertical window and switch over it
nnoremap <Leader>W <C-w>s<C-w>j " Open a horizontal window and switch over it
nmap <Tab> <C-w>w

" Tagbar remaping
map <Leader>t :TagbarToggle<CR>

" Plugin configurations
" Airline configuration - enhanced for terminal support
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" Server-aware airline configuration
if exists('g:is_server') && g:is_server
  " Always use ASCII on servers (no powerline fonts available)
  let g:airline_powerline_fonts = 0
  let g:airline_left_sep = '|'
  let g:airline_left_alt_sep = '|'
  let g:airline_right_sep = '|'
  let g:airline_right_alt_sep = '|'
  let g:airline_symbols.branch = 'BR:'
  let g:airline_symbols.readonly = 'RO'
  let g:airline_symbols.linenr = 'LN:'
  let g:airline_symbols.maxlinenr = ''
  let g:airline_symbols.dirty = '*'
  let g:airline_symbols.paste = 'PASTE'
  let g:airline_symbols.spell = 'SPELL'
  let g:airline_symbols.notexists = '?'
  let g:airline_symbols.whitespace = '!'
elseif has('gui_running') || ($TERM_PROGRAM == 'iTerm.app') || ($TERM_PROGRAM == 'Apple_Terminal') || ($TERMINAL_EMULATOR == 'JetBrains-JediTerm')
  " Use powerline fonts on local machines with proper terminal support
  let g:airline_powerline_fonts = 1
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_symbols.branch = ''
  let g:airline_symbols.readonly = ''
  let g:airline_symbols.linenr = '☰'
  let g:airline_symbols.maxlinenr = ''
  let g:airline_symbols.dirty='⚡'
else
  " Fallback to clean ASCII characters for other terminals
  let g:airline_powerline_fonts = 0
  let g:airline_left_sep = '>'
  let g:airline_left_alt_sep = '>'
  let g:airline_right_sep = '<'
  let g:airline_right_alt_sep = '<'
  let g:airline_symbols.branch = 'BR:'
  let g:airline_symbols.readonly = 'RO'
  let g:airline_symbols.linenr = 'LN:'
  let g:airline_symbols.maxlinenr = ''
  let g:airline_symbols.dirty = '*'
endif

let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

" Invoke CtrlP
map <Leader>f :CtrlP<CR>
"map <Leader>b :CtrlPBuffer<CR>
"map <Leader>m :CtrlPMRU<CR>

let g:ctrlp_custom_ignore = {
  \ 'dir': '\v[\/](\.git|node_modules|dist|log)$',
  \ 'file': '\v\.(DS_Store)$'
  \ }

" Tagbar
let g:tagbar_left=1

" ALE
let g:ale_fixers = {
  \  '*': ['remove_trailing_lines', 'trim_whitespace'],
  \  'ruby': ['rubocop'],
  \}

let g:ale_fix_on_save = 1

let g:ale_sign_warning = "!"
let g:ale_sign_error = "✗"
