execute pathogen#infect()
call plug#begin('~/.vim/plugged')
set rtp+=/usr/local/opt/fzf
set conceallevel=3
set guifont=Hack\ Regular\ Nerd\ Font\ Complete:h12
let g:airline_theme='bubblegum'
set nocompatible
set nohlsearch
set ignorecase
set hidden

" Plug
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

set number
 filetype plugin indent on
set encoding=utf-8

set list
set listchars=tab:>\ ,space:.

command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
     if part[0] =~ '\v[%#<]'
        let expanded_part = fnameescape(expand(part))
        let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     endif
  endfor
  botright new
  call setline(1, 'You entered:    ' . a:cmdline)
  call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  call setline(3,substitute(getline(2),'.','=','g'))
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  setlocal nomodifiable
  1
  execute '$read !'. expanded_cmdline
endfunction

let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

function! SwitchKeymapMario()
  map h <insert>
  iunmap jk
  nnoremap h i
  nnoremap j h
  nnoremap k j
  nnoremap i k
  nnoremap gk gj
  nnoremap gi gk
  nnoremap <C-u> <C-i>
  nnoremap <C-f> <C-u>
  vnoremap <C-f> <C-u>
  vnoremap h i
  vnoremap j h
  vnoremap k j
  vnoremap i k
  vnoremap gk gj
  vnoremap gi gk
endfunction

function! SwitchKeymapDefault()
  imap jk <Esc>
  unmap h
  unmap j
  unmap k
  unmap i
  unmap <C-i>
  unmap <C-f>
  unmap gk
  unmap gi

endfunction

nnoremap <F8> :call SwitchKeymapMario()<CR>
nnoremap <F5> :call SwitchKeymapDefault()<CR>

"COLOR SCHEME"
set wildignore+=*.pyc,*.o,*.obj,*.svn,*.swp,*.class,*.hg,*.DS_Store,*.min.*
let NERDTreeRespectWildIgnore=1
let g:NERDTreeWinPos = "left"
let NERDTreeShowHidden=1
let NERDTreeIgnore = ['\.pyc$','__pycache__']
let g:NERDTreeWinSize=30
let g:NERDTreeMapOpenSplit = 'v'
let g:NERDTreeMapActivateNode = 'e'
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
autocmd FileType nerdtree setlocal nolist
command Close :tabclose
command C :tabclose
command W :w

"" NERDTrees File highlighting
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

autocmd filetype nerdtree highlight haskell_icon ctermbg=none ctermfg=Red guifg=#ffa500
autocmd filetype nerdtree highlight html_icon ctermbg=none ctermfg=Red guifg=#ffa500
autocmd filetype nerdtree highlight go_icon ctermbg=green ctermfg=Red guifg=#ffa500

autocmd filetype nerdtree syn match haskell_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match html_icon ## containedin=NERDTreeFile,html
autocmd filetype nerdtree syn match go_icon ## containedin=NERDTreeFile

autocmd CursorMoved * exe exists("HlUnderCursor")?HlUnderCursor?printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\')):'match none':""

let mapleader=","
set ttymouse=xterm2
set mouse=a
set timeout timeoutlen=250
let g:NERDTreeMouseMode=3
map <C-j> <C-W>j
map <C-k> <C-W>j
map <C-i> <C-W>k
map <C-j> <C-W>h
map <C-l> <C-W>l
map <C-\> <C-F>
map <C-m> <C-B>
map <C-e> $
map <C-a> ^
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark<Space>
map <leader>nf :NERDTreeFind<cr>
map <C-c> "*y<cr>
map <Tab><Tab> :tabn<cr>
map <leader>wr :Shell rubocop --auto-correct <afile><cr>
map <leader>gr :Shell bundle exec guard &<cr>
map <leader>vv :vert sb<cr>
map <leader>q :q<cr>
map <leader>wqa :wqa<cr>
map <leader>qa :qa<cr>
map <leader>s :w<cr>
map <C-n> :tabe<cr>:NERDTreeToggle<cr>
map <leader>b :GoDef<cr>
map ;; <Esc>
nmap <CR> :w<CR>
imap jk <Esc>
nnoremap \\ :exe "let HlUnderCursor=exists(\"HlUnderCursor\")?HlUnderCursor*-1+1:1"<CR>
nmap po :pu<CR>
nmap <leader>b :bn<CR>
nmap <leader>v :bp<CR>
nmap <leader>x :bd<CR>
map h <insert>
nnoremap h i
nnoremap j h
nnoremap k j
nnoremap i k
nnoremap gk gj
nnoremap gi gk
nnoremap <C-f> <C-u>
nnoremap <C-u> <C-i>
vnoremap <C-f> <C-u>
vnoremap h i
vnoremap j h
vnoremap k j
vnoremap i k
vnoremap gk gj
vnoremap gi gk

