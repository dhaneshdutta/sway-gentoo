require("lualine").setup({
  options = {
    theme = "auto",
    section_separators = "",
    component_separators = "",
    globalstatus = true,
    icons_enabled = true,
  },
  sections = {
    lualine_a = {
      {
        function()
          return ""
        end,
        icon = nil, -- no prepended icon
        color = { fg = "#b8b8b8", bg = "#111111" },
        separator = "",
      }
    },
    lualine_b = { "branch" },
    lualine_c = { "filename" },
    lualine_x = { "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})
