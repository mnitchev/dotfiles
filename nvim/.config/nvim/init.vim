" ------------------------------ PLUGINS ------------------------------
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
    " This plugin manager
    Plug 'junegunn/vim-plug'

    " Allow vim to do tmux stuff, like open panes for the test plugin
    Plug 'benmills/vimux'
    " Highlights and removes trailing whitespace
    Plug 'bronson/vim-trailing-whitespace'
    " Syntax highlighting for starlark
    Plug 'cappyzawa/starlark.vim'
    " Add mappings to copy to clipboard - doesn't work over ssh
    Plug 'christoomey/vim-system-copy'
    " Navigate through vim splits seamlessly
    Plug 'christoomey/vim-tmux-navigator'
    " popup windows for LSP helpers
    Plug 'glepnir/lspsaga.nvim'
    " Light and configurable statusline
    Plug 'itchyny/lightline.vim'
    " Preview markdown files in the browser
    Plug 'JamshedVesuna/vim-markdown-preview'
    " Test runner integration
    Plug 'janko/vim-test'
    " Generates method stubs for implementing an interface
    Plug 'josharian/impl'
    " Awesome fuzzy finder
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    " Outline viewer for vim
    Plug 'majutsushi/tagbar'
    Plug 'mhinz/vim-grepper'
    " Show git diff in the sign column
    Plug 'mhinz/vim-signify'
    " Fancy start screen
    Plug 'mhinz/vim-startify'
    " Toggle quickfix and location windows
    Plug 'milkypostman/vim-togglelist'
    " Unobtrusive scratch window
    Plug 'mtth/scratch.vim'
    " Our colorscheme
    Plug 'nanotech/jellybeans.vim'
    " Config for built-in nvim lsp
    Plug 'neovim/nvim-lspconfig'
    " lsp auto completions
    Plug 'nvim-lua/completion-nvim'
    " lsp status helper
    Plug 'nvim-lua/lsp-status.nvim'
    " use built-in syntax highlighting engine
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    " ANSI escape sequences concealed, but highlighted as specified
    Plug 'powerman/vim-plugin-AnsiEsc'
    " prettier formatting
    Plug 'prettier/vim-prettier', { 'do': 'npm install', 'for': ['json', 'markdown'] }
    " Reveal the commit messages under the cursor in a 'popup window'
    Plug 'rhysd/git-messenger.vim'
    " Make hlsearch more useful
    Plug 'romainl/vim-cool'
    " Selectively illuminating other uses of the current word under the cursor
    Plug 'RRethy/vim-illuminate'
    " Directory tree explorer
    Plug 'scrooloose/nerdtree'
    " Add various code snippets
    Plug 'SirVer/ultisnips'
    " Comment stuff out
    Plug 'tpope/vim-commentary'
    " Unix utility commands
    Plug 'tpope/vim-eunuch'
    " Git wrapper
    Plug 'tpope/vim-fugitive'
    " Make . work with tpope's plugins
    Plug 'tpope/vim-repeat'
    " Open selected code in githb in browser
    Plug 'tpope/vim-rhubarb'
    " Provides mappings to easily delete, change and add surroundings (parentheses, brackets, quotes, XML tags, and more) in pairs
    Plug 'tpope/vim-surround'
    " Useful mappings
    Plug 'tpope/vim-unimpaired'
    " Add snippets for Ginkgo BDD testing library for go
    Plug 'trayo/vim-ginkgo-snippets'
    Plug 'trayo/vim-gomega-snippets'
    " Ruby plugin
    Plug 'vim-ruby/vim-ruby'
    " ytt syntax highlighting
    Plug 'vmware-tanzu/ytt.vim'
    " Runs shfmt to auto format the current buffer
    Plug 'z0mbix/vim-shfmt', { 'for': 'sh' }
call plug#end()
" ---------------------------------------------------------------------

" ------------------------------ GENERAL ------------------------------
set mouse=a                                                           "Enable mouse
set backspace=indent,eol,start                                        "Make backspace normal
set nocompatible                                                      "Disable vi compatibility. Because we're not in 1995
set tw=0                                                              "Disable automactic line wrapping
set list                                                              "Display whitespace characters
set listchars=tab:▸\ ,trail:~,extends:>,precedes:<,space:·            "Specify whitespace characters visualization
set noerrorbells                                                      "Disable beeping
set encoding=utf8                                                     "Encoding
set ffs=unix,dos                                                      "File formats that will be tried (in order) when vim reads and writes to a file
set splitbelow                                                        "Set preview window position to bottom of the page
set scrolloff=5                                                       "Show at least N lines above/below the cursor.
set hidden                                                            "Opening a new file when the current buffer has unsaved changes causes files to be hidden instead of closed
set undolevels=1000                                                   "Undo many times
set undofile                                                          "Undo across vim sessions
set noshowmode                                                        "Do not show message on last line when in Insert, Replace or Visual mode
set termguicolors                                                     "Enable TrueColor
set inccommand=nosplit                                                "Shows the effects of a command incrementally, as you type

