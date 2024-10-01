vim.api.nvim_set_keymap(
  "i",
  "<C-u>",
  '<esc>mzgUiw`za',
  { noremap = true }
)

-- Copilot
vim.api.nvim_set_keymap(
  "i",
  "<C-Right>",
  'copilot#Accept()',
  {
      noremap = true,
      expr = true
  }
)

vim.api.nvim_set_keymap(
  "i",
  "<C-Down>",
  'copilot#Next()',
  {
      noremap = true,
      expr = true
  }
)

vim.api.nvim_set_keymap(
  "i",
  "<C-Up>",
  'copilot#Previous()',
  {
      noremap = true,
      expr = true
  }
)

vim.api.nvim_set_keymap(
  "i",
  "<C-Left>",
  'copilot#Dismiss()',
  {
      noremap = true,
      expr = true
  }
)

vim.api.nvim_set_keymap(
  "i",
  "<C-\\>",
  'copilot#Suggest()',
  {
      noremap = true,
      expr = true
  }
)

-- vimrc key mappings
vim.api.nvim_set_keymap(
  "n",
  "<leader>ve",
  ":edit ~/.config/nvim/init.lua<CR>",
  { silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>vs",
  ":source ~/.config/nvim/init.lua<CR>",
  { silent = true }
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

--Move vertically (down) by visual line
vim.api.nvim_set_keymap(
  "n",
  "j",
  "gj",
  { noremap = true }
)
--Move vertically (up) by visual line
vim.api.nvim_set_keymap(
  "n",
  "k",
  "gk",
  { noremap = true }
)

-- Movement in popup menu
vim.api.nvim_set_keymap(
  "i",
  "<C-j>",
  'pumvisible() ? "<C-N>" : "<C-j>"',
  {
    noremap = true,
    expr = true
  }
)
vim.api.nvim_set_keymap(
  "i",
  "<C-j>",
  'pumvisible() ? <C-p> : <C-k>',
  {
    noremap = true,
    expr = true
  }
)

vim.api.nvim_set_keymap(
  "v",
  ">",
  ">gv",
  { noremap = true }
)
vim.api.nvim_set_keymap(
  "v",
  "<",
  "<gv",
  { noremap = true }
)

-- Toggle comment with ctrl + /
vim.api.nvim_set_keymap(
  "n",
  "<C-_>",
  "gc$",
  {}
)
vim.api.nvim_set_keymap(
  "v",
  "<C-_>",
  "gc",
  {}
)

vim.api.nvim_set_keymap(
  "n",
  "<c-p>",
  ":Telescope find_files find_command=rg,--ignore,--hidden,--files prompt_prefix=🔍<cr>",
  {
    noremap = true,
    silent = true
  }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>ff",
  ":Telescope find_files find_command=rg,--ignore,--hidden,--files prompt_prefix=🔍<cr>",
  {
    noremap = true,
    silent = true
  }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>fo",
  ":Telescope buffers<cr>",
  {
    noremap = true,
    silent = true
  }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>fs",
  ":Telescope live_grep<cr>",
  {
    noremap = true,
    silent = true
  }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>fh",
  ":Telescope oldfiles<cr>",
  {
    noremap = true,
    silent = true
  }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>fd",
  ":bp|bd#<cr>",
  {
    noremap = true,
    silent = true
  }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>fn",
  ":BufferLineCycleNext<cr>",
  {
    noremap = true,
    silent = true
  }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>fp",
  ":BufferLineCyclePrev<cr>",
  {
    noremap = true,
    silent = true
  }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>fa",
  ":A<cr>",
  {
    noremap = true,
    silent = true
  }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>m",
  "`",
  {
    noremap = true,
    silent = true
  }
)

vim.api.nvim_set_keymap(
  "n",
  "<F8>",
  ":TagbarToggle<CR>",
  {}
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>tt",
  ":TestNearest<cr>",
  {
    noremap = true,
    silent = true
  }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>t.",
  ":TestLast<cr>",
  {
    noremap = true,
    silent = true
  }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>tf",
  ":TestFile<cr>",
  {
    noremap = true,
    silent = true
  }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>ts",
  ":TestSuite<cr>",
  {
    noremap = true,
    silent = true
  }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>tg",
  ":TestVisit<cr>",
  {
    noremap = true,
    silent = true
  }
)

-- open in github
vim.api.nvim_set_keymap(
  "n",
  "<leader>gh",
  ":GBrowse<cr>",
  { silent = true }
)
vim.api.nvim_set_keymap(
  "v",
  "<leader>gh",
  ":GBrowse<cr>",
  { silent = true }
)

-- NvimTree
vim.api.nvim_set_keymap(
  "n",
  "\\",
  ":NvimTreeToggle<CR>",
  {
      noremap = true,
      silent = true
  }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>n",
  ":NvimTreeFindFile<CR>",
  { noremap = true }
)
