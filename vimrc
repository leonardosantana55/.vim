                        """""""THIS IS MY VIMRC""""""""
" in this config I try to create a portable vim with little functionality added.
    " Always trying to leave vim as it is and keeping the customization to a
            " minimum, thus also keeping side effects to a minimum.


" disables the *compatible* to vi, which causes many bugs. Must be at the
" beginning of the vimrc file.
if &cp | set nocp | endif
let mapleader=" "


                        """"""""CONFIG FOR NETWR""""""""


function! Explorer2()
    if &filetype != "netrw"
        execute ":Explore"
    else
        execute ":Rexplore"
    endif
endfunc

let g:netrw_banner = 0                 " to toggle it, use I
""let g:netrw_browse_split = 4         " same as using P
let g:netrw_altv = 1
let g:netrw_liststyle = 0
let g:netrw_winsize = 25
map <Leader>fe :call Explorer2()<CR>
let g:netrw_keepdir = 0


                       """"""""CONFIG STATUSLINE""""""""

"
function! MyStatusLine()

    " Set the statusline highlight group to StatusLine on Vim startup
    set statusline=%#StatusLine#

    set statusline+=\ %{%mode()%}

    " Add the full file path to the statusline
    set statusline+=\ %F

    " Change highlight group to DiffAdd (for the next item)
    set statusline+=\ %#DiffAdd#

    " Show a '+' if the file is modified
    set statusline+=%m

    " Switch back to the StatusLine highlight group
    set statusline+=%#StatusLine#

    " Truncate the statusline here if it gets too long
    set statusline+=%<

    function GetSessionName()
        return fnamemodify(v:this_session, ':t')
    endfunc

    " Add the session name in parentheses, e.g., (session.vim)
    set statusline+=\ %{'s('}\%{%GetSessionName()%}\%{')'}

    " Split the statusline (left and right alignment)
    set statusline+=%=

    " Show the current buffer number
    set statusline+=%{'buf:('}\%n\%{')'}

    " Show the percentage through the file
    set statusline+=\ %p%%

    " its better when code is less than 80 columns wide
    function AlertColumn()
        if col('.')>=70&&col('.')<=78
            return '%#WildMenu#'
        elseif col('.')>78
            return '%#DiffDelete#'
        else
            return '%#StatusLine#'
    endfunc

    "lines counter
    set statusline+=\ %l\:

    "alert column
    set statusline+=%{%AlertColumn()%}

    "column counter
    set statusline+=\%c
endfunc

autocmd VimEnter * call MyStatusLine()

            """"""""VARIOUS OPTIONS FOR THE TEXT EDITOR""""""""

set sessionoptions+=unix,slash
set autochdir                          " new terminal opens in current files dir 
set! autoindent
set! smartindent
set splitright
set splitbelow
set number
set relativenumber
set title
if has("win32")
    set clipboard=unnamed
else
    set clipboard=unnamedplus
endif
set nobackup
set ignorecase
set smartcase
set showcmd
set wildoptions=pum
set wildmenu
set wildmode=full
set showmode
set showtabline=2
set laststatus=2
set nowrap
set sidescroll=5
set scrolloff=5
set sidescrolloff=5
set list
set lcs=tab:»\ ,multispace:____,lead:\ ,extends:»,trail:•
set formatoptions=
set formatoptions+=t
set formatoptions+=c
set formatoptions+=r
set textwidth=0

set tabstop=4
set softtabstop=-1
set expandtab                          "spaces are more reliable for formating accros devices
set shiftwidth=4
set incsearch
set hlsearch
set backspace=indent,eol,start
set belloff=all                        "stops annoying bell 

" python
autocmd FileType python set autoindent
autocmd FileType python set smartindent

"lisp
autocmd FileType lisp set tabstop=2
autocmd FileType lisp set shiftwidth=2

filetype plugin indent on

" set cursorline
if !exists("g:syntax_on")
    syntax enable
endif 

" make cursor blink
if &term =~ 'xterm' || &term == 'win32'
    " Use DECSCUSR escape sequences
    let &t_SI = "\e[5 q"    " blink bar
    let &t_SR = "\e[3 q"    " blink underline
    let &t_EI = "\e[1 q"    " blink block
    let &t_ti ..= "\e[1 q"  " blink block
    let &t_te ..= "\e[0 q"  " default (depends on terminal, normally blink
                " block)
