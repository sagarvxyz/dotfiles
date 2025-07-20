require("config.settings")
require("config.keymaps")
if not vim.g.vscode then
	require("config.lazy")
end
