-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree toggle<CR>', desc = 'Neo-tree toggle', silent = true },
  },
  init = function()
    -- Open neo-tree when starting with directory
    if vim.fn.argc() == 1 then
      local stat = vim.loop.fs_stat(vim.fn.argv(0))
      if stat and stat.type == 'directory' then
        require('neo-tree.command').execute({ action = 'show' })
      end
    end
  end,
  opts = {
    default_component_configs = {
      icon = {
        -- Use ASCII characters for non-nerd font compatibility
        folder_closed = '+',
        folder_open = '-',
        folder_empty = 'o',
        default = '*',
        highlight = 'NeoTreeFileIcon',
      },
      git_status = {
        symbols = {
          -- Change from nerd font symbols to ASCII
          added     = '+',
          deleted   = '-',
          modified  = '*',
          renamed   = 'r',
          untracked = '?',
          ignored   = 'i',
          unstaged  = 'u',
          staged    = 's',
          conflict  = 'x',
        }
      },
    },
    filesystem = {
      filtered_items = {
        visible = true, -- Show hidden files by default
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      window = {
        mappings = {},
      },
    },
  },
}
