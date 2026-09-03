return {
  "julienvincent/hunk.nvim",
  cmd = { "DiffEditor" },
  dependencies = { "MunifTanjim/nui.nvim" },
  main = "hunk",
  opts = {
    ui = {
      confirm_before_quit = true,
      layout = "vertical",
      tree = {
        mode = "nested",
        width = 35,
        use_float = false,
      },
    },
    keys = {
      global = {
        quit = { "q", "<Esc>" },
        accept = { "<leader><CR>" },
        focus_tree = { "<leader>e" },
      },
      tree = {
        open_file = { "<CR>", "o" },
        toggle_file = { "a" },
        expand_node = { "l", "<Right>" },
        collapse_node = { "h", "<Left>" },
      },
      diff = {
        toggle_line = { "a" },
        toggle_line_pair = { "s" },
        toggle_hunk = { "A" },
        prev_hunk = { "[h" },
        next_hunk = { "]h" },
        toggle_focus = { "<Tab>" },
      },
    },
  },
}
