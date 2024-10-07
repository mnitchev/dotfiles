require('plugins.plugins')
base46 = require('base46')
base46.load_theme()

require('config.vimscript')
require('config.mappings')
require('config.vimopts')

-- require('lspsaga').init_lsp_saga()
require('config.lsp')
require('config.lspstatus')

require('plugins.configs.treesitter')
require('plugins.configs.feline')
require('plugins.configs.nvimtree')
require('plugins.configs.bufferline')
require('plugins.configs.icons')
require('plugins.configs.telescope')
require('plugins.configs.alpha')
