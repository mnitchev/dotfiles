local lsp_status = require 'lsp-status'

lsp_status.config{
    status_symbol = '',
    current_function = false,
    indicator_errors = '❌',
    indicator_warnings = '⚠',
    indicator_info = 'ℹ',
    indicator_hint = '💡',
    indicator_ok = '✔️',
}
lsp_status.register_progress()