endif


        """"""""MOSTLY MAPPINGS FOR THE NORMAL MODE TEXT EDITOR""""""""

noremap <Leader>ww :w<CR>

noremap <Leader>bb :b!#<CR>

" delete current file
command! Fdel call delete(expand('%'))
map <Leader>cs :nohlsearch<CR>

"last command is for clearing the annoying search highligth
map <Leader>ws :w<CR>:source<CR>:nohlsearch<CR>|

if has("win32")
    map <Leader>cv :vs<CR>:edit $MYVIMRC<cr>
else
    map <Leader>cv :vs<CR>:edit ~/.vim/vimrc<cr>
endif

map <Leader>er :w ~/.vim/snippets/
map <Leader>re :cd ~/.vim/snippets<CR>:read 

noremap - $

map gg gg0
map G G$
vnoremap gg gg0
vnoremap G G$

nmap ]] /[{}]<CR>:nohlsearch<CR>
nmap [[ ?[{}]<CR>:nohlsearch<CR>

map <Leader>d "dd|                     " deletes without overwriting the register

"avoids Unnamed register when pasting over visual selection
xnoremap <expr> p 'pgv"' . v:register . 'y'

"move line up and down"
nnoremap <F5> :move +1<CR>
nnoremap <F6> :move -2<CR>

nnoremap <F9> @:|                       " repeat last command

command! CopyPath let @+ = expand('%:p:h')
map <Leader>cb :CopyPath<CR>|

" saves session and closes all
map <Leader>ssqa :wall!<CR>:execute "mksession! ~/" .. v:this_session<CR>:qa!<CR>|

"im ready for vim hard mode, im a grown up now, im a man
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

vnoremap <Up> <Nop>
vnoremap <Down> <Nop>
vnoremap <Left> <Nop>
vnoremap <Right> <Nop>

" comment out multiple lines
nnoremap <Leader>co :normal!0i

function! DelBuffer()
" delete buffer like :bd but without closing the current window"
    let buffer_count = len(getbufinfo({'buflisted':1}))
    let buffer_name = bufname()

    if buffer_count > 1
        execute ':b#'
        execute ':bd ' . buffer_name
    else
        execute ':echo cant delete'
    endif

endfunc

map <Leader>bd :call DelBuffer()<CR>


                       """"""TERMINAL CONFIG STUFF""""""

if has("win32")

" check if the executable exists
    if executable("C:\\Program Files\\PowerShell\\7\\pwsh") == 1
        set shell=\"C:\\Program\ Files\\PowerShell\\7\\pwsh\"    " my pc
    else
        set shell=C:\\PowerShell-7.4.5-win-x64\\pwsh.exe"    " engies pc
    endif
endif

if has("win32")
    let term_name = "powershell"
else
    let term_name = "bin/bash"
endif

let term_bufname = term_name
let term_size = 10

function! TermCreate()

    " toggle on and off a terminal on the botton of the screen"
    " we can have only one terminal at a time."
    let buf_info = getbufinfo()->matchfuzzy(g:term_name, {'key' : 'name'})
    if len(buf_info) == 0
        execute ':bo term ++rows=' .. g:term_size
        let g:term_bufname = bufname()
        return
    else
        " prevent creating aditional window for term buffer"
        if getbufinfo(g:term_bufname)[0].hidden == 1
            execute ':bo sb ' . g:term_name 
            execute ':res' . g:term_size
            normal i
        else
            call win_gotoid(win_findbuf(bufnr(g:term_name))[0])
        endif
    endif
endfunc

function! TermHidenResize()

    let g:term_size = winheight(0)
    execute ':hide'
endfunc

nnoremap <Leader>\ :call TermCreate()<CR>
tnoremap <Leader>\  <C-\><C-n>:call TermHidenResize()<CR>
tnoremap <esc><esc> <C-\><C-n>


           """"""""QUOTES BRACKETS AND PARENTHESIS AUTO MATCH""""""""

function! InsertMatchPair(char, match)
" checks if cursor has chars in front of it and adds a maching pair of some
" has a side effect that affects commenting many lines at once with visual block + <S-i>
" is overcome by <Leader>" or <Leader>#.
" Other chars might be added latter

    let next_char = getline(".")[col(".")] 
    let line = getline('.')

" mainly for closing brackets, but works on same char also.
    if next_char == a:char
        execute ':start'
        call cursor( line('.'), col('.') + 2)
        return
    endif

" handles opening brackets behavior only
    if next_char == "" || next_char == " " || next_char == a:char
    \ || next_char == a:match[1]
    \ || next_char == '"'
    \ || next_char == "'"
    \ || next_char == ")"
    \ || next_char == "]"
    \ || next_char == "}"

        call setline('.', strpart(line, 0, col('.') ) . a:match . strpart(line, col('.') ))
    else
        if col('.') == 1  " edge case when cursor is on first column and it is not empty
            call setline('.', strpart(line, 0, col('.') -1 ) . a:char . strpart(line, col('.') -1 ))
            execute ':start'
            call cursor('.', col('.')+1)  " positions cursor at the rigth place and in insert mode
            return
        else
            call setline('.', strpart(line, 0, col('.') ) . a:char . strpart(line, col('.') ))
        endif
    endif

    call cursor('.', col('.')+2)  " positions cursor at the rigth place and in insert mode
    execute ':start'
endfunc

inoremap " <esc>:call InsertMatchPair('"', '""')<CR>
inoremap ' <esc>:call InsertMatchPair("'", "''")<CR>
inoremap ( <esc>:call InsertMatchPair('(', '()')<CR>
inoremap [ <esc>:call InsertMatchPair('[', '[]')<CR>
inoremap { <esc>:call InsertMatchPair('{', '{}')<CR>

inoremap ) <esc>:call InsertMatchPair(')', ')')<CR>
inoremap ] <esc>:call InsertMatchPair(']', ']')<CR>
inoremap } <esc>:call InsertMatchPair('}', '}')<CR>

inoremap {<cr> {<cr>}<left><cr><up><tab>| " this mapping only works with smart indent and auto indent surround.

vnoremap <Leader>" <esc>a"<esc>`<i"
vnoremap <Leader>' <esc>a'<esc>`<i'
vnoremap <Leader>( <esc>a)<esc>`<i(
vnoremap <Leader>[ <esc>a]<esc>`<i[
vnoremap <Leader>{ <esc>a}<esc>`<i{
vnoremap <Leader>/ <esc>a*/<esc>`<i/*


            """"""""COMMENT SNIPPETS STUFF FOR C PROGRAMMING"""""""

function! CommentFunction()

    let current_line = line(".")
    call append(current_line,   "/******************************************************************************")
    call append(current_line+1, "*Function Description:")
    call append(current_line+2, "")
    call append(current_line+3, "")
    call append(current_line+4, "")
    call append(current_line+5, "******************************************************************************/")
endfunc

function! CommentVariable()
" use this function to start comments always on the same ideal_comment_col or 12
" spaces away from last char

    normal $
    let current_col = col(".")
    let ideal_comment_col = 40
    let distance = ideal_comment_col - current_col

    " if it is a long line put 4 spaces
    if distance <= 0
        call feedkeys("a    ",'t')
    else
        while distance > 0
            call feedkeys("a \<esc>",'t')
            let distance -= 1
        endwhile
    endif
    normal a
endfunc

map <Leader>cf :call CommentFunction()<CR>2jA
map <Leader>cc :call CommentVariable()<CR>


                   """"""""""PYTHON LLM INTERFACE""""""""""


function LlmTip(prompt='null')

    let prompt = a:prompt
    let python_call_returns = ''

    " context is the whole content from current buffer
    let context=join(getline(1, '$'), "\n")
    
    py3f ~/.vim/scripts/test.py
    echo python_call_returns
" TODO: put it on a popup window and prevent it from giving the same tip twice
endfunc

colorscheme myhabamax

" run this file after all to avoid bugs
if has("win32")
    autocmd VimEnter * execute ':source $MYVIMRC'
else
    autocmd VimEnter * execute ':source ~/.vim/vimrc'
endif

autocmd FileType list execute ':source ~/.vim/vimrc_lisp'

" TIPS: 
" To format a json file run the command :%!python -m json.tool"
" To change every ocurrence and ask for confirmation, use :%s/{oldpattern}/{newpattern}/gc"

" TODO:
" registrar todo o clipboard de uma sessão. Isso vai ajud " ar a diminuir a 
" copia de trechos já usados.
"
" pop up com resposta de ai, com opção de com ou sem contexto do projeto
