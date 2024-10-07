local present, alpha = pcall(require, "alpha")

if not present then
   return
end

local colors = require("base46").get_colors("base_30")

vim.cmd[[highlight GiantSwarmOrange guifg=#ff6348]]
vim.cmd[[highlight ButtonGreen guifg=#89b482]]
vim.cmd[[highlight ButtonYellow guifg=#d6b676]]

local function button(sc, txt, keybind)
   local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")
   sc_ = sc:gsub("%s", ""):gsub("CTRL (.*)", "<C-%1>")

   local opts = {
      position = "center",
      text = txt,
      shortcut = sc,
      cursor = 5,
      width = 36,
      align_shortcut = "right",
      hl = "ButtonGreen",
      hl_shortcut = "ButtonYellow"
   }

   if keybind then
      opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
   end

   return {
      type = "button",
      val = txt,
      on_press = function()
         local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
         vim.api.nvim_feedkeys(key, "normal", false)
      end,
      opts = opts,
   }
end

local function footer()
  local datetime = os.date " %A %B %d %Y"
  return datetime
end

local options = {}

local ascii = {
"            ⣠⣶⣦⡀                  ⢠⣶⣷⣆",
"          ⢠⣾⣿⣿⣿⣿⣄                ⣴⣿⣿⣿⣿⣷⣄",
"        ⢀⣴⣿⣿⣿⣿⣿⣿⣿⣧⡀            ⢀⣾⣿⣿⣿⣿⣿⣿⣿⣦⡀",
"       ⣠⣾⣿⣿⡿⠻⣿⣿⣿⣿⣿⣷⣄⣤⣴⣶⣶⣿⣿⣶⣶⣦⣄⣰⣿⣿⣿⣿⣿⣿⠛⠿⣿⣿⣿⣄",
"     ⢀⣼⣿⣿⠟⠉  ⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏  ⠈⠻⣿⣿⣷⡀",
"    ⣴⣿⣿⠟⠁   ⣀⣨⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣤⣀⡀  ⠈⠛⢿⣿⣦",
"  ⣠⣾⡿⠋   ⣠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⡀  ⠙⢿⣷⣄",
" ⢴⠿⠋   ⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀  ⠈⠻⠆",
"     ⢀⣾⣿⣿⠟⠉⠁ ⠈⠉⠙⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠉⠁ ⠈⠉⠻⢿⣿⣷⡄",
"     ⣾⣿⡿⠁         ⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋         ⠈⢻⣿⣿⡀",
"    ⢰⣿⣿⡇    ⣄⡀      ⠻⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁           ⠈⣿⣿⡇",
"    ⢸⣿⣿⡇    ⠿⢿⣷⣶⣤⣀   ⢹⣿⣿⣿⣿⣿⣿⡟              ⣿⣿⡇",
"    ⢸⣿⣿⣧     ⣀⣬⣽⣿⣿    ⣿⣿⣿⣿⣿⣿⠁  ⢸⣿⣿⣿⣿⣿⣿⣿   ⢰⣿⣿⡇",
"     ⢿⣿⣿⣆   ⣿⠿⠟⠋⠉     ⣿⣿⣿⣿⣿⣿             ⢠⣿⣿⡿",
"     ⠈⢿⣿⣿⣧⡀          ⢠⣿⣿⣿⣿⣿⣿⡆           ⣰⣿⣿⡿⠁",
"       ⠙⢿⣿⣿⣦⣄⡀     ⢀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀      ⢀⣤⣾⣿⣿⠏",
"         ⠙⠻⣿⣿⣿⣷⣶⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣤⣶⣶⣿⣿⣿⠿⠋",
"            ⠈⠉⠛⠛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠛⠛⠉⠉",
"                ⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁",
"                 ⠙⢿⣿⣿⣟⠛⠿⠿⠿⠟⢻⣿⣿⡿⠟⠁",
"                   ⠈⠛⠻⠆   ⠠⠿⠛⠉",
}

options.header = {
   type = "text",
   val = ascii,
   opts = {
      position = "center",
      hl = "GiantSwarmOrange",
   },
}

options.buttons = {
   type = "group",
   val = {
      button("e", "  New file", "<cmd>ene <CR>"),
      button("CTRL p", "  Find File  ", ":Telescope find_files find_command=rg,--ignore,--hidden,--files prompt_prefix=🔍<cr>"),
      button("SPC f h", "  Recent File  ", ":Telescope oldfiles<CR>"),
      button("SPC f s", "  Search Word  ", ":Telescope live_grep<CR>"),
      button("SPC f b", "  Bookmarks  ", ":Telescope marks<CR>"),
      button("SPC v e", "  Settings", ":e $MYVIMRC | :cd %:p:h <CR>"),
      button( "q", "󰩈  > Quit NVIM", ":qa<CR>"),
   },
   opts = {
      spacing = 1,
   },
}

options.footer = {
    type = "text",
    val = footer(),
    opts = {
       position = "center",
    },
}

options.fortune = {
  type = "text",
  val = require "alpha.fortune"(),
  opts = {
    position = "center",
    hl = "AlphaQuote",
  },
}

options = require("core.utils").load_override(options, "goolord/alpha-nvim")

alpha.setup {
   layout = {
      { type = "padding", val = 2 },
      options.header,
      { type = "padding", val = 2 },
      options.buttons,
      { type = "padding", val = 1 },
      options.footer,
      { type = "padding", val = 1 },
      options.fortune,
   },
   opts = {},
}
