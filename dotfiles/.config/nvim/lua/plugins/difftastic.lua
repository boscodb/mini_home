return {
  "clabby/difftastic.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    download = true,
    vcs = "jj",
    hunk_wrap_file = true,
    scroll_to_first_hunk = true,
    keymaps = {
      close = "q",
      next_file = "]f",
      prev_file = "[f",
      next_hunk = "]h",
      prev_hunk = "[h",
      focus_tree = "<Tab>",
      focus_diff = "<Tab>",
      goto_file = "gf",
    },
  },
}