if !has('nvim')
  set ttymouse=sgr                                                    "Make the mouse work even in columns beyond 223
endif

let mapleader=' '
let maplocalleader='\'

"Replace escape with jk
inoremap jk <esc>

"Convert current word to uppercase
inoremap <C-u> <esc>mzgUiw`za

command! WQ wq
command! Wq wq
command! W w
command! Q q

" restore file cursor position
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif

" Increase the maximum amount of memory to use for pattern matching
set maxmempattern=2000

"show the changes after the last save
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction

com! DiffSaved call s:DiffWithSaved()

" Maximize current window
command Foc execute "winc | | winc _"
" Show all windows
command Unfoc execute "winc ="

" vimrc key mappings
nmap <silent> <leader>ve :edit ~/.config/nvim/init.vim<CR>
nmap <silent> <leader>vs :source ~/.config/nvim/init.vim<CR>

" Read *.pl files as prolog files
augroup ft_prolog
    au!
    au BufNewFile,BufRead *.pl set filetype=prolog
augroup END

" save on enter
nnoremap <silent> <expr> <cr> empty(&buftype) ? ':w<cr>' : '<cr>'

" search mappings
nnoremap <silent> <leader>ss :Grepper -tool rg<cr>
nnoremap <leader>sr :Rg

function! s:search_term_under_cursor()
  execute "Rg " expand("<cword>")
endfunction
nnoremap <leader>st :call <SID>search_term_under_cursor()<CR>

" autoremove trailing whitespace
autocmd BufWritePre * FixWhitespace

" shell-like navigation while in normal mode
inoremap <c-b> <c-\><c-o>h
inoremap <c-f> <c-\><c-o>l
" ---------------------------------------------------------------------

" ------------------------------ COLORS ------------------------------
"Enable syntax processing
syntax enable

" Colorscheme overrides
let g:jellybeans_overrides = {'background': { 'guibg': '1c1c1c' }}

" This colorscheme
colorscheme jellybeans

" Because jellybeans shows wrong background colors for whitespace characters  on current line
highlight NonText guibg=NONE

" Line numbers
highlight LineNr guifg=#545252 guibg=#1c1c1c

" Current line colors
highlight CursorLine guibg=#232323

" Numbers when cursorline is enabled
highlight CursorLineNr guibg=#1c1c1c guifg=#6A95EA

" Whitespace characters color
highlight SpecialKey guifg=grey35

" Search result highlight color
highlight Search gui=bold guifg=#000000 guibg=#6A95EA

" Vertical split highlight color
highlight VertSplit guifg=#1c1c1c guibg=#1c1c1c

" Sign column colors
highlight SignColumn term=standout guifg=#777777 guibg=#1c1c1c

" Status lines of not-current windows
highlight StatusLineNC guibg=#1c1c1c

" Wildmenu autocomplete
highlight StatusLine gui=italic guifg=grey guibg=#1c1c1c

" ---------------------------------------------------------------------

" ------------------------------ SPACES & TABS -----------------------------
set tabstop=4               "Number of visual spaces per TAB
set softtabstop=4           "Number of spaces in tab when editing
set expandtab               "Tabs are spaces
set shiftwidth=4            "Indent with 2 spaces

autocmd Filetype yaml set tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype ruby set tabstop=2 softtabstop=2 shiftwidth=2
" ---------------------------------------------------------------------

" ------------------------------ UI CONFIG ------------------------------
set number                              "Show line numbers
filetype indent on                      "Load filetype-specific indent files
set wildmenu                            "Visual autocomplete for command menu
set wildmode=longest,full               "Complete till longest common string && Complete the next full match
set lazyredraw                          "Redraw only when we need to.
set showmatch                           "Highlight matching [{()}]
set fillchars+=vert:│                   "Solid vertical split line
set cursorline                          "Highlight current line

augroup CursorLine
    au!
    au VimEnter * setlocal cursorline
    au WinEnter * setlocal cursorline
    au BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END
" ---------------------------------------------------------------------

" ------------------------------ SEARCHING ------------------------------
set incsearch               "Incremental search
set hlsearch                "Highlight matches
set ignorecase              "Ignore case on search
" ---------------------------------------------------------------------

" ------------------------ LUA MODULES SETUP --------------------------
" load LSP
" must be called *after* updating colorscheme, else errors aren't highlighted
lua require('config.lsp')

lua require('lspsaga').init_lsp_saga()
lua require('config.lspstatus')
lua require('config.treesitter')

" display line error in popup after 1/2 second
set updatetime=500
autocmd CursorHold * Lspsaga show_line_diagnostics

" ---------------------------------------------------------------------

" ---------------------- LEFT MARGIN ----------------------------------
"  keep the left margin open always
set signcolumn=yes:1
" show diagnostics in preference to git modification symbols
let signify_priority=5
" ---------------------------------------------------------------------

" --------------------- COMPLETION ------------------------------------
set completeopt=menuone,noinsert,noselect
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
set shortmess+=c
let g:completion_enable_snippet = 'UltiSnips'
autocmd BufEnter * lua require'completion'.on_attach()
" ---------------------------------------------------------------------

" ------------------------------ FOLDING ------------------------------
set foldenable
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=99
set foldmethod=expr
" ---------------------------------------------------------------------

" -------------------------- AUTO FORMAT ------------------------------
augroup AutoFormat
    autocmd!
    autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 10000); LSP_organize_imports()
    autocmd BufWritePre *.rb lua vim.lsp.buf.formatting_sync(nil, 3000)
    autocmd BufWritePre *.json,*.md PrettierAsync
augroup END
" ---------------------------------------------------------------------

" ------------------------------ MOVEMENT ------------------------------
"Move vertically (down) by visual line
nnoremap j gj
"Move vertically (up) by visual line
nnoremap k gk

" Movement in popup menu
inoremap <expr> <C-j> pumvisible() ? "\<C-N>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"
" ---------------------------------------------------------------------


" ------------------------------ SANE PASTING---------------------------
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction

function! s:Repl()
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<cr>"
endfunction

" NB: this supports "rp that replaces the selection by the contents of @r
vnoremap <silent> <expr> p <sid>Repl()
" ---------------------------------------------------------------------

" ------------------------------ CONTINUE INDENTING---------------------
vnoremap > >gv
vnoremap < <gv
" ---------------------------------------------------------------------

" =======================================================================================
" =============================== PLUGIN CONFIGURATIONS =================================
" =======================================================================================

" --------------------------------- NERDTree -------------------------------

function! NERDTreeToggleAndFind()
  if (exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1)
    execute ':NERDTreeClose'
  else
    if (expand("%:t") != '')
        execute ':NERDTreeFind'
    else
        execute ':NERDTreeToggle'
    endif
  endif
endfunction

" Toggle NERDTree
nnoremap <C-n> :call NERDTreeToggleAndFind()<CR>
nnoremap <silent> \ :NERDTreeToggle<CR>
nnoremap <silent> \| :NERDTreeFind<cr>

" Single mouse click will open any node
let g:NERDTreeMouseMode=3

" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Automatically delete the buffer of the file you just deleted with NerdTree
let NERDTreeAutoDeleteBuffer = 1

" Hide 'Press ? for help' and bookmarks
let NERDTreeMinimalUI = 1

" Expand directory symbols
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" Unmap C-j and C-k from NERDTree.
" This breaks vim-tmux integration otherwise.
let g:NERDTreeMapJumpNextSibling = ''
let g:NERDTreeMapJumpPrevSibling = ''

" Do not show whitespace characters in NERDTree window
autocmd FileType nerdtree setlocal nolist

" Show hidden files
let NERDTreeShowHidden=1

" --------------------------------------------------------------------------

" --------------------------------- Lightline --------------------------------

" Show statusline
set laststatus=2

" Colors
let s:green = [ '#99ad6a', 107 ]
let s:red = [ '#dd1c1c', 167 ]
let s:yellow = [ '#ffb964', 215 ]
let s:blue = [ '#6A95EA', 103, 'bold' ]
let s:lightgrey = [ '#999494', 'none' ]
let s:blackish = [ '#1c1c1c', 'none' ]
let s:darkgrey = [ '#282525', 'none' ]

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

" Middle
let s:p.normal.middle = [ [ s:lightgrey, s:blackish ] ]

" Left
let s:p.normal.left = [ [ s:blue, s:blackish ], [ s:green, s:blackish ], [ s:red, s:blackish ], [ s:lightgrey, s:blackish ] ]
let s:p.insert.left = [ [ s:blue, s:blackish ], [ s:green, s:blackish ], [ s:red, s:blackish ], [ s:lightgrey, s:blackish ] ]
let s:p.replace.left = [ [ s:blue, s:blackish ], [ s:green, s:blackish ], [ s:red, s:blackish ], [ s:lightgrey, s:blackish ] ]
let s:p.visual.left = [ [ s:blue, s:blackish ], [ s:green, s:blackish ], [ s:red, s:blackish ], [ s:lightgrey, s:blackish ] ]

" Right
let s:p.normal.right = [ [ s:lightgrey, s:blackish ], [ s:lightgrey, s:blackish ], [ s:lightgrey, s:blackish ] ]

" Inactive
let s:p.inactive.middle = [ [ s:lightgrey, s:darkgrey ] ]
let s:p.inactive.right = [ [ s:darkgrey, s:darkgrey ], [ s:darkgrey, s:darkgrey ] ]

" Errors & warnings
let s:p.normal.error = [ [ s:red, s:blackish ] ]
let s:p.normal.warning = [ [ s:yellow, s:blackish ] ]

" Tabs
let s:p.tabline.left = [ [ s:lightgrey, s:blackish ] ]
let s:p.tabline.tabsel = [ [ s:blue, s:blackish ] ]

" Set the palette
let g:lightline#colorscheme#jellybeans#palette = lightline#colorscheme#flatten(s:p)

" Lightline configs
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch' ],
      \             [ 'readonly' ],
      \             [ 'relativepath', 'modified' ] ],
      \   'right': [ [ 'lspstatus'],
      \              [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'filetype', 'encodingformat' ] ],
      \ },
      \ 'component_function': {
      \   'lspstatus': 'LspStatus',
      \   'gitbranch': 'LightlineBranch',
      \   'mode': 'LightlineMode',
      \   'encodingformat': 'LightlineFileEncodingFormat',
      \   'lineinfo': 'LightlineLineInfo',
      \   'percent': 'LightlinePercent',
      \   'filetype': 'LightlineFiletype',
      \   'relativepath': 'LightlineRelativePath',
      \   'modified': 'LightlineModified',
      \   'readonly': 'LightlineReadonly',
      \ },
      \ 'subseparator': { 'left': '', 'right': '' },
      \ }

" Custom functions
function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction

function! LightlineBranch()
  if &ft == 'nerdtree'
    return ''
  endif
  let branch = fugitive#head()
  return branch !=# '' ? ' ' . branch : ''
endfunction

function! LightlineMode()
  if &ft == 'nerdtree'
    return '« NERD »'
  endif
  return '« ' . lightline#mode() . ' »'
endfunction

function! LightlineFileEncodingFormat()
  if &ft == 'nerdtree'
    return ''
  endif
  let encoding = &fenc!=#""?&fenc:&enc
  let format = &ff
  return encoding . '[' . format . ']'
endfunction

function! LightlineLineInfo()
  if &ft == 'nerdtree'
    return ''
  endif
  return line('.').':'. col('.')
endfunction

function! LightlinePercent()
  if &ft == 'nerdtree'
    return ''
  endif
  return line('.') * 100 / line('$') . '%'
endfunction

function! LightlineFiletype()
  if &ft == 'nerdtree'
    return ''
  endif
  return &ft !=# "" ? &ft : "no ft"
endfunction

function! LightlineRelativePath()
  if &ft == 'nerdtree'
    return ''
  endif
  return expand("%")
endfunction

function! LightlineModified()
  if &ft == 'nerdtree'
    return ''
  endif
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
  if &ft == 'nerdtree'
    return ''
  endif
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction
" --------------------------------------------------------------------------

" Toggle comment with ctrl + /
nmap <C-_> gc$
vmap <C-_> gc

" --------------------------------- Vim-Markdown-Preview --------------------------------

" Use Chrome
let vim_markdown_preview_browser='Google Chrome'

" Use github syntax
let vim_markdown_preview_github=1

" Leave Ctrl-P alone
let vim_markdown_preview_hotkey='<Leader>mp'

" --------------------------------------------------------------------------

" --------------------------- Cool Matching  -------------------------------
" Show number of matches in the command-line
let g:CoolTotalMatches = 1
" --------------------------------------------------------------------------

" --------------------------------- Shfmt  -------------------------------
" Use 2 spaces instead of tabs
let g:shfmt_extra_args = '-i 2 -ci'
let g:shfmt_fmt_on_save = 1
" --------------------------------------------------------------------------

" --------------------------------- Snippets  -------------------------------
""" ultisnips
let g:UltiSnipsExpandTrigger='<c-j>'
let g:UltiSnipsJumpForwardTrigger='<c-f>'
let g:UltiSnipsJumpBackwardTrigger='<c-b>'
" --------------------------------------------------------------------------

" --------------------------------- FuzzyFind  -----------------------------
let g:fzf_layout = { 'down': '~30%' }
let g:fzf_buffers_jump = 1

" Show preview when searching files
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Use Rg for searching for contents and show preview
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --no-ignore --hidden --follow --glob "!.git/*" --glob "!vendor/" '.shellescape(<q-args>), 1,
  \    fzf#vim#with_preview({'down': '60%', 'options': '--bind alt-down:preview-down --bind alt-up:preview-up'},'right:50%', '?'),
  \   <bang>0)

" hide the statusline of the containing buffer
augroup fzf
  autocmd!
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END

nnoremap <silent> <c-p> :Files<cr>
nnoremap <silent> <leader>fo :Buffers<cr>
nnoremap <silent> <leader>fm :History<cr>
nnoremap <silent> <leader>fd :bp\|bd #<cr>
nnoremap <silent> <leader>fn :bn<cr>
nnoremap <silent> <leader>fp :bp<cr>
nnoremap <silent> <leader>fa :A<cr>
nnoremap <silent> <leader>m `
" --------------------------------------------------------------------------
"
" -------------------------------- Startify --------------------------------
let g:startify_custom_header = map(systemlist('fortune | cowsay -f $HOME/cows/eirini.cow'), '"               ". v:val')
let g:startify_change_to_dir = 0
let g:startify_change_to_vcs_root = 1
let g:startify_lists = [
                  \ { 'type': 'dir',       'header': [   'MRU ' . getcwd()] },
                  \ { 'type': 'files',     'header': [   'MRU']             },
                  \ { 'type': 'sessions',  'header': [   'Sessions']        },
                  \ { 'type': 'bookmarks', 'header': [   'Bookmarks']       },
                  \ { 'type': 'commands',  'header': [   'Commands']        },
                  \ ]
