function go_alternate_switch (bang, cmd)
  -- Get the name of the current file
  local file = vim.fn.expand('%')
  if file == '' then
    print("no buffer name")
    return
  end

  local alt_file

  -- Match and replace patterns to find the alternate file
  if string.match(file, '_test%.go$') then
    local root = string.gsub(file, '_test%.go$', '')
    alt_file = root .. '.go'
  elseif string.match(file, '%.go$') then
    local root = string.gsub(file, '%.go$', '')
    alt_file = root .. '_test.go'
  elseif string.match(file, '%.test%.ts$') then
    local root = string.gsub(file, '%.test%.ts$', '')
    alt_file = root .. '.ts'
  elseif string.match(file, '%.ts$') then
    local root = string.gsub(file, '%.ts$', '')
    alt_file = root .. '.test.ts'
  elseif string.match(file, '%.test%.tsx$') then
    local root = string.gsub(file, '%.test%.tsx$', '')
    alt_file = root .. '.tsx'
  elseif string.match(file, '%.tsx$') then
    local root = string.gsub(file, '%.tsx$', '')
    alt_file = root .. '.test.tsx'
  else
    print("not a go/typescript file")
    return
  end

  -- Check if the alternate file exists unless user typed :A!
  if vim.fn.filereadable(alt_file) == 0 and vim.fn.bufexists(alt_file) == 0 and not bang then
    print("couldn't find " .. alt_file)
    return
  end

  -- Open the alternate file in the given command or just :edit
  if cmd == '' then
    vim.cmd('edit ' .. alt_file)
  else
    vim.cmd(cmd .. ' ' .. alt_file)
  end
end

vim.filetype.add({
  extension = {
    gotmpl = 'gotmpl',
  },
  pattern = {
    [".*/templates/.*%.tpl"] = "helm",
    [".*/templates/.*%.ya?ml"] = "helm",
    ["helmfile.*%.ya?ml"] = "helm",
  },
})

-- Create an actual user command that calls our function
vim.api.nvim_create_user_command(
  'A',
  function(opts)
    go_alternate_switch(opts.bang, '')  -- Here cmd is empty, same as your Vimscript command
  end,
  { bang = true }  -- Allows :A!
)
-- save on enter
vim.api.nvim_set_keymap(
  "n",
  "<cr>",
  "empty(&buftype) ? ':w<cr>' : '<cr>'",
  {
   noremap = true,
   silent = true,
   expr = true
  }
)

vim.keymap.set("v", "<leader>cp", '"+y', { noremap = true, silent = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format({ timeout_ms = 3000 })
    LSP_organize_imports()
  end,
})

function LSP_organize_imports()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, "utf-16")
            else
                vim.lsp.buf.execute_command(r.command)
            end
        end
    end
end

