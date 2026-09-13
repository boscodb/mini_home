-- bootstrap lazy.nvim, LazyVim and your plugins
vim.g.loaded_python3_provider = nil -- needed to override the provider disabling done by 'nix neovim' wrapper.

vim.g.python3_host_prog = vim.fn.expand("~/.local/share/nvim/python_venv_for_nvim/.venv/bin/python")

require("config.lazy")
