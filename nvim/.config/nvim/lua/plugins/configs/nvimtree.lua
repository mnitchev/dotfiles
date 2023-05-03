local present, nvimtree = pcall(require, "nvim-tree")

if not present then
   return
end

local options = {
   filters = {
      dotfiles = false,
   },
   renderer = {
     higlight_git = 1,
     highlight_opened_files = 0,
     add_trailing = 0, -- append a trailing slash to folder names
     root_folder_modifier = table.concat { ":t:gs?$?/..", string.rep(" ", 1000), "?:gs?^??" },
     icons = {
       show = {
         folders = 1,
         files = 1,
         git = 1,
       },
       glyphs = {
         default = "",
         symlink = "",
         git = {
            deleted = "",
            ignored = "◌",
            renamed = "➜",
            staged = "✓",
            unmerged = "",
            unstaged = "✗",
            untracked = "★",
         },
         folder = {
            default = "",
            empty = "",
            empty_open = "",
            open = " ",
            symlink = "",
            symlink_open = "",
         },
       },
     },
   },
   disable_netrw = true,
   hijack_netrw = true,
   ignore_ft_on_setup = { "dashboard" },
   open_on_tab = false,
   hijack_cursor = true,
   hijack_unnamed_buffer_when_opening = false,
   update_cwd = true,
   update_focused_file = {
      enable = true,
      update_cwd = false,
   },
   view = {
      side = "left",
      width = 35,
      hide_root_folder = true,
   },
   git = {
      enable = false,
      ignore = false,
   },
   actions = {
      open_file = {
         resize_window = true,
      },
   },
   renderer = {
      indent_markers = {
         enable = true,
      },
   },
}

nvimtree.setup(options)
