""""""""""""""""""""""""""""""""""""""""""""""""""
" URL:     https://github.com/eamileann/my_vimrc "
" Author:  Michal Pajtinka                       "
" TODO:                                          "
"       compatibility with Mac                   "
"       battery level based on command presence  "
"       battery info hiding/showing              "
"       statusline colours for WSL               "
"       {} autocompletion for more special cases "
"                                                "
""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""
" General "
"""""""""""

" Store path to .vim (or vimfiles) to variable $VIMHOME
if has('win32') || has ('win64') || has('win16')
        let $VIMHOME = $VIM.'\vimfiles'
else
        let $VIMHOME = $HOME.'/.vim'
endif

" Make sure .vim (or vimfiles) exist
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
nnoremap <silent> <F9> :source $MYVIMRC<CR>
xnoremap <silent> <F9> <ESC>:source $MYVIMRC<CR>gv
onoremap <silent> <F9> <ESC>:source $MYVIMRC<CR>
inoremap <silent> <F9> <C-o>:source $MYVIMRC<CR>

" Use ';' as mapleader instead of '/' 
let g:mapleader = ";"

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

" Don't create backup files
set nobackup

" Use strongest encryption
setlocal cryptmethod=blowfish2

""""""""
" Text "
""""""""

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

" Tab settings
augroup tab_settins
        autocmd!
        autocmd FileType c,cpp,vim,sh,python setlocal expandtab shiftwidth=8 tabstop=8
        autocmd FileType text,tex,latex,context,plaintex,make setlocal noexpandtab shiftwidth=4 tabstop=4
augroup END

" Wrap lines settings
augroup wrap_settins
        autocmd!
        autocmd FileType c,cpp,python setlocal wrap textwidth=80
        autocmd FileType vim,sh setlocal nowrap
        autocmd FileType text,tex,latex,context,plaintex,make setlocal nowrap
augroup END

" Autoindenting settings
augroup indent_settings
        autocmd!
        autocmd FileType c,cpp,python,vim,sh setlocal autoindent cindent copyindent
        autocmd FileType tex,latex,context,plaintex,make setlocal autoindent copyindent
        autocmd FileType text setlocal noautoindent
augroup END

" Fold based on indent
set foldmethod=indent

" Deepest fold is 3 levels
set foldnestmax=3

" Don`t fold by default
set nofoldenable

" Move lines/selection using ALT+[hjkl]
if has('unix')
        execute "set <M-j>=\ej"
        execute "set <M-k>=\ek"
        execute "set <M-h>=\eh"
        execute "set <M-l>=\el"
        execute "set <M-J>=\eJ"
        execute "set <M-K>=\eK"
endif
" Single line up/down in normal mode:
nnoremap <silent> <M-k> @='ma:.,.m ''a-2<C-V><CR>`a'<CR>
nnoremap <silent> <M-j> @='ma:.,.m ''a+1<C-V><CR>`a'<CR>
" Whole lines up/down in visual mode 
vnoremap <silent> <M-K> @='<C-V><ESC>`<ma:exe line("''<").",".line("''>")."m ''<-2"<C-V><CR>`agv'<CR>
vnoremap <silent> <M-J> @='<C-V><ESC>`<ma:exe line("''<").",".line("''>")."m ''>+1"<C-V><CR>`agv'<CR>
" Move only selection up/down/right/left
vnoremap <silent> <M-k> @='xP`[v`]xkP`[v`]'<CR>
vnoremap <silent> <M-j> @='xP`[v`]xjP`[v`]'<CR>
vnoremap <silent> <M-h> @='xP`[v`]xhP`[v`]'<CR>
vnoremap <silent> <M-l> @='xP`[v`]xlP`[v`]'<CR>

""""""""""""""""""""""
" VIM user interface "
""""""""""""""""""""""

" Never show status indicator (I have one on statusline)
set noshowmode

" Show/Hide line number by default
augroup line_number_settins
        autocmd!
        autocmd FileType c,cpp,python,vim,sh,make setlocal number
augroup END

" Show/hide line numbers when F3 is pressed
nnoremap <silent> <F4> :set nu!<CR>
xnoremap <silent> <F4> <ESC>:set nu!<CR>gv
snoremap <silent> <F4> <ESC>:set nu!<CR>
onoremap <silent> <F4> <ESC>:set nu!<CR>
inoremap <silent> <F4> <C-o>:set nu!<CR>
        
" Never show current position (I have one on status line)
set noruler

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
if has("gui")
        augroup visual_bell
                autocmd!
                autocmd GUIEnter * set t_vb=
        augroup END
endif

" Characters to fill the statuslines and vertical separators
set fillchars=stl:\ ,stlnc:\ ,vert:│

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

" Define custom highlight groups
function! Highlight()
    	highlight User1 cterm=bold ctermbg=white ctermfg=black gui=bold guibg=#FFFFFF guifg=#000000
    	highlight User2 cterm=bold ctermbg=white ctermfg=red gui=bold guibg=#FFFFFF guifg=#CC0000
    	highlight StatusLineNC cterm=bold ctermbg=white ctermfg=black gui=bold guibg=#FFFFFF guifg=#888888
endfunction

" Highlight() function has to run on startup, but also when the
" ColorScheme autocommand is used, because colour schemes should always
" start with :highlight clear, which would break colours of statusline
call Highlight()
augroup highlight
        autocmd!
        autocmd ColorScheme * call Highlight()
augroup end

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

" Automatically change the colour according to current mode
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
                exe 'hi! StatusLine cterm=bold ctermbg=white ctermfg=black gui=bold guibg=#FFFFFF guifg=#000000'
        endif

        return ''
endfunction

" Format the status line
set statusline=%{SetModeColour()}                               " default colour, mode dependent
set statusline+=\                                               " padding space
set statusline+=%{g:currentmode[mode()]}                        " current mode
set statusline+=\                                               " padding space
set statusline+=%{&paste?'(paste)\ ':''}                        " paste status
set statusline+=%{&bin?'\|BINARY\|\ ':''}                       " binary mode indicator
set statusline+=%1*                                             " primary colour
set statusline+=\                                               " padding space
set statusline+=\<buf\ %n\>                                     " buffer number
set statusline+=%{strlen(&bt)?'\ \|'.toupper(&bt).'\|':''}      " buffer type
set statusline+=%1*                                             " primary colour
set statusline+=\                                               " padding space
set statusline+=\"%t\"                                          " file name
set statusline+=\                                               " padding space
set statusline+=%<                                              " truncate point
set statusline+=%{strlen(&ft)?'\|'.&ft.'\|\ ':''}               " filetype
set statusline+=%*                                              " default colour
set statusline+=\                                               " padding space
set statusline+=>\ %{toupper(&ff)}\ >\                          " file format
set statusline+=%{strlen(&fenc)?toupper(&fenc).'\ >\ ':''}      " file encoding
set statusline+=%{&mod?'MODIFIED\ >\ ':''}                      " modified flag
set statusline+=%{&ma?'':'UNMODIFIABLE\ >\ '}                   " modifiable flag
set statusline+=%{&ro?'READ\ ONLY\ >\ ':''}                     " read only flag
set statusline+=%{&pvw?'PREVIEW\ >\ ':''}                       " preview window flag
set statusline+=%{strlen(&key)?'ENCRIPTED':''}			" encrypted?
set statusline+=%=                                              " left/right break
set statusline+=%1*                                             " primary colour
if exists('*strftime')
        set statusline+=\                                       " padding space
        set statusline+=%{strftime('%A\ %Y/%m/%d\ %H:%M\ ')}    " time and date
endif
if has ('unix')
	set statusline+=\ BAT:\  
	let g:battery = '???'
	autocmd CursorHold * let g:battery = system('upower -i $(upower -e | grep BAT)
                \ | grep percentage | cut -d ":" -f 2 | tr -d " " | tr -d "\n"')
	set statusline+=%{strlen(battery)?battery:'???'}
endif
set statusline+=\                                               " padding space
set statusline+=%*                                              " main color
set statusline+=\                                               " padding space
set statusline+=%c,                                             " cursor column
set statusline+=%l                                              " cursor line/total lines
set statusline+=\                                               " padding space
set statusline+=%P                                              " percent through file
set statusline+=\                                               " padding space

" Set noncurrent statusline format
let g:Active_statusline=&g:statusline
let g:Nonactive_statusline=' <buf %n> "%t" %M'
augroup status_line_change
	autocmd!
	autocmd WinEnter * let &l:statusline=g:Active_statusline
	autocmd WinLeave * let &l:statusline=g:Nonactive_statusline
augroup END

" Update status line once per second automatically
let timer = timer_start(2000, 'UpdateStatusBar', {'repeat':-1})
function! UpdateStatusBar(timer)
        execute 'let &ro = &ro'
endfunction

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

"""""""""
" Hacks "
"""""""""

" Binary mode switch
nnoremap <silent> <F3> :set binary!<CR>
xnoremap <silent> <F3> <ESC>:set binary!<CR>gv
onoremap <silent> <F3> <ESC>:set binary!<CR>
inoremap <silent> <F3> <C-o>:set binary!<CR>

" jj sequance as ESC
inoremap jj <ESC>
snoremap jj <ESC>

" Automatically add closing for ( [ '
inoremap ( ()<ESC>i
inoremap [ []<ESC>i
inoremap ' ''<ESC>i

" Automatically add closing for '"' in all filetypes but vim 
inoremap <expr> " &ft !=# 'vim' ? '""<ESC>i' : '"'

" Curly brackets closings
augroup curly_brackets_closing
        autocmd!
        autocmd FileType c,cpp inoremap <buffer> { {<CR>}<ESC>kA<CR>
        autocmd FileType sh inoremap <buffer> { {}<ESC>i
augroup END

" Comments closing
augroup comments_closing
        autocmd!
        autocmd FileType c,cpp inoremap <buffer> /* /*<SPACE><SPACE>*/<ESC>hhi
        autocmd FileType c,cpp inoremap <buffer> /** /**<CR><CR>/<ESC>kA<SPACE>
augroup END

" Enclose selection
xnoremap <silent> ( mac()<ESC>P`al
xnoremap <silent> [ mac[]<ESC>P`al
xnoremap <silent> { mac{}<ESC>P`al
xnoremap <silent> ' mac''<ESC>P`al
xnoremap <silent> % mac%%<ESC>P`al
xnoremap <silent> < mac<><ESC>P`al

" Search history using CTRL and h, j, k, and l
cnoremap <C-h> <LEFT>
cnoremap <C-j> <DOWN>
cnoremap <C-k> <UP>
cnoremap <C-l> <RIGHT>

" :W sudo saves the file on unix systems
if has ('unix')
        command! W w !sudo tee % > /dev/null
endif

" Fast save
nnoremap <silent> <LEADER>w :w!<CR>
xnoremap <silent> <LEADER>w <ESC>:w!<CR>gv
onoremap <silent> <LEADER>w <ESC>:w!<CR>
if has ('unix')
        nnoremap <LEADER>W :W<CR>
        xnoremap <LEADER>W <ESC>:W<CR>gv
        onoremap <LEADER>W <ESC>:W<CR>
endif

" Fast quit
nnoremap <silent> <LEADER>q :q<CR>
vnoremap <silent> <LEADER>q <ESC>:q<CR>
onoremap <silent> <LEADER>q <ESC>:q<CR>

" ENTER key out of insert mode
nnoremap <CR> i<CR><ESC>
vnoremap <CR> <DEL>i<CR><ESC>
onoremap <CR> <ESC>i<CR><ESC>

" BACKSPACE without entering insert mode
nnoremap <BS> X
vnoremap <BS> <DEL>
onoremap <BS> <ESC>X

" SPACE without entering insert mode
nnoremap <SPACE> i<SPACE><ESC>l
vnoremap <SPACE> <DEL>i<SPACE><ESC>l
onoremap <SPACE> <ESC>i<SPACE><ESC>l

" NEW LINE without entering insert mode
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
nnoremap <silent> <LEADER>tt :tabedit <C-r>=expand("%:p:h")<CR><CR>

" Toggle between this and the last accessed tab
let g:lasttab = 1
nnoremap <Leader><TAB> :exe "tabn ".g:lasttab<CR>
augroup tab_leave
        autocmd!
        autocmd TabLeave * let g:lasttab = tabpagenr()
augroup END

" Switching buffers
nnoremap <silent> <LEADER>bl :bnext<CR>
nnoremap <silent> <LEADER>bh :bprevious<CR>

" Close all buffers but current
nnoremap <silent> <LEADER>bo :tabmove<CR>:silent! exe '2,'.bufnr("$").'bdelete'<CR>

" Close the current buffer
nnoremap <silent> <LEADER>bc :bdelete!<CR>

" Close all the buffers   
nnoremap <silent> <LEADER>BC :bufdo! bdelete!<CR>

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
nnoremap + <C-w>+
nnoremap - <C-w>-
nnoremap < <C-w><
nnoremap > <C-w>>
