return {
  "MSmaili/wiremux.nvim",
  dependencies = {
    "ibhagwan/fzf-lua", -- optional
    "folke/snacks.nvim", -- optional
  },

  opts = {
    ui = {
      compose = {
        title = " Review Context ",
        close_behavior = "hide",
        on_new_payload = "keep",
      },
    },
    targets = {
      definitions = {
        terminal = { kind = "pane", split = "horizontal" },
        -- pi = { kind = { "pane", "window" }, shell = false },
        -- claude = { cmd = "claude", kind = "window", shell = true },
        -- codex = { cmd = "codex", kind = "window", shell = true },
        -- agy = { cmd = "agy", kind = "window", shell = true },

        pi = {
          cmd = "nono run --profile pi-local --allow-cwd -- pi",
          kind = { "pane", "window" },
          shell = false,
        },
        claude = {
          cmd = "nono run --profile nolabs-ai/claude --allow-cwd  -- claude --dangerously-skip-permissions",
          kind = "pane",
          shell = true,
        },
        codex = {
          cmd = "nono run --profile nolabs-ai/codex --allow-cwd -- codex  --dangerously-bypass-approvals-and-sandbox",
          kind = "pane",
          shell = true,
        },
        agy = {
          cmd = "nono run --profile agy-local --allow-cwd -- agy --mode=accept-edits",
          kind = "pane",
          shell = true,
        },

        iex = { cmd = "iex", kind = "pane", shell = true },

        rocky = { kind = "pane", split = "horizontal" }, -- same as 'terminal' target, afaiu.
      },
    },
  },

  keys = {
    {
      "<leader>tao",
      function()
        require("wiremux").adopt()
      end,
      desc = "Wiremux adopt tmux any 'bash (aka terminal)' pane",
    },
    {
      "<leader>tae",
      function()
        require("wiremux").adopt({ target = "iex" })
      end,
      desc = "Wiremux adopt tmux iex pane",
    },
    {
      "<leader>tar",
      function()
        require("wiremux").adopt({ target = "rocky" })
      end,
      desc = "Wiremux adopt tmux rocky pane",
    },
    -- ##################################################################################
    {
      "<leader>tT",
      function()
        require("wiremux").send("{this}", { behavior = "pick", compose = true, focus = false, submit = true })
      end,
      mode = { "n", "x" },
      desc = "Wiremux send this",
    },
    {
      "<leader>tt",
      function()
        -- require("wiremux").send("{this}", { behavior = "all", compose = true, focus = false, submit = true })

        require("wiremux").send("{this}", {
          behavior = "all",
          compose = true,
          focus = false,
          submit = true,
          filter = {
            instances = function(inst, state)
              return inst.origin == state.origin_pane_id and inst.target ~= "iex" and inst.target ~= "rocky"
            end,
          },
        })
      end,
      mode = { "n", "x" },
      desc = "Wiremux send to all, but <filtered> :)",
    },
    {
      "<leader>tel",
      function()
        require("wiremux").send("{line}", { target = "iex", focus = false, submit = true })
      end,
      mode = { "n", "x" },
      desc = "Wiremux send 'line' to iex",
    },
    {
      "<leader>tes",
      function()
        require("wiremux").send("{selection}", { target = "iex", focus = false, submit = true })
      end,
      mode = { "n", "x" },
      desc = "Wiremux send 'selection' to iex",
    },
    {
      "<leader>tea",
      function()
        require("wiremux").send("{selection}", { target = "iex", compose = true, focus = false, submit = true })
      end,
      mode = { "n", "x" },
      desc = "Wiremux send 'arbitrary' to iex",
    },
    {
      "<leader>tr",
      function()
        require("wiremux").send("{this}", { target = "rocky", compose = true, focus = false, submit = true })
      end,
      mode = { "n", "x" },
      desc = "Wiremux send to rocky",
    },
  },
}
