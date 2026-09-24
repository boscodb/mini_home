return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          mason = false,
          cmd = { vim.fn.expand("~/.nix-profile/bin/marksman"), "server" },
        },

        nil_ls = {
          mason = false,
          cmd = { vim.fn.expand("~/.nix-profile/bin/nil") },
        },
      },
    },
  },
}
