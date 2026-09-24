-- bootstrap lazy.nvim, LazyVim and your plugins

-- Neovim's own python3 (pynvim), needed by jupyter-vim. Without it, has('python3') is 0,
-- jupyter-vim's plugin/ file bails, and its python ftplugin then errors (E121) on every
-- python file.
--
-- The nixpkgs `neovim` wrapper starts nvim with
--   --cmd "lua ... vim.g.loaded_python3_provider=0"
-- so the provider must be re-enabled here before setting the interpreter.
vim.g.loaded_python3_provider = nil

-- Env built by mini_home's flake.nix and symlinked to this path. Deliberately not on
-- PATH, so it can never shadow a project's uv/.venv python.
-- AND THIS IS MOST IMPORTANT THING TO REMEMBER about nix, uv, python and neovim; and it's thanks to Claude.
vim.g.python3_host_prog = vim.fn.expand("~/.local/share/nvim/nvim-python3/bin/python3")

require("config.lazy")
