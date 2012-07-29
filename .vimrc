" set color scheme to my favourite "koehler" scheme
colorscheme oxygene
" turn on syntax highlighting
syntax on
" some colors are wrong if we do not issue "syntax reset"
syntax reset

" turn on mouse interaction
set mouse=a
" interpret modelines
set modeline

" settings for formatting text.
"  t: Auto-wrap text using textwidth.
"  c: Auto-wrap comments using textwidth.
"  r: Automaticalle insert comment leader when pressing <Enter> in Insert mode.
"  q: Allow formatting of comments with "gq".
"  o: Automatically insert the current commend leader after 'o'/'O' in Normal mode.
set formatoptions=tcqro

" expand tabs to spaces
set et

" set shiftwidth (number of spaces to use for each step of autoindent)
set sw=4
" set length of <Tab>
set ts=4

" autoindent
set ai

" turn off cindent by default
set nocindent

" highlight current line when in gui mode
if has("gui_running")
set cursorline
endif

" memory is cheap, use larger history than vim's default of 20
set history=100
set viminfo='50,<1000,s100,f100
" jump to last visitied position of a previously opened file (see :help last-position-jump)
:au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" do not resize remaining windows to have equal size when closing a window
set noea

" make invisible characters visible
" enter special characters using digraphs: CTRL-K {char1} {char2}
"
" Some nice digraphs:
"   ▷  Tr
"   »  >>
"   ∙  Sb
"   −  2-
"   ·  .M
set listchars=tab:»−,trail:·,extends:>
set list

" set highlight color for special keys like <Tab> or trailing spaces
hi SpecialKey guifg=#805830 ctermfg=red

" cindent options, see :help cinoptions-values
"
" g0 - do not indent scope declarations (public/protected/private)
" t0 - do not indent function return type declarations
" (0 - align indent in open parantheses

" c/c++ settings
autocmd BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp,*.C set ft=cpp cinoptions=g0t0(0 cindent

autocmd FileType text set nocindent

" Ensure that cursorline is only enabled in one window
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

" highlighting of last search hits
set hls
" add CTRL+H binding to stop highlighting the last search hits
inoremap <c-h> <c-o>:noh<cr>
nnoremap <c-h> :noh<cr>
vnoremap <c-h> :noh<cr>

" smart home key
inoremap <silent> <Home> <c-o>:call <SID>SmartHomeKey()<cr>
nnoremap <silent> <Home> :call <SID>SmartHomeKey()<cr>
function! s:SmartHomeKey()
let ll = strpart(getline('.'), -1, col('.'))
if ll =~ '^\s\+$' | normal! 0
else              | normal! ^
endif
endfunction

set runtimepath+=/usr/share/vim/addons/
