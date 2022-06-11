------------------------------ GENERAL ------------------------------
--Enable mouse
vim.opt.mouse = "a"
--Make backspace normal
vim.opt.backspace = "indent,eol,start"
--Disable vi compatibility. Because we're not in 1995
vim.opt.compatible = false
--Disable automactic line wrapping
vim.opt.tw = 0
--Display whitespace characters
vim.opt.list = true
--Specify whitespace characters visualization
vim.opt.listchars = "tab:▸ ,trail:~,extends:>,precedes:<,space:·"
--Disable beeping
vim.opt.errorbells = false
--Encoding
vim.opt.encoding = "utf8"
--File formats that will be tried (in order) when vim reads and writes to a file
vim.opt.ffs = "unix,dos"
--vim.opt.preview window position to bottom of the page = true
vim.opt.splitbelow = true
--Show at least N lines above/below the cursor.
vim.opt.scrolloff = 5
--Opening a new file when the current buffer has unsaved changes causes files to be hidden instead of closed
vim.opt.hidden = true
--Undo many times
vim.opt.undolevels = 1000
--Undo across vim sessions
vim.opt.undofile = true
--Do not show message on last line when in Insert, Replace or Visual mode
vim.opt.showmode = false
--Enable TrueColor
vim.opt.termguicolors = true
--Shows the effects of a command incrementally, as you type
vim.opt.inccommand = "nosplit"
-- Increase the maximum amount of memory to use for pattern matching
vim.opt.maxmempattern = 2000
---------------------------------------------------------------------

------------------------------ SPACES & TABS -----------------------------
--Number of visual spaces per TAB
vim.opt.tabstop = 4
--Number of spaces in tab when editing
vim.opt.softtabstop = 4
--Tabs are spaces
vim.opt.expandtab = true
--Indent with 2 spaces
vim.opt.shiftwidth = 4
---------------------------------------------------------------------

------------------------------ UI CONFIG ------------------------------
--Show line numbers
vim.opt.number = true
--Load filetype-specific indent files
--filetype indent on
--Visual autocomplete for command menu
vim.opt.wildmenu = true
--Complete till longest common string && Complete the next full match
vim.opt.wildmode = "longest,full"
--Redraw only when we need to.
vim.opt.lazyredraw = true
--Highlight matching [{()}]
vim.opt.showmatch = true
--Solid vertical split line
vim.opt.fillchars = vim.opt.fillchars + "vert:│"
--Highlight current line
vim.opt.cursorline = true
---------------------------------------------------------------------

------------------------------ SEARCHING ------------------------------
--Incremental search
vim.opt.incsearch = true
--Highlight matches
vim.opt.hlsearch = true
--Ignore case on search
vim.opt.ignorecase = true
---------------------------------------------------------------------

------------------------ LUA MODULES SETUP --------------------------
-- display line error in popup after 1/2 second
vim.opt.updatetime = 500
---------------------------------------------------------------------

---------------------- LEFT MARGIN ----------------------------------
--  keep the left margin open always
vim.opt.signcolumn = "yes:1"
---------------------------------------------------------------------

--------------------- COMPLETION ------------------------------------
vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.shortmess = vim.opt.shortmess + "c"
---------------------------------------------------------------------

------------------------------ FOLDING ------------------------------
vim.opt.foldenable = true
-- vim.opt.foldexpr = nvim_treesitter#foldexpr()
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = "expr"
---------------------------------------------------------------------

vim.opt.list = false
