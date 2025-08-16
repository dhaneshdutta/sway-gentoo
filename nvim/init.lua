require("config.plugins")

require("config.options")
require("config.keymaps")
require("config.colors")
require("config.lualine")

require("nvim-tree").setup({})

-- LSP and completion configs are loaded via lazy plugin configs
