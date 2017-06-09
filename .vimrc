"""""""""""
" General "
"""""""""""

" Store path to ~/.vim or ~/vimfile to variable $VIMHOME
if has('win32') || has ('win64') || has('win16')
        let $VIMHOME = $VIM.'\vimfiles'
else
        let $VIMHOME = $HOME.'/.vim'
endif

" Make sure "~/.vim" or "~/vimfiles" exist
if !isdirectory($VIMHOME) 
        silent call mkdir($VIMHOME, 'p')
endif

" Use VIM settings, rather then VI settings
set nocompatible

" How many lines of history VIM has to remember
set history=500

" Use many levels of undo
set undolevels=1000

" Don't redraw while executing macros
set lazyredraw

" Open at the same line number the file was closed at
set viewoptions-=options
augroup vimrc
        autocmd!
        autocmd BufWritePost *
        \       if expand('%') != '' && &buftype !~ 'nofile'
        \|              mkview
        \|      endif
        autocmd BufRead *
        \       if expand('%') != '' && &buftype !~ 'nofile'
        \|              silent loadview
        \|      endif
augroup END

" Reload VIMRC file without restarting VIM
nnoremap <F9> :source $MYVIMRC<CR>
xnoremap <F9> <ESC>:source $MYVIMRC<CR>gv
onoremap <F9> <ESC>:source $MYVIMRC<CR>
inoremap <F9> <C-o>:source $MYVIMRC<CR>

"""""""""
" Files "
"""""""""

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" Ignore some file extensions when completing names by pressing Tab
set wildignore=*.swp,*.bak,*.pyc,*.class,*.o,*.obj,*~

""""""""""""""""""""""
" VIM user interface "
""""""""""""""""""""""

" Never show status indicator (I have one on statusline)
set noshowmode

" Show line numbers by default
set nu

" Show/hide line numbers when F3 is pressed
nnoremap <F3> :set nu!<CR>
xnoremap <F3> <ESC>:set nu!<CR>gv
snoremap <F3> <ESC>:set nu!<CR>
onoremap <F3> <ESC>:set nu!<CR>
inoremap <F3> <C-o>:set nu!<CR>

" Always show current position
set ruler

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set vb
set tm=500
set visualbell t_vb=
if has("autocmd") && has("gui")
        au GUIEnter * set t_vb=
endif

" Characters to fill the statuslines and vertical separators
set fillchars=stl:\ ,stlnc:\ ,vert:│

"""""""""""""""
" Status line "
"""""""""""""""

" Always show the status line
set laststatus=2

" Possible modes dictionary
let g:currentmode={
        \ 'n'  : 'NORMAL',
        \ 'no' : 'OPERATOR PENDING',
        \ 'v'  : 'VISUAL',
        \ 'V'  : 'VISUAL LINE',
        \ '' : 'VISUAL BLOCKWISE',
        \ 's'  : 'SELECT',
        \ 'S'  : 'SELECT LINE',
        \ '' : 'SELECT BLOCK',
        \ 'i'  : 'INSERT',
        \ 'R'  : 'REPLACE',
        \ 'Rv' : 'VIRTUAL REPLACE',
        \ 'c'  : 'COMMAND',
        \ 'cv' : 'VIM EX',
        \ 'ce' : 'EX',
        \ 'r'  : 'PROMPT',
        \ 'rm' : 'MORE',
        \ 'r?' : 'CONFIRM',
        \ '!'  : 'SHELL',
        \ 't'  : 'TERMINAL',
        \}

