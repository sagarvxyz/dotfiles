return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Function key bindings (traditional)
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
      vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
      vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
      vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })

      -- Leader key alternatives for better discoverability
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "[D]ebug [C]ontinue" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "[D]ebug step [I]nto" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "[D]ebug step [O]ver" })
      vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "[D]ebug step [O]ut" })
      vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "[D]ebug [T]erminate" })
      vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "[D]ebug [R]estart" })

      -- Breakpoint management
      vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>B", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Debug: Set Breakpoint" })
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "[D]ebug [B]reakpoint toggle" })
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "[D]ebug conditional [B]reakpoint" })
      vim.keymap.set("n", "<leader>dC", dap.clear_breakpoints, { desc = "[D]ebug [C]lear breakpoints" })

      -- UI controls
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "[D]ebug [U]I toggle" })
      vim.keymap.set("n", "<leader>de", dapui.eval, { desc = "[D]ebug [E]val expression" })
      vim.keymap.set("n", "<leader>dR", dap.run_to_cursor, { desc = "[D]ebug [R]un to cursor" })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("mason-nvim-dap").setup({
        automatic_installation = true,
        handlers = {},
        ensure_installed = {
          "delve",
        },
      })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dapui = require("dapui")
      dapui.setup()
    end,
  },
}