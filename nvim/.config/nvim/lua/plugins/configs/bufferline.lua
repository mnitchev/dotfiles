local present, bufferline = pcall(require, "bufferline")
if not present then
   return
end

local colors = require("base46").get_colors("base_30")

local options = {
   options = {
      offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
      buffer_close_icon = "",
      modified_icon = "",
      close_icon = "",
      show_close_icon = true,
      left_trunc_marker = "",
      right_trunc_marker = "",
      max_name_length = 14,
      max_prefix_length = 13,
      tab_size = 20,
      show_tab_indicators = true,
      enforce_regular_tabs = false,
      view = "multiwindow",
      show_buffer_close_icons = true,
      separator_style = "thin",
      always_show_bufferline = true,
      diagnostics = false,
      custom_filter = function(buf_number)
         -- Func to filter out our managed/persistent split terms
         local present_type, type = pcall(function()
            return vim.api.nvim_buf_get_var(buf_number, "term_type")
         end)

         if present_type then
            if type == "vert" then
               return false
            elseif type == "hori" then
               return false
            end
            return true
         end

         return true
      end,
   },

   highlights = {
      background = {
         fg = colors.grey_fg,
         bg = colors.black2,
      },

      -- buffers
      buffer_selected = {
         fg = colors.white,
         bg = colors.black,
         bold = true,
      },
      buffer_visible = {
         fg = colors.light_grey,
         bg = colors.black2,
      },

      -- for diagnostics = "nvim_lsp"
      error = {
         fg = colors.light_grey,
         bg = colors.black2,
      },
      error_diagnostic = {
         fg = colors.light_grey,
         bg = colors.black2,
      },

      -- close buttons
      close_button = {
         fg = colors.light_grey,
         bg = colors.black2,
      },
      close_button_visible = {
         fg = colors.light_grey,
         bg = colors.black2,
      },
      close_button_selected = {
         fg = colors.red,
         bg = colors.black,
      },
      fill = {
         fg = colors.grey_fg,
         bg = colors.black2,
      },
      indicator_selected = {
         fg = colors.black,
         bg = colors.black,
      },

      -- modified
      modified = {
         fg = colors.red,
         bg = colors.black2,
      },
      modified_visible = {
         fg = colors.red,
         bg = colors.black2,
      },
      modified_selected = {
         fg = colors.green,
         bg = colors.black,
      },

      -- separators
      separator = {
         fg = colors.black2,
         bg = colors.black2,
      },
      separator_visible = {
         fg = colors.black2,
         bg = colors.black2,
      },
      separator_selected = {
         fg = colors.black2,
         bg = colors.black2,
      },

      -- tabs
      tab = {
         fg = colors.light_grey,
         bg = colors.one_bg3,
      },
      tab_selected = {
         fg = colors.black2,
         bg = colors.nord_blue,
      },
      tab_close = {
         fg = colors.red,
         bg = colors.black,
      },
   },
}

bufferline.setup(options)
