-- mise-en-place: https://mise.jdx.dev/ide-integration.html#neovim
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

require("config.settings")
require("config.keymaps")
require("config.autocommands")
require("config.lazy")
