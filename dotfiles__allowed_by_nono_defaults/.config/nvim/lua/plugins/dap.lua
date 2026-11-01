return {
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")

      -- ElixirLS does not support setExceptionBreakpoints; bypass it cleanly so Noice shows no error
      local session = require("dap.session")
      local orig_set_eb = session.set_exception_breakpoints
      session.set_exception_breakpoints = function(self, filters, exceptionOptions, on_done)
        if self.config and self.config.type == "elixir" then
          if on_done then
            on_done()
          end
          return
        end
        return orig_set_eb(self, filters, exceptionOptions, on_done)
      end

      local debugger_path = vim.fn.expand("~/.local/share/nvim/mason/bin/elixir-ls-debugger")

      dap.adapters.elixir = {
        type = "executable",
        command = debugger_path,
        args = {},
      }

      local elixir_config = {
        {
          type = "elixir",
          name = "Phoenix Server (Debug)",
          task = "phx.server",
          taskArgs = { "--no-halt" },
          request = "launch",
          projectDir = vim.fn.getcwd(),
          exitAfterTaskReturns = false,
          debugImports = false,
          startApps = true,
        },
        {
          type = "elixir",
          name = "Mix Test (Debug)",
          task = "test",
          taskArgs = { "--trace" },
          request = "launch",
          projectDir = vim.fn.getcwd(),
          requireFiles = {
            "test/**/test_helper.exs",
            "test/**/*_test.exs",
          },
        },
      }

      dap.configurations.elixir = elixir_config
      -- Allow continue to work even when cursor is inside any DAP UI or picker panel
      dap.configurations.dapui_console = elixir_config
      dap.configurations["dap-repl"] = elixir_config
      dap.configurations.dapui_scopes = elixir_config
      dap.configurations.dapui_watches = elixir_config
      dap.configurations.dapui_stacks = elixir_config
      dap.configurations.snacks_picker_list = elixir_config
      dap.configurations.snacks_picker_input = elixir_config
      dap.configurations.snacks_input = elixir_config
    end,
    keys = {
      {
        "<F9>",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint (F9)",
      },
      {
        "<F5>",
        function()
          local dap = require("dap")
          if dap.session() then
            dap.continue()
          else
            local configs = dap.configurations.elixir or {}
            if #configs > 0 then
              dap.run(configs[1])
            else
              dap.continue()
            end
          end
        end,
        desc = "Continue / Start Debug (F5)",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over (F10)",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into (F11)",
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out (F12)",
      },
    },
  },
}