" --------------------------------------------------------------------------

" ------------------Toggle showing whitespaces------------------------------
nnoremap <F3> :set list!<CR>
" --------------------------------------------------------------------------

" ------------------Toggle showing outline view ----------------------------
nmap <F8> :TagbarToggle<CR>
" --------------------------------------------------------------------------
"
" ------------------ Testing -----------------------------------------------
if empty($TMUX)
  let g:test#strategy = 'neoterm'
else
  let g:test#strategy = 'vimux'
endif

"" We can customise tests requiring setup as below...
function! ScriptTestTransform(cmd) abort
  let l:command = a:cmd

  let l:commandTail = split(a:cmd)[-1]
  if &filetype == 'go'
    if filereadable('scripts/test')
      let l:command = 'scripts/test ' . l:commandTail
    end
  end

  return l:command
endfunction

let g:test#custom_transformations = {'scripttest': function('ScriptTestTransform')}
let g:test#transformation = 'scripttest'
nnoremap <silent> <leader>tt :TestNearest<cr>
nnoremap <silent> <leader>t. :TestLast<cr>
nnoremap <silent> <leader>tf :TestFile<cr>
nnoremap <silent> <leader>ts :TestSuite<cr>
nnoremap <silent> <leader>tg :TestVisit<cr>
" --------------------------------------------------------------------------
"
" -------------------------------- vim-rhubarb -----------------------------
" open in github
nmap <silent> <leader>gh :GBrowse<cr>
vmap <silent> <leader>gh :GBrowse<cr>
" --------------------------------------------------------------------------
"
set nolist


" --------------------- GO ALTERNATIVE FILE --------------------------------
" copied from https://github.com/fatih/vim-go

" Test alternates between the implementation of code and the test code.
function! GoAlternateSwitch(bang, cmd) abort
  let file = expand('%')
  if empty(file)
    echo "no buffer name"
    return
  elseif file =~# '^\f\+_test\.go$'
    let l:root = split(file, '_test.go$')[0]
    let l:alt_file = l:root . ".go"
  elseif file =~# '^\f\+\.go$'
    let l:root = split(file, ".go$")[0]
    let l:alt_file = l:root . '_test.go'
  else
    echo "not a go file"
    return
  endif
  if !filereadable(alt_file) && !bufexists(alt_file) && !a:bang
    echo "couldn't find ".alt_file
    return
  elseif empty(a:cmd)
    execute ":edit " .  alt_file
  else
    execute ":" . a:cmd . " " . alt_file
  endif
endfunction

command! -bang A  call GoAlternateSwitch(<bang>0, '')
command! -bang AS call GoAlternateSwitch(<bang>0, 'split')
command! -bang AV call GoAlternateSwitch(<bang>0, 'vsplit')

" --------------------------------------------------------------------------
