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
autocmd BufRead,BufNewFile *.c,*.h,*.cpp,*.C set ft=cpp cinoptions=g0t0(0 cindent

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

function! AddHeaderGuards()
    let headerGuard=input('Header Guard: ')
    exe "normal ^i#ifndef =headerGuard#define =headerGuard#endif // =headerGuard"
endfunction

" abbreviations
ab strr std::string&
ab cstrr const std::string&
"ab hguard <C-O>:let test=input('Enter header guard token: ')<CR><Esc><Esc>ggI<C-R>=test<CR>
ab HEADER <C-O>:call AddHeaderGuards()<CR><C-R>=Eatchar()<CR>

" Help delete character if it is 'empty space'
" stolen from Vim manual
function! Eatchar()
  let c = nr2char(getchar())
  return (c =~ '\s') ? '' : c
endfunction

" Replace abbreviation if we're not in comment or other unwanted places
" stolen from Luc Hermitte's excellent http://hermitte.free.fr/vim/
function! MapNoContext(key, seq)
  exe "let _s=@/"
  let syn = synIDattr(synID(line('.'),col('.')-1,1),'name')
  if syn =~? 'comment\|string\|character\|doxygen'
    return a:key
  else
    exe 'return "' .
    \ substitute( a:seq, '\\<\(.\{-}\)\\>', '"."\\<\1>"."', 'g' ) . '"'
  endif
endfunction

" Create abbreviation suitable for MapNoContext
function! Iab (ab, full)
  exe "iab <silent> <buffer> ".a:ab." <C-R>=MapNoContext('".
    \ a:ab."', '".escape (a:full.'<C-R>=Eatchar()<CR>', '<>\"').
    \"')<CR>"
endfunction

autocmd BufRead,BufNewFile *.c,*.h,*.cpp,*.C call Iab('#d', '#define ')
autocmd BufRead,BufNewFile *.c,*.h,*.cpp,*.C call Iab('#i', '#include <><Left>')
autocmd BufRead,BufNewFile *.c,*.h,*.cpp,*.C call Iab('#I', '#include ""<Left>')
"call Iab('printf', 'printf ("\n");<C-O>?\<CR>')
"call Iab('if', 'if ()<CR>{<CR>}<Left><C-O>?)<CR>')
"call Iab('for', 'for (;;)<CR>{<CR>}<C-O>?;;<CR>')
"call Iab('while', 'while ()<CR>{<CR>}<C-O>?)<CR>')
"call Iab('else', 'else<CR>{<CR>x;<CR>}<C-O>?x;<CR><Del><Del>')
"call Iab('ifelse', 'if ()<CR>{<CR>}<CR>else<CR>{<CR>}<C-O>?)<CR>')
autocmd BufRead,BufNewFile *.c,*.h,*.cpp,*.C call Iab('intmain', 'int<CR>main (int argc, char *argv[])<CR>'.
 \ '{<CR>x;<CR>return 0;<CR>}<CR><C-O>?x;<CR><Del><Del>')

set tags+=~/.vim/tags/cpp
set tags+=~/.vim/tags/external
set tags+=~/.vim/tags/beissbarth
map <C-F12> :!bb_tags_beissbarth<CR>
inoremap <Nul> <C-X><C-O>
inoremap <C-Space> <C-X><C-O>

filetype plugin on

"" OmniCppComplete
"let OmniCpp_NamespaceSearch = 1
"let OmniCpp_GlobalScopeSearch = 1
"let OmniCpp_ShowAccess = 1
"let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
"let OmniCpp_MayCompleteDot = 1 " autocomplete after .
"let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
"let OmniCpp_MayCompleteScope = 0 " autocomplete after ::
"let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
"" automatically open and close the popup menu / preview window
""au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
"set completeopt=menuone,menu,longest,preview

"au BufNewFile,BufRead,BufEnter *.cpp,*.hpp set omnifunc=omni#cpp#complete#Main

" use python/perl regexp syntax
"nnoremap / /\v
"vnoremap / /\v
