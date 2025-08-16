-- Alacritty-matched matte theme for Neovim

local bg      = "#121212"
local fg      = "#c0c0c0"
local panel   = "#1a1a1a"
local sel_bg  = "#333333"

local normal  = {
  black   = "#121212",
  red     = "#883838",
  green   = "#4c7042",
  yellow  = "#bba04b",
  blue    = "#4f638e",
  magenta = "#775980",
  cyan    = "#4c7a85",
  white   = "#a0a0a0",
}

local bright = {
  black   = "#2a2a2a",
  red     = "#aa4c4c",
  green   = "#6c8f5b",
  yellow  = "#d7b75a",
  blue    = "#5f7aa5",
  magenta = "#8f6b94",
  cyan    = "#619ca8",
  white   = "#d0d0d0",
}

vim.cmd("highlight clear")
vim.cmd("syntax reset")
vim.opt.background = "dark"
vim.g.colors_name = "matteblack"

-- Base UI
vim.cmd("highlight Normal guibg=" .. bg .. " guifg=" .. fg)
vim.cmd("highlight CursorLineNr guifg=" .. bright.yellow)
vim.cmd("highlight LineNr guifg=" .. bright.black)
vim.cmd("highlight Visual guibg=" .. sel_bg)
vim.cmd("highlight VertSplit guifg=" .. normal.black .. " guibg=" .. bg)
vim.cmd("highlight WinSeparator guifg=" .. normal.black)

-- UI Panels
vim.cmd("highlight StatusLine guifg=" .. bright.white .. " guibg=" .. panel)
vim.cmd("highlight StatusLineNC guifg=" .. bright.black .. " guibg=" .. panel)
vim.cmd("highlight Pmenu guibg=" .. panel .. " guifg=" .. fg)
vim.cmd("highlight PmenuSel guibg=" .. bright.black .. " guifg=" .. bright.white)
vim.cmd("highlight Search guibg=" .. bright.yellow .. " guifg=" .. bg)

-- Syntax
vim.cmd("highlight Comment guifg=" .. bright.black .. " gui=italic")
vim.cmd("highlight Identifier guifg=" .. bright.cyan)
vim.cmd("highlight Function guifg=" .. bright.blue)
vim.cmd("highlight Statement guifg=" .. bright.red)
vim.cmd("highlight Type guifg=" .. bright.green)
vim.cmd("highlight Keyword guifg=" .. normal.magenta)
vim.cmd("highlight Constant guifg=" .. bright.yellow)
vim.cmd("highlight String guifg=" .. bright.green)
vim.cmd("highlight Number guifg=" .. bright.yellow)
vim.cmd("highlight Special guifg=" .. bright.magenta)
vim.cmd("highlight Todo guifg=" .. bright.white .. " guibg=" .. bright.red)

-- Git signs (if used)
vim.cmd("highlight GitSignsAdd guifg=" .. normal.green)
vim.cmd("highlight GitSignsChange guifg=" .. normal.yellow)
vim.cmd("highlight GitSignsDelete guifg=" .. normal.red)