" Automatically change the color of mode
function! SetModeColour()
        if (mode() =~# '\v(n|no)')
                exe 'hi! StatusLine cterm=bold ctermbg=green ctermfg=black gui=bold guibg=#99CC00 guifg=#115500'
        elseif (mode() ==# 'i')
                exe 'hi! StatusLine cterm=bold ctermbg=blue ctermfg=yellow gui=bold guibg=#0011AA guifg=#FF9900'
        elseif (mode() =~# '\v(R|Rv)')
                exe 'hi! StatusLine cterm=bold ctermbg=red ctermfg=white gui=bold guibg=#CC0000 guifg=#FFFFFF'
        elseif (mode() =~# '\v(v|V||s|S|)')
                exe 'hi! StatusLine cterm=bold ctermbg=yellow ctermfg=black gui=bold guibg=#FF9900 guifg=#663300'
        else
                exe 'hi! StatusLine cterm=bold ctermbg=black ctermfg=white gui=bold guibg=#333333 guifg=#FFFFFF'
        endif

        return ''
endfunction

" Define custom highlight groups
function! Highlight()
    	highlight User1 cterm=bold ctermbg=white ctermfg=black gui=bold guibg=#FFFFFF guifg=#000000
    	highlight User2 cterm=bold ctermbg=white ctermfg=red gui=bold guibg=#FFFFFF guifg=#CC0000
    	highlight StatusLineNC cterm=bold ctermbg=white ctermfg=black gui=bold guibg=#FFFFFF guifg=#888888
endfunction

" Highlight() function has to run on startup, but also when the
" ColorScheme autocommand is used, because Colour schemes should always
" start with :highlight clear, which would break colours of statusline
call Highlight()
augroup highlight
        autocmd!
        autocmd ColorScheme * call Highlight()
augroup end

" Format the status line
set statusline=%{SetModeColour()}                               " default colour, mode dependent
set statusline+=%1*                                             " primary colour
set statusline+=\                                               " padding space
set statusline+=\<%n\>                                          " buffer number
set statusline+=%{strlen(&bt)?'\ \|'.toupper(&bt).'\|':''}      " buffer type
set statusline+=\                                               " padding space
set statusline+=%*                                              " default colour
set statusline+=\                                               " padding space
set statusline+=\-\-\-\                                         " mode separator
set statusline+=%{g:currentmode[mode()]}                        " current mode
set statusline+=\                                               " padding space
set statusline+=%{&paste?'(paste)\ ':''}                        " paste status
set statusline+=\-\-\-\                                         " mode separator
set statusline+=%1*                                             " primary colour
set statusline+=\                                               " padding space
set statusline+=\"%t\"                                          " file name
set statusline+=\                                               " padding space
set statusline+=%<                                              " truncate point
set statusline+=%{strlen(&ft)?'\|'.&ft.'\|\ ':''}               " filetype
set statusline+=%2*                                             " secondary colour
set statusline+=>\ %{toupper(&ff)}\                             " file format
set statusline+=%{strlen(&fenc)?'>\ '.toupper(&fenc).'\ ':''}   " file encoding
set statusline+=%{&mod?'>\ MODIFIED\ ':''}                      " modified
set statusline+=%{&ma?'':'>\ UNMODIFIABLE\ '}                   " modifiable
set statusline+=%{&ro?'>\ READ\ ONLY\ ':''}                     " read only
set statusline+=%{&pvw?'>\ PREVIEW\ ':''}                       " preview window
set statusline+=%{&bin?'>\ BINARY\ ':''}                        " binary
set statusline+=%=                                              " left/right break
set statusline+=\                                               " padding space
set statusline+=%*                                              " primary colour
set statusline+=\                                               " padding space
set statusline+=%c,                                             " cursor column
set statusline+=%l/%L                                           " cursor line/total lines
set statusline+=\                                               " padding space
set statusline+=%1*                                             " primary colour
set statusline+=\                                               " padding space
set statusline+=%P                                              " percent through file
set statusline+=\                                               " padding space

""""""""""
" Colors "
""""""""""

" Default colorscheme
try
        if has('gui_running')
                colorscheme koehler
        else
                colorscheme ron
        endif
catch
        echo "Colorscheme missing!"
endtry

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

set background=dark

" Enable syntax highlighting
syntax enable

" Show matching brackets when text indicator is over them
set showmatch

""""""""
" Text "
""""""""

" Binary mode switch
nnoremap <F4> :set binary!<CR>
xnoremap <F4> <ESC>:set binary!<CR>gv
onoremap <F4> <ESC>:set binary!<CR>
inoremap <F4> <C-o>:set binary!<CR>

" Set font for GUI
if has('gui_running')
        if has('unix')
                try
                        set guifont=monospace\ 10
                catch
                        echo "Font Monospace was not set!"
                endtry
        else
                try
                        set guifont=Consolas:h10
                catch
                        echo "Font Consolas was not set!"
	        endtry
        endif
endif

" 1 tab == 8 spaces
set expandtab
set shiftwidth=8
set tabstop=8

" Don't wrap lines
set nowrap

" Always set autoindenting on
set autoindent

" C style indentation
set cindent

" Copy the previous indentation on autoindenting
set copyindent

" Move lines using ALT+[jk]
if has('unix')
        execute "set <M-j>=\ej"
        execute "set <M-k>=\ek"
endif
" single line in normal mode:
nnoremap <silent> <M-j> @='ma:.,.m ''a+1<C-V><CR>`a'<CR>
nnoremap <silent> <M-k> @='ma:.,.m ''a-2<C-V><CR>`a'<CR>
" selected lines in visual mode
xnoremap <silent> <M-j> @='<C-V><ESC>`<ma:exe line("''<").",".line("''>")."m ''>+1"<C-V><CR>`agv'<CR>
xnoremap <silent> <M-k> @='<C-V><ESC>`<ma:exe line("''<").",".line("''>")."m ''<-2"<C-V><CR>`agv'<CR>

" fold based on indent
set foldmethod=indent

" deepest fold is 3 levels
set foldnestmax=3

" dont fold by default
set nofoldenable

""""""""""
" search "
""""""""""

" Highlight search results
set hlsearch

" Show search matches as you type
set incsearch

" Clear highlighted searches
noremap <silent> ,/ :noh<CR>

""""""""""""""""""
" Copy and paste "
""""""""""""""""""

" Enable/disable paste mode
set pastetoggle=<F2>

" Set address of temporary buffer
if has('win32') || has ('win64') || has('win16')
        let $BUFF = $VIMHOME.'\_vimbuf'
else
        let $BUFF = $VIMHOME.'/.vimbuf'
endif 

" Copy selection to temporary buffer
xnoremap <silent> zy may:new<CR>p:silent! w! <C-R>=$BUFF<CR><CR>:q<CR>gv`a
xnoremap <silent> zx x:new<CR>p:silent! w! <C-R>=$BUFF<CR><CR>:q<CR>

" Place text from temp buff before cursor 
nnoremap <silent> zp iX<LEFT><CR><DEL><C-o>d^<ESC>:.-1r <C-R>=$BUFF<CR><CR>ma`]A<DEL><ESC>`akA<DEL><ESC>`a
vnoremap <silent> zp <DEL>iX<LEFT><CR><DEL><C-o>d^<ESC>:.-1r <C-R>=$BUFF<CR><CR>ma`]A<DEL><ESC>`akA<DEL><ESC>`a
onoremap <silent> zp <ESC>iX<LEFT><CR><DEL><C-o>d^<ESC>:.-1r <C-R>=$BUFF<CR><CR>ma`]A<DEL><ESC>`akA<DEL><ESC>`a

" Place text from temp buff after cursor
nnoremap <silent> zP aX<LEFT><CR><DEL><C-o>d^<ESC>:.-1r <C-R>=$BUFF<CR><CR>ma`]A<DEL><ESC>`akA<DEL><ESC>`a
vnoremap <silent> zP <DEL>aX<LEFT><CR><DEL><C-o>d^<ESC>:.-1r <C-R>=$BUFF<CR><CR>ma`]A<DEL><ESC>`akA<DEL><ESC>`a
onoremap <silent> zP <ESC>aX<LEFT><CR><DEL><C-o>d^<ESC>:.-1r <C-R>=$BUFF<CR><CR>ma`]A<DEL><ESC>`akA<DEL><ESC>`a

"""""""""
" Hacks "
"""""""""

" jj sequance as ESC
inoremap jj <ESC>
snoremap jj <ESC>

" Automatically add closing for { ( [ ' " ` <
inoremap { {<CR>}<ESC>kA<CR><TAB>
inoremap ( ()<ESC>i
inoremap [ []<ESC>i
inoremap ' ''<ESC>i
inoremap " ""<ESC>i
" inoremap ` ``<ESC>i
" inoremap < <><ESC>i

" search history using CTRL and h, j, k, and l
cnoremap <C-h> <LEFT>
cnoremap <C-j> <DOWN>
cnoremap <C-k> <UP>
cnoremap <C-l> <RIGHT>

" Use ',' as mapleader instead of '/' 
let mapleader = ","
let g:mapleader = ","

" :W sudo saves the file on unix systems
if has ('unix')
        command! W w !sudo tee % > /dev/null
endif

" Fast save
nnoremap <LEADER>w :w!<CR>
xnoremap <LEADER>w <ESC>:w!<CR>gv
onoremap <LEADER>w <ESC>:w!<CR>
if has ('unix')
        nnoremap <LEADER>W :W<CR>
        xnoremap <LEADER>W <ESC>:W<CR>gv
        onoremap <LEADER>W <ESC>:W<CR>
endif

" Fast save and quit
nnoremap <LEADER>q :q<CR>
vnoremap <LEADER>q <ESC>:q<CR>
onoremap <LEADER>q <ESC>:q<CR>

" ENTER key out of insert mode
nnoremap <CR> i<CR><ESC>
vnoremap <CR> <DEL>i<CR><ESC>
onoremap <CR> <ESC>i<CR><ESC>

" New line without entering insertmode
nnoremap <LEADER>o o<ESC>
nnoremap <LEADER>O O<ESC>

" Turn line into title caps
nnoremap <silent> <F5> :s/\v<(.)(\w*)/\u\1\L\2/g<CR>:noh<CR>
inoremap <silent> <F5> <ESC>:s/\v<(.)(\w*)/\u\1\L\2/g<CR>:noh<CR>i

" Switch case of selection / word / whole line
xnoremap <F6> ~gv
nnoremap <F6> g~aw
inoremap <F6> <C-o>g~aw

xnoremap <S-F6> ~gv
nnoremap <S-F6> g~~
inoremap <S-F6> <C-o>g~~

" Turn selection / whole line into uppercase
xnoremap <F7> Ugv
nnoremap <F7> gUaw
inoremap <F7> <C-o>gUaw

xnoremap <S-F7> Ugv
nnoremap <S-F7> gUU
inoremap <S-F7> <C-o>gUU

" Turn selection / whole line into lowercase
xnoremap <F8> ugv
nnoremap <F8> guaw
inoremap <F8> <C-o>guaw

xnoremap <S-F8> ugv
nnoremap <S-F8> guu
inoremap <S-F8> <C-o>guu

"""""""""""""""""""""""""""""""
" Tabs and buffers management "
"""""""""""""""""""""""""""""""

" Useful mappings for managing tabs
nnoremap <LEADER>tn :silent! tabnew<CR>
nnoremap <LEADER>tc :silent! tabclose!<CR>
nnoremap <LEADER>to :silent! tabonly!<CR>
nnoremap <LEADER>tm :<C-U>exe 'silent! '.v:count.'tabmove'<CR>
nnoremap <LEADER>tl :silent! tabnext<CR>
nnoremap <LEADER>th :silent! tabprevious<CR>

" Opens a new tab with the current buffer's path
nnoremap <LEADER>tt :tabedit <C-r>=expand("%:p:h")<CR><CR>

" Toggle between this and the last accessed tab
let g:lasttab = 1
nnoremap <Leader><TAB> :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Switching buffers
nnoremap <LEADER>bl :bnext<CR>
nnoremap <LEADER>bh :bprevious<CR>

" Close all buffers but current
nnoremap <LEADER>bo :tabmove<CR>:silent! exe '2,'.bufnr("$").'bdelete'<CR>

" Close the current buffer
nnoremap <LEADER>bc :bdelete!<CR>

" Close all the buffers   
nnoremap <LEADER>BC :bufdo! bdelete!<CR>

" Switch CWD to the directory of the open buffer
nnoremap <LEADER>cd :cd %:p:h<CR>:pwd<CR>

" Specify the behavior when switching between buffers 
try
  	set switchbuf=useopen,usetab,newtab
  	set stal=2
catch
	echo "Failed to specify the behavior when switching between buffers!"
endtry

"""""""""""""""""""""
" Window management "
"""""""""""""""""""""

" Split window
nnoremap <LEADER>s <C-w>s
xnoremap <LEADER>s <C-w>sgv
snoremap <LEADER>s <C-o><C-w>s
onoremap <LEADER>s <ESC><C-w>s

" Split window vertically
nnoremap <LEADER>v <C-w>v
xnoremap <LEADER>v <C-w>vgv
snoremap <LEADER>v <C-o><C-w>v
onoremap <LEADER>v <ESC><C-w>v

" Minimum window hight and width - current window is maximized
" set winheight=999
" set winminheight=0
" set winwidth =999
" set winminwidth=0

" Minimum window hight and width - few lines/rows of each window are visible
set winheight=5
set winminheight=5
set winwidth =20
set winminwidth=20

" Move easily between windows after split
" in normal mode:
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" in visual mode:
xnoremap <C-h> <C-w>h
xnoremap <C-j> <C-w>j
xnoremap <C-k> <C-w>k
xnoremap <C-l> <C-w>l
" in operator-pending mode:
onoremap <C-h> <ESC><C-w>h
onoremap <C-j> <ESC><C-w>j
onoremap <C-k> <ESC><C-w>k
onoremap <C-l> <ESC><C-w>l
" in select  mode:
snoremap <C-h> <C-o><C-w>h
snoremap <C-j> <C-o><C-w>j
snoremap <C-k> <C-o><C-w>k
snoremap <C-l> <C-o><C-w>l
" in insert and replace mode:
inoremap <C-h> <C-o><C-w>h
inoremap <C-j> <C-o><C-w>j
inoremap <C-k> <C-o><C-w>k
inoremap <C-l> <C-o><C-w>l

" The same once more with automatic window maximization
" " in normal mode:
" nnoremap <C-h> <C-w>h<C-w>_<C-w><BAR>
" nnoremap <C-j> <C-w>j<C-w>_<C-w><BAR>
" nnoremap <C-k> <C-w>k<C-w>_<C-w><BAR>
" nnoremap <C-l> <C-w>l<C-w>_<C-w><BAR>
" " in visual mode:
" xnoremap <C-h> <C-w>h<C-w>_<C-w><BAR>
" xnoremap <C-j> <C-w>j<C-w>_<C-w><BAR>
" xnoremap <C-k> <C-w>k<C-w>_<C-w><BAR>
" xnoremap <C-l> <C-w>l<C-w>_<C-w><BAR>
" " in operator-pending mode:
" onoremap <C-h> <ESC><C-w>h<C-w>_<C-w><BAR>
" onoremap <C-j> <ESC><C-w>j<C-w>_<C-w><BAR>
" onoremap <C-k> <ESC><C-w>k<C-w>_<C-w><BAR>
" onoremap <C-l> <ESC><C-w>l<C-w>_<C-w><BAR>
" " in select  mode:
" snoremap <C-h> <C-o><C-w>h<C-o><C-w>_<C-o><C-w><BAR>
" snoremap <C-j> <C-o><C-w>j<C-o><C-w>_<C-o><C-w><BAR>
" snoremap <C-k> <C-o><C-w>k<C-o><C-w>_<C-o><C-w><BAR>
" snoremap <C-l> <C-o><C-w>l<C-o><C-w>_<C-o><C-w><BAR>
" " in insert and replace mode:
" inoremap <C-h> <C-o><C-w>h<C-o><C-w>_<C-o><C-w><BAR>
" inoremap <C-j> <C-o><C-w>j<C-o><C-w>_<C-o><C-w><BAR>
" inoremap <C-k> <C-o><C-w>k<C-o><C-w>_<C-o><C-w><BAR>
" inoremap <C-l> <C-o><C-w>l<C-o><C-w>_<C-o><C-w><BAR>

" Easily resize windows after split
" in normal mode:
nnoremap <A-UP> <C-w>+
nnoremap <A-DOWN> <C-w>-
nnoremap <A-LEFT> <C-w><
nnoremap <A-RIGHT> <C-w>>
" in visual mode:
xnoremap <A-UP> <C-w>+
xnoremap <A-DOWN> <C-w>-
xnoremap <A-LEFT> <C-w><
xnoremap <A-RIGHT> <C-w>>
" in operator-pending mode:
onoremap <A-UP> <ESC><C-w>+
onoremap <A-DOWN> <ESC><C-w>-
onoremap <A-LEFT> <ESC><C-w><
onoremap <A-RIGHT> <ESC><C-w>>
" in select  mode:
snoremap <A-UP> <C-o><C-w>+
snoremap <A-DOWN> <C-o><C-w>-
snoremap <A-LEFT> <C-o><C-w><
snoremap <A-RIGHT> <C-o><C-w>>
" in insert and replace mode:
inoremap <A-UP> <C-o><C-w>+
inoremap <A-DOWN> <C-o><C-w>-
inoremap <A-LEFT> <C-o><C-w><
inoremap <A-RIGHT> <C-o><C-w>>
