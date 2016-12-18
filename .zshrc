set number
set relativenumber
hi clear Conceal
set nocompatible " vim not vi
filetype off " required for Vundle

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'christoomey/vim-tmux-navigator'
Plugin 'jeffkreeftmeijer/vim-numbertoggle'

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" NERDTree
" Plugin 'scrooloose/nerdtree'
" Plugin 'ryanoasis/vim-devicons'
" let NERDTreeHijackNetrw=1
Plugin 'tpope/vim-vinegar'

Plugin 'itchyny/lightline.vim'
" Plugin 'bling/vim-airline'

Plugin 'kien/rainbow_parentheses.vim'
Plugin 'ctrlpvim/ctrlp.vim'

Plugin 'chriskempson/base16-vim'

Plugin 'petrushka/vim-sage'

Plugin 'shougo/vimproc.vim'
Plugin 'shougo/neocomplete.vim'

" ColorSchemes
Plugin 'flazz/vim-colorschemes'

" Git
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'

" Haskell
" Plugin 'eagletmt/ghcmod-vim'
" Plugin 'eagletmt/neco-ghc'
Plugin 'dag/vim2hs'
let g:haskell_conceal_wide = 1
set nofoldenable

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>


call vundle#end()     		" required for Vundler
filetype plugin indent on 	" required for Vundler

syntax enable
" colorscheme base16-default-dark
" set background=dark
" set cursorline
highlight MatchParen cterm=none ctermfg=white

set clipboard=unnamed

set hidden

set noshowmode

set splitbelow

set splitright

set hlsearch
set incsearch
" ignores case when searching except when pattern is all uppercase
set ignorecase smartcase

set tabstop=2
set softtabstop=2
set shiftwidth=2
set backspace=1

set expandtab
set smarttab
set autoindent

" briefly jump to matching parenthesis
set showmatch

set wrap
" set linebreak

" set colorcolumn=101

set ttyfast

set mouse=a

set switchbuf=useopen

set shell=zsh

set scrolloff=3

set nobackup

set backspace=indent,eol,start

set showcmd
set wildmenu

set autoread

" Remove trailing whitespaces
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

"spell checking and automatic wrapping at 72 columns for commits.
autocmd Filetype gitcommit setlocal spell textwidth=72

" Yanking between vim sessions
vmap <silent> ,y y:new<CR>:call setline(1,getregtype())<CR>o<Esc>P:wq! ~/.vim/.reg.txt<CR>
nmap <silent> ,y :new<CR>:call setline(1,getregtype())<CR>o<Esc>P:wq! ~/.vim/.reg.txt<CR>
map <silent> ,p :sview ~/.vim/.reg.txt<CR>"zdddG:q!<CR>:call setreg('"', @", @z)<CR>p
map <silent> ,P :sview ~/.vim/.reg.txt<CR>"zdddG:q!<CR>:call setreg('"', @", @z)<CR>P

" neocomplete plugin
let g:neocomplete#enable_at_startup = 1

 " Fuzzy search by filename
 let g:ctrlp_by_filename = 1

 " Reduce delay in Esc mode switching
 set ttimeoutlen=50

 " Lightline
 set laststatus=2
 let g:lightline = {
 	\ 'colorscheme': 'powerline',
 	\ 'active': {
 	\    'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
 	\    'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileenconding', 'filetype' ] ]
 	\ },
 	\ 'component_function': {
 	\    'fugitive': 'LightLineFugitive',
 	\    'filename': 'LightLineFilename',
 	\    'fileformat': 'LightLineFileformat',
 	\    'filetype': 'LightLineFiletype',
 	\    'fileenconding': 'LightLineFileenconding',
 	\    'mode': 'LightLineMode',
 	\    'ctrlpmark': 'CtrlPMark',
 	\ },
 	\ 'component_expand': {
 	\    'syntastic': 'SynstasticStatuslineFlag',
 	\ },
 	\ 'component_type': {
 	\    'syntastic': 'error',
 	\ },
 	\ 'subseparator': { 'left': '|', 'right': '|' }
 	\ }

 function! LightLineModified()
   return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
 endfunction

 function! LightLineReadonly()
   return &ft !~? 'help' && &readonly ? 'RO' : ''
 endfunction

 function! LightLineFilename()
   let fname = expand('%:t')
   return fname == 'ControlP' ? g:lightline.ctrlp_item :
         \ fname == '__Tagbar__' ? g:lightline.fname :
         \ fname =~ '__Gundo\|NERD_tree' ? '' :
         \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
         \ &ft == 'unite' ? unite#get_status_string() :
         \ &ft == 'vimshell' ? vimshell#get_status_string() :
         \ ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
         \ ('' != fname ? fname : '[No Name]') .
         \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
 endfunction

 function! LightLineFugitive()
   try
     if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
       let mark = ''  " edit here for cool mark
       let _ = fugitive#head()
       return strlen(_) ? mark._ : ''
     endif
   catch
   endtry
   return ''
 endfunction

 function! LightLineFileformat()
   return winwidth(0) > 70 ? &fileformat : ''
 endfunction

 function! LightLineFiletype()
   return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
 endfunction

 function! LightLineFileencoding()
   return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
 endfunction

 function! LightLineMode()
   let fname = expand('%:t')
   return fname == '__Tagbar__' ? 'Tagbar' :
         \ fname == 'ControlP' ? 'CtrlP' :
         \ fname == '__Gundo__' ? 'Gundo' :
         \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
         \ fname =~ 'NERD_tree' ? 'NERDTree' :
         \ &ft == 'vimshell' ? 'VimShell' :
         \ winwidth(0) > 60 ? lightline#mode() : ''
 endfunction

 function! CtrlPMark()
   if expand('%:t') =~ 'ControlP'
     call lightline#link('iR'[g:lightline.ctrlp_regex])
     return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
           \ , g:lightline.ctrlp_next], 0)
   else
     return ''
   endif
 endfunction

 let g:ctrlp_status_func = {
       \ 'main': 'CtrlPStatusFunc_1',
       \ 'prog': 'CtrlPStatusFunc_2',
       \ }

 function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
   let g:lightline.ctrlp_regex = a:regex
   let g:lightline.ctrlp_prev = a:prev
   let g:lightline.ctrlp_item = a:item
   let g:lightline.ctrlp_next = a:next
   return lightline#statusline(0)
 endfunction

 function! CtrlPStatusFunc_2(str)
   return lightline#statusline(0)
 endfunction

 let g:tagbar_status_func = 'TagbarStatusFunc'

 function! TagbarStatusFunc(current, sort, fname, ...) abort
   let g:lightline.fname = a:fname
   return lightline#statusline(0)
 endfunction

 let g:unite_force_overwrite_statusline = 0
 let g:vimfiler_force_overwrite_statusline = 0
 let g:vimshell_force_overwrite_statusline = 0

" Map Caps Lock to Esc
imap jj <Esc>
set timeoutlen=300

" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>

" Sage
autocmd BufRead,BufNewFile,BufWritePost *.sage set filetype=python
autocmd BufRead,BufNewFile,BufWritePost *.spyx,*.pyx set filetype=python.c

