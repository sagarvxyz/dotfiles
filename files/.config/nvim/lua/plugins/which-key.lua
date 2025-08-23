return {
  "folke/which-key.nvim",
  event = "VimEnter",
  opts = {
    delay = 0,
    icons = {
      -- set icon mappings to true if you have a Nerd Font
      mappings = vim.g.have_nerd_font,
      -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
      -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
      keys = vim.g.have_nerd_font and {} or {
        Up = "<Up> ",
        Down = "<Down> ",
        Left = "<Left> ",
        Right = "<Right> ",
        C = "<C-…> ",
        M = "<M-…> ",
        D = "<D-…> ",
        S = "<S-…> ",
        CR = "<CR> ",
        Esc = "<Esc> ",
        ScrollWheelDown = "<ScrollWheelDown> ",
        ScrollWheelUp = "<ScrollWheelUp> ",
        NL = "<NL> ",
        BS = "<BS> ",
        Space = "<Space> ",
        Tab = "<Tab> ",
        F1 = "<F1>",
        F2 = "<F2>",
        F3 = "<F3>",
        F4 = "<F4>",
        F5 = "<F5>",
        F6 = "<F6>",
        F7 = "<F7>",
        F8 = "<F8>",
        F9 = "<F9>",
        F10 = "<F10>",
        F11 = "<F11>",
        F12 = "<F12>",
      },
    },
    spec = {
      -- Essential groups only
      { "<leader>s", group = "[S]earch" },
      { "<leader>c", group = "[C]ode" },
      { "gr",        group = "LSP Actions" },

      -- Core navigation
      { "]d",        desc = "Next diagnostic" },
      { "[d",        desc = "Previous diagnostic" },
      { "]c",        desc = "Next git change" },
      { "[c",        desc = "Previous git change" },

      -- Essential actions
      { "<leader>e", desc = "File explorer" },
      { "K",         desc = "Hover documentation" },
      { "gd",        desc = "Go to definition" },
      { "gr",        desc = "References" },

      -- Window navigation
      { "<C-h>",     desc = "Move to left window" },
      { "<C-l>",     desc = "Move to right window" },
      { "<C-j>",     desc = "Move to lower window" },
      { "<C-k>",     desc = "Move to upper window" },

      -- Clear search
      { "<Esc>",     desc = "Clear search highlights", mode = "n" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