return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = function(_, opts)
      opts.options = {
        opt = {
          wrap = true,
          number = true, -- sets `vim.opt.number`
          relativenumber = false, -- sets `vim.opt.relativenumber`
          signcolumn = "auto", -- sets `vim.opt.signcolumn`
          clipboard = "", -- disable clipboard sync (use <Leader>cp to explicitly copy)
          showtabline = 2, -- always show tabline/bufferline
          tabstop = 2, -- number of spaces a tab counts for
          shiftwidth = 2, -- number of spaces for indentation
          expandtab = true, -- use spaces instead of tabs
          list = true, -- show whitespace characters
          listchars = { tab = "→ ", trail = "·", nbsp = "␣", extends = "⟩", precedes = "⟨" },
        },
      }

      local maps = opts.mappings or {}
      opts.mappings = maps
      maps.n = maps.n or {}
      maps.v = maps.v or {}

      -- second key is the lefthand side of the map
      -- mappings seen under group name "Buffer"
      maps.n["<Leader>fn"] = { function() require("astrocore.buffer").nav(1) end, desc = "Next buffer"}
      maps.n["<Leader>fp"] = { function() require("astrocore.buffer").nav(-1) end, desc = "Previous buffer"}
      maps.n["<Leader>fo"] = { function() require("telescope.builtin").buffers() end, desc = "Find buffers"}
      maps.n["<Leader>fa"] = { "<Cmd>A<CR>", desc = "Open alternative file" }
      maps.n["<Leader>fd"] = { ":bp|bd#<cr>", desc = "Close current buffer" }
      maps.n["gr"] = { function() vim.lsp.buf.references() end, desc = "Search references" }
      maps.n["gi"] = { function() vim.lsp.buf.implementation() end, desc = "Search implementation" }
      maps.n["gt"] = { function() vim.lsp.buf.type_definition() end, desc = "Search implementation" }
      maps.n["<Leader>rn"] = { function() vim.lsp.buf.rename() end, desc = "Rename current symbol" }
      maps.n["<Leader>en"] = { function() vim.diagnostic.goto_next() end, desc = "Next diagnostic symbol" }
      maps.n["<Leader>ep"] = { function() vim.diagnostic.goto_prev() end, desc = "Prev diagnostic symbol" }
      maps.n["<Leader>gh"] = { "<Cmd>GBrowse<CR>", desc = "Open file in git" }
      maps.n["<Leader>fh"] = { function() require("telescope.builtin").oldfiles() end, desc = "Find buffers"}
      maps.n["<C-p>"] = { function() require("telescope.builtin").find_files() end, desc = "Find files"}
      maps.n["<C-_>"] = { "gcc", remap = true, desc = "Toggle comment line" }
      maps.n["\\"] = { "<Cmd>Neotree toggle<CR>", desc = "Toggle Explorer" }

      -- GitHub Issues and PRs keybindings
      maps.n["<Leader>ghi"] = { function() require("snacks").picker.gh_issue() end, desc = "GitHub Issues (open)" }
      maps.n["<Leader>ghI"] = { function() require("snacks").picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" }
      maps.n["<Leader>ghp"] = { function() require("snacks").picker.gh_pr() end, desc = "GitHub Pull Requests (open)" }
      maps.n["<Leader>ghP"] = { function() require("snacks").picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" }
      maps.n["<Leader>ghd"] = { function() require("snacks").picker.gh_pr({ state = "all", draft = true }) end, desc = "GitHub Pull Requests (including drafts)" }

      -- Delete operations use unnamed register (paste with p, but not in system clipboard)
      -- System clipboard copy is available via <Leader>cp in visual mode
      maps.v["<Leader>gh"] = { "<Cmd>GBrowse<CR>", desc = "Open file in git" }
      maps.v[">"] = { ">gv" }
      maps.v["<C-_>"] = { "gcgv", remap = true, desc = "Toggle comment line" }
      maps.v["<"] = { "<gv" }

      return opts
    end
  },
  {
    "AstroNvim/astrocommunity",
    { import = "astrocommunity.colorscheme.nordic-nvim" },
  },
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      colorscheme = "nordic",
    },
  },
  { -- further customize the options set by the community
    "nordic.nvim",
    opts = {
      on_palette = function(palette)
        palette.black1 = "#1e2122"
      end,
      telescope = {
        style = 'flat',
      },
      bright_border = false,
    -- Reduce the overall amount of blue in the theme (diverges from base Nord).
      reduced_blue = true,
      swap_backgrounds = true,
      cursorline = {
        -- Bold cursorline number.
        bold_number = true,
        -- Available styles: 'dark', 'light'.
        theme = 'light',
        -- Blending the cursorline bg with the buffer bg.
        blend = 0.75,
    },
    },
  },
  {
    "tpope/vim-unimpaired",
    name = "vim-unimpaired",
    opt = true,
  },
  {
    "ntpeters/vim-better-whitespace",
    name = "vim-better-whitespace",
    opt = true,
    event = "BufRead",
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
        },
      },
    },
  },
  {
    "ray-x/lsp_signature.nvim",
    name = "lsp_signature.nvim",
    event = "InsertEnter",
    opt = true,
  },
  {
    "tpope/vim-fugitive",
    name = "vim-fugitive",
    opt = true,
    cmd = {
      "G", "Git", "Gdiffsplit", "Gvdiffsplit", "Gedit", "Gsplit",
      "Gread", "Gwrite", "Ggrep", "Glgrep", "Gmove",
      "Gdelete", "Gremove", "Gbrowse",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    name = "nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ignore_install = {"ipkg"},
          ensure_installed = "all",
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },
        })
    end
  },
  {
    "nvim-telescope/telescope.nvim",
    name = "telescope.nvim",
    config = function ()
      local present, telescope = pcall(require, "telescope")
      local actions = require "telescope.actions"
      local options = {
        pickers = {
          find_files = {
            file_ignore_patterns = { 'node_modules', '.git/', '.venv' },
            hidden = true,
          },
          buffers = {
            mappings = {
              i = {
                ["<c-d>"] = actions.delete_buffer,
              }
            }
          }
        },
        defaults = {
            prompt_prefix = "  ",
            selection_caret = "  ",
            entry_prefix = "  ",
            initial_mode = "insert",
            selection_strategy = "reset",
            sorting_strategy = "ascending",
            layout_strategy = "horizontal",
            layout_config = {
              horizontal = {
                  prompt_position = "top",
                  preview_width = 0.55,
                  results_width = 0.8,
              },
              vertical = {
                  mirror = false,
              },
              width = 0.87,
              height = 0.80,
              preview_cutoff = 120,
            },
            file_sorter = require("telescope.sorters").get_fuzzy_file,
            file_ignore_patterns = { "node_modules", "%.git" },
            generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
            path_display = { "truncate" },
            winblend = 0,
            border = {},
            borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            color_devicons = true,
            use_less = true,
            set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
            file_previewer = require("telescope.previewers").vim_buffer_cat.new,
            grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
            qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
            -- Developer configurations: Not meant for general override
            buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
        },
      }
      telescope.setup(options)
    end
  },
  {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
    opts = {
      config = {
        lua_ls = {
          settings = {
            Lua = {
              hint = { enable = true, arrayIndex = "Disable" },
            },
          },
        },
        clangd = {
          capabilities = {
            offsetEncoding = "utf-8",
          },
        },
        gopls = {
          completeUnimported = true,
          usePlaceholders = true,
          staticcheck = true,
          gofumpt = true,
          ['local'] = module,
          buildFlags = {"-tags=e2e"},
          on_attach = function(client, bufnr)
            require "lsp_signature".on_attach(signature_setup, bufnr)  -- Note: add in lsp client on-attach
          end,
        },

      },
      formatting = {
        -- control auto formatting on save
        format_on_save = {
          -- enable or disable format on save globally
          enabled = true,
          -- enable format on save for specified filetypes only
          allow_filetypes = {
            "go",
          },
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.gh = { enabled = true }  -- Enable GitHub integration
      opts.picker = opts.picker or {}
      opts.picker.sources = opts.picker.sources or {}
      opts.picker.sources.gh_issue = {}
      opts.picker.sources.gh_pr = {}
      -- Keep indent guides enabled but ensure listchars work too
      opts.indent = opts.indent or {}
      opts.indent.enabled = true
      return opts
    end,
  },
}

-- -- open in github
-- vim.api.nvim_set_keymap(
--   "n",
--   "<leader>gh",
--   ":GBrowse<cr>",
--   { silent = true }
-- )
-- vim.api.nvim_set_keymap(
--   "v",
--   "<leader>gh",
--   ":GBrowse<cr>",
--   { silent = true }
-- )
--

