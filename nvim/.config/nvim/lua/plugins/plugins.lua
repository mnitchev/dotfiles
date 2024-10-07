return require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Allow vim to do tmux stuff, like open panes for the test plugin
    use 'benmills/vimux'
    -- Highlights and removes trailing whitespace
    use 'ntpeters/vim-better-whitespace'
    -- Syntax highlighting for helm
    use 'towolf/vim-helm'
    -- Syntax highlighting for starlark
    use 'cappyzawa/starlark.vim'
    -- Add mappings to copy to clipboard - doesn't work over ssh
    use 'christoomey/vim-system-copy'
    -- Navigate through vim splits seamlessly
    use 'christoomey/vim-tmux-navigator'
    -- popup windows for LSP helpers

    -- Light and configurable statusline
    use 'feline-nvim/feline.nvim'
    use 'mnitchev/extensions'
    use {
        'mnitchev/base46',
        config = function()
           local ok, base46 = pcall(require, "base46")

           if ok then
              base46.load_theme()
           end
        end,
  }
    -- Preview markdown files in the browser
    use 'JamshedVesuna/vim-markdown-preview'
    -- Test runner integration
    use 'janko/vim-test'
    -- Directory tree explorer
    use 'kyazdani42/nvim-web-devicons'
    use 'kyazdani42/nvim-tree.lua'
    -- Buffers visualised as tabs
    use {
       'akinsho/bufferline.nvim',
       tag = 'v2.*'
    }
    -- Generates method stubs for implementing an interface
    use 'josharian/impl'
    -- Awesome fuzzy finder
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'
    -- Outline viewer for vim
    use 'majutsushi/tagbar'
    -- Show git diff in the sign column
    use 'mhinz/vim-signify'
    -- Fancy start screen
    use 'goolord/alpha-nvim'
    -- Toggle quickfix and location windows
    use 'milkypostman/vim-togglelist'
    -- Jellybeans colorscheme
    use 'nanotech/jellybeans.vim'
    -- Config for built-in nvim lsp
    use 'neovim/nvim-lspconfig'

    -- auto completions
    use {
        'ms-jpq/coq_nvim',
        branch = 'coq'
    }
    -- coq snippets
    use {
        'ms-jpq/coq.artifacts',
        branch = 'artifacts'
    }
    -- lsp status helper
    use 'nvim-lua/lsp-status.nvim'

    -- use built-in syntax highlighting engine
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    -- ANSI escape sequences concealed, but highlighted as specified
    use 'powerman/vim-plugin-AnsiEsc'
    -- prettier formatting
    use {
        'prettier/vim-prettier',
        run = 'npm install',
        ft = {'json', 'markdown'}
    }
    -- Reveal the commit messages under the cursor in a 'popup window'
    use 'rhysd/git-messenger.vim'
    -- Make hlsearch more useful
    use 'romainl/vim-cool'
    -- Selectively illuminating other uses of the current word under the cursor
    use 'RRethy/vim-illuminate'
    -- Add various code snippets
    use 'SirVer/ultisnips'
    -- Comment stuff out
    use 'tpope/vim-commentary'
    -- Unix utility commands
    use 'tpope/vim-eunuch'
    -- Git wrapper
    use 'tpope/vim-fugitive'
    -- Make . work with tpope's plugins
    use 'tpope/vim-repeat'
    -- Open selected code in githb in browser
    use 'tpope/vim-rhubarb'
    -- Provides mappings to easily delete, change and add surroundings (parentheses, brackets, quotes, XML tags, and more) in pairs
    use 'tpope/vim-surround'
    -- Useful mappings
    use 'tpope/vim-unimpaired'
    -- Add snippets for Ginkgo BDD testing library for go
    use 'trayo/vim-ginkgo-snippets'
    use 'trayo/vim-gomega-snippets'
    -- Runs shfmt to auto format the current buffer
    use {
        'z0mbix/vim-shfmt',
        ft = {'sh'}
    }

    use ({
        'nvimdev/lspsaga.nvim',
        after = 'nvim-lspconfig',
        config = function()
           local ok, saga = pcall(require, "lspsaga")
           if ok then
              saga.setup({})
           end
        end,
    })

end)
