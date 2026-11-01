return {
  "elixir-tools/elixir-tools.nvim",
  version = "*",
  event = { "BufReadPre", "BufNewFile" },
  init = function()
    if vim.fn.exists(":LspRestart") == 0 then
      vim.api.nvim_create_user_command("LspRestart", function(info)
        local cmd = "lsp restart"
        if info.args and info.args ~= "" then
          cmd = cmd .. " " .. info.args
        end
        local ok = pcall(vim.cmd, cmd)
        if not ok then
          for _, client in ipairs(vim.lsp.get_clients()) do
            pcall(vim.cmd, "lsp restart " .. client.name)
          end
        end
      end, {
        desc = "Compatibility alias for :lsp restart",
        nargs = "?",
        bang = true,
      })
    end
  end,
  config = function()
    local elixir = require("elixir")
    local elixirls = require("elixir.elixirls")

    elixir.setup({
      nextls = { enable = false },
      elixirls = {
        enable = true,
        settings = elixirls.settings({
          dialyzerEnabled = false,
          enableTestLenses = false,
        }),
        on_attach = function(client, bufnr)
          vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
          vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
          vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
        end,
      },
      projectionist = {
        enable = true,
      },
    })
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}
