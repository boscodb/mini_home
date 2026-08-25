return {
  "nicolasgb/jj.nvim",
  version = "*", -- Use latest stable release
  dependencies = {
    "clabby/difftastic.nvim",
  },
  config = function()
    local jj_diff = require("jj.diff")

    local function open_difftastic(revset)
      require("difftastic-nvim").open(revset)
    end

    jj_diff.register_backend("difftastic", {
      show_revision = function(opts)
        open_difftastic(opts.rev)
      end,

      diff_revisions = function(opts)
        open_difftastic(string.format("%s..%s", opts.left, opts.right))
      end,

      diff_history_revisions = function(opts)
        open_difftastic(string.format("%s..%s", opts.left, opts.right))
      end,

      -- Optional:
      -- This makes :Jdiff use difftastic too, but it opens the whole change,
      -- not only the current file.
      -- diff_current = function(opts)
      --   open_difftastic(opts.rev or "@-")
      -- end,
    })

    require("jj").setup({
      diff = {
        backend = "difftastic",
      },
    })
  end,
}
