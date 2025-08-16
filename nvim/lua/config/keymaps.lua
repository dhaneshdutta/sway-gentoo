vim.g.mapleader = " "
local keymap = vim.keymap.set

-- Toggle file tree with Ctrl-n
keymap("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
