-- bootstrap lazy.nvim, LazyVim and your plugins
vim.g.python3_host_prog = vim.fn.expand("~/.local/share/nvim/python_venv_for_nvim/.venv/bin/python")

require("config.lazy")

-- vim.g.neomux_enable_tmux = 1