"map i <Up>
"map j <Left>
"map k <Down>
map <Up> <Up>
map <Left> <Left>
map <Down> <Down>
map <Right> <Right>
imap <C-e> <C-o>$
imap <C-a> <C-o>^
imap <C-j> <Left>
imap <C-k> <Down>
imap <C-i> <Up>
imap <C-l> <Right>
imap <C-n> :tabe<cr>
imap <leader>e <Esc>O
imap <leader>s <Esc>:w<cr>i
imap <leader>b <Esc>:GoDef<cr>a
imap <leader>r <Esc>:GoRename<cr>
imap <leader>i <Esc>:GoImport<cr>i
imap <leader>cc <Esc>:GoCoverage<cr>i
imap ;; <Esc>
iunmap <Tab>
nnoremap <S-Up> :m-2<CR>
nnoremap <S-Down> :m+<CR>
inoremap <S-Up> <Esc>:m-2<CR>
inoremap <S-Down> <Esc>:m+<CR>
vnoremap <S-Up> :m '<-2<CR>gv=gv
vnoremap <S-Down> :m '>+1<CR>gv=gv
vnoremap < <gv
vnoremap > >gv
nmap <silent> <S-A-Up> :wincmd k<CR>
nmap <silent> <S-A-Down> :wincmd j<CR>
nmap <silent> <S-A-Left> :wincmd h<CR>
nmap <silent> <S-A-Right> :wincmd l<CR>
nnoremap <silent><A-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><A-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>

autocmd FileType ruby map <F9> :w<CR>:!ruby -c %<CR>

"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:go_fmt_command = "goimports"

filetype plugin indent on
set tabstop=2
set shiftwidth=2
set expandtab
set sw=2
set ts=2
autocmd Filetype ruby set tabstop=4
autocmd Filetype ruby set expandtab
autocmd Filetype ruby set softtabstop=2
autocmd Filetype ruby set sw=2
autocmd Filetype ruby set ts=2

autocmd Filetype shell set tabstop=4
autocmd Filetype shell set expandtab
autocmd Filetype shell set softtabstop=2
autocmd Filetype shell set sw=2
autocmd Filetype shell set ts=2

autocmd Filetype yaml set tabstop=4
autocmd Filetype yaml set expandtab
autocmd Filetype yaml set softtabstop=2
autocmd Filetype yaml set sw=2
autocmd Filetype yaml set ts=2

autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

set completeopt-=preview
let g:airline#extensions#tabline#enabled = 1
let g:syntastic_cpp_compiler = "g++"
let g:syntastic_cpp_compiler_options = "-std=c++11 -Wall -Wextra -Wpedantic"
let g:ycm_global_ycm_extra_conf = '.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_key_list_select_completion = ['<Down>']

let g:lightline = {
  \ 'colorscheme': 'onedark',
  \ }

try
    set laststatus=2
    set t_Co=256
    syntax off
    set background=dark
    colorscheme gruvbox
    "colorscheme PaperColor
catch
    echo “Failed to setup colorscheme”
endtry

autocmd VimEnter * call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
"nnoremap <unique> <expr> <CR> empty(&buftype) ? ':w<CR>' : '<CR>'
if exists("g:loaded_webdevicons")
  call webdevicons#refresh()
endif

