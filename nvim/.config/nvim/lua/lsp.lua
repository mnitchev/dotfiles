local nvim_lsp = require 'lspconfig'

-- disable inline diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
		underline = true,
		signs = true,
    }
)

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'K', ':Lspsaga hover_doc<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', 'gs', ':Lspsaga signature_help<CR>', opts)
    buf_set_keymap('n', 'gh', ':Lspsaga lsp_finder<CR>', opts)

    buf_set_keymap('n', '<leader>ca', ':Lspsaga code_action<CR>', opts)
    buf_set_keymap('v', '<leader>ca', ':<C-U>Lspsaga range_code_action<CR>', opts)

    buf_set_keymap('n', '<leader>rn', ':Lspsaga rename<CR>', opts)

    buf_set_keymap('n', '<leader>ee', ':Lspsaga show_line_diagnostics<CR>', opts)
    buf_set_keymap('n', '[g', ':Lspsaga diagnostic_jump_prev<CR>', opts)
    buf_set_keymap('n', '<leader>ep', ':Lspsaga diagnostic_jump_prev<CR>', opts)
    buf_set_keymap('n', ']g', ':Lspsaga diagnostic_jump_next<CR>', opts)
    buf_set_keymap('n', '<leader>en', ':Lspsaga diagnostic_jump_next<CR>', opts)
    buf_set_keymap('n', '<leader>eb', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<leader>ea', '<cmd>lua vim.lsp.diagnostic.set_loclist({workspace = true})<CR>', opts)
end

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local servers = { "tsserver", "bashls" }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup { on_attach = on_attach }
end

nvim_lsp.gopls.setup{
    on_attach = on_attach;
    cmd = { 'gopls', '--remote=auto' };
    settings = {
        gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            staticcheck = true,
            gofumpt = true,
            buildFlags = {"-tags=e2e"},
        }
    };
}

