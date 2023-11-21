vim.cmd([[
let mapleader=' '
let maplocalleader='\'

" restore file cursor position
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif

" Read *.pl files as prolog files
augroup ft_prolog
    au!
    au BufNewFile,BufRead *.pl set filetype=prolog
augroup END

" autoremove trailing whitespace
autocmd VimEnter c,cpp,go,yaml,ruby,bash EnableStripWhitespaceOnSave
" autocmd FileType c,cpp,go,yaml,ruby,bash EnableStripWhitespaceOnSave

" ---------------------------------------------------------------------

" ------------------------------ COLORS ------------------------------
"Enable syntax processing
syntax enable


" This colorscheme
"colorscheme jellybeans

" Because jellybeans shows wrong background colors for whitespace characters  on current line
highlight NonText guibg=NONE

" Line numbers
highlight LineNr guifg=#545252

" Numbers when cursorline is enabled
highlight CursorLineNr guifg=#6A95EA

" Whitespace characters color
highlight SpecialKey guifg=grey35

" Search result highlight color
highlight Search gui=bold guifg=#000000 guibg=#6A95EA

" Vertical split highlight color
highlight VertSplit guifg=#1c1c1c guibg=#1c1c1c

" Sign column colors
" highlight SignColumn term=standout guifg=#777777 guibg=#1c1c1c

" Status lines of not-current windows
highlight StatusLineNC guibg=#1e2122 guifg=#1e2122

" Wildmenu autocomplete
highlight StatusLine gui=italic guifg=grey guibg=#1c1c1c

" ---------------------------------------------------------------------

" ------------------------------ SPACES & TABS -----------------------------
autocmd Filetype yaml set tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype ruby set tabstop=2 softtabstop=2 shiftwidth=2
" ---------------------------------------------------------------------

" ------------------------------ UI CONFIG ------------------------------
augroup CursorLine
    au!
    au VimEnter * setlocal cursorline
    au WinEnter * setlocal cursorline
    au BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END
" ---------------------------------------------------------------------

" ------------------------ LUA MODULES SETUP --------------------------
" load LSP
" must be called *after* updating colorscheme, else errors aren't highlighted
let g:coq_settings = {'auto_start': v:true, 'keymap': {'jump_to_mark': '<C-L>'}}
" Remap the <c-l> in normal mode to vim-tmux-navigator's binding. Coq also
" maps <c-l> in insert mode, so it will continue to work. This is a bit hacky,
" but at least jump_to_mark can be a sane binding
au VimEnter * :nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
au BufEnter * :nnoremap <silent> <c-l> :TmuxNavigateRight<cr>

autocmd CursorHold * Lspsaga show_line_diagnostics

" ---------------------------------------------------------------------

" ---------------------- LEFT MARGIN ----------------------------------
" show diagnostics in preference to git modification symbols
let signify_priority=5
" ---------------------------------------------------------------------

" -------------------------- AUTO FORMAT ------------------------------
augroup AutoFormat
    autocmd!
    autocmd BufWritePre *.go lua vim.lsp.buf.format({timeout_ms=3000}); LSP_organize_imports()
    autocmd BufWritePre *.rb lua vim.lsp.buf.format({timeout_ms=3000})
    autocmd BufWritePre *.json,*.md PrettierAsync
augroup END
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
let g:UltiSnipsJumpForwardTrigger='<c-l>'
let g:UltiSnipsJumpBackwardTrigger='<c-h>'
" --------------------------------------------------------------------------

" --------------------------------- FuzzyFind  -----------------------------
let g:fzf_layout = { 'down': '~30%' }
let g:fzf_buffers_jump = 1

" hide the statusline of the containing buffer
augroup fzf
  autocmd!
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END

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
" --------------------------------------------------------------------------

" ------------------Toggle showing outline view ----------------------------
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
" --------------------------------------------------------------------------
"
" -------------------------------- vim-rhubarb -----------------------------
" open in github
" --------------------------------------------------------------------------
"
set nolist


" --------------------- GO ALTERNATIVE FILE --------------------------------
" copied from https://github.com/fatih/vim-go

" --------------------------------------------------------------------------

" ----------------------- JSON / YAML TAGS ---------------------------------
" snakecase converts a string to snake case. i.e: FooBar -> foo_bar
" Copied from tpope/vim-abolish
" Used in go.snippets for json and yaml expansions
function! Snakecase(word) abort
  let word = substitute(a:word, '::', '/', 'g')
  let word = substitute(word, '\(\u\+\)\(\u\l\)', '\1_\2', 'g')
  let word = substitute(word, '\(\l\|\d\)\(\u\)', '\1_\2', 'g')
  let word = substitute(word, '[.-]', '_', 'g')
  let word = tolower(word)
  return word
endfunction
" --------------------------------------------------------------------------

" --------------------- :GoGenerate ----------------------------------------
" Copied and adapted from various places in vim-go
function SetGoCompilerOptions()
    setlocal errorformat =%-G#\ %.%#                                 " Ignore lines beginning with '#' ('# command-line-arguments' line sometimes appears?)
    setlocal errorformat+=%-G%.%#panic:\ %m                          " Ignore lines containing 'panic: message'
    setlocal errorformat+=%Ecan\'t\ load\ package:\ %m               " Start of multiline error string is 'can\'t load package'
    setlocal errorformat+=%A%\\%%(%[%^:]%\\+:\ %\\)%\\?%f:%l:%c:\ %m " Start of multiline unspecified string is 'filename:linenumber:columnnumber:'
    setlocal errorformat+=%A%\\%%(%[%^:]%\\+:\ %\\)%\\?%f:%l:\ %m    " Start of multiline unspecified string is 'filename:linenumber:'
    setlocal errorformat+=%C%*\\s%m                                  " Continuation of multiline error message is indented
    setlocal errorformat+=%-G%.%#                                    " All lines not matching any of the above patterns are ignored
endfunction

" --------------------------------------------------------------------------
command! WQ wq
command! Wq wq
command! W w
command! Q q

" Maximize current window
command Foc execute "winc | | winc _"
" Show all windows
command Unfoc execute "winc ="

" Show preview when searching files
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Use Rg for searching for contents and show preview
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --no-ignore --hidden --follow --glob "!.git/*" --glob "!vendor/" '.shellescape(<q-args>), 1,
  \    fzf#vim#with_preview({'down': '60%', 'options': '--bind alt-down:preview-down --bind alt-up:preview-up'},'right:50%', '?'),
  \   <bang>0)

"Load filetype-specific indent files
filetype indent on

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
command! -bang AT call GoAlternateSwitch(<bang>0, 'tabe')

augroup GoGenerate
  autocmd!
  autocmd FileType go call SetGoCompilerOptions()
augroup END

function! GoGenerate(bang) abort
  let default_makeprg = &makeprg
  let &makeprg = "go generate " . shellescape(expand("%:p:h"))

  try
    silent! exe 'make!'
  finally
    redraw!
    let &makeprg = default_makeprg
  endtry

  let errors = getqflist()
  if !empty(errors)
      let height = 10
      if len(errors) < 10
          let height = len(errors)
      endif
      exe 'copen ' . height
    if !a:bang
        cc 1
    endif
  else
    cclose
  endif
endfunction
command! -bang GoGenerate  call GoGenerate(<bang>0)
]])
