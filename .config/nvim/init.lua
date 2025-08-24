require("config.keymaps")
require("config.settings")
require("config.autocommands")
require("config.lazy")
require("config.auto-lsp-install").setup()

-- mise integration for tool version management
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH
