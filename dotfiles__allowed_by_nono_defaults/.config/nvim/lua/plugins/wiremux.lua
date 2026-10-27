local function resolve_pane_ids(tmux_targets)
  local pane_ids = {}

  for _, target in ipairs(tmux_targets) do
    local id = vim.fn.system({
      "tmux",
      "display-message",
      "-p",
      "-t",
      target,
      "#{pane_id}",
    })

    if vim.v.shell_error == 0 then
      pane_ids[vim.trim(id)] = true
    end
  end

  return pane_ids
end

local function adopt_headless(tmux_targets, wiremux_target)
  local backend = require("wiremux.backend").get()
  if not backend then
    return
  end

  local state = backend.state.get()
  local wanted = resolve_pane_ids(tmux_targets)

  for _, pane in ipairs(state.panes or {}) do
    if wanted[pane.id] and pane.session_id == state.session_id and pane.id ~= state.origin_pane_id then
      local target = pane.target or wiremux_target or ("pane-" .. pane.id:match("%d+"))
      backend.adopt(pane, state, { target = target })
    end
  end
end

local function unadopt_headless(tmux_targets)
  local backend = require("wiremux.backend").get()
  if not backend then
    return
  end

  local state = backend.state.get()
  local wanted = resolve_pane_ids(tmux_targets)
  local options = {
    "@wiremux_target",
    "@wiremux_origin",
    "@wiremux_origin_cwd",
    "@wiremux_kind",
    "@wiremux_last_used_at",
  }

  for _, pane in ipairs(state.panes or {}) do
    if wanted[pane.id] and pane.session_id == state.session_id then
      for _, option in ipairs(options) do
        vim.fn.system({
          "tmux",
          "set-option",
          "-p",
          "-q",
          "-u",
          "-t",
          pane.id,
          option,
        })
      end
    end
  end
end

return {
  "MSmaili/wiremux.nvim",
  dependencies = {
    "ibhagwan/fzf-lua",  -- optional
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
    { -- tao
      "<leader>tao",
      function()
        require("wiremux").adopt()
      end,
      desc = "Wiremux adopt tmux any 'bash (aka terminal)' pane",
    },
    { -- tae
      "<leader>tae",
      function()
        require("wiremux").adopt({ target = "iex" })
      end,
      desc = "Wiremux adopt tmux iex pane",
    },
    { -- tar
      "<leader>tar",
      function()
        require("wiremux").adopt({ target = "rocky" })
      end,
      desc = "Wiremux adopt tmux rocky pane",
    },
    { -- thc
      "<leader>thc",
      function()
        adopt_headless({
          ":coders.0",
          ":coders.1",
          ":coders.2",
        })
      end,
      desc = "Wiremux headless adopt coder panes",
    },
    { -- thC
      "<leader>thC",
      function()
        unadopt_headless({
          ":coders.0",
          ":coders.1",
          ":coders.2",
        })
      end,
      desc = "Wiremux headless unadopt coder panes",
    },
    { -- thr
      "<leader>thr",
      function()
        adopt_headless({
          ":0.3",
        }, "rocky")
      end,
      desc = "Wiremux headless adopt rocky pane",
    },
    { -- thR
      "<leader>thR",
      function()
        unadopt_headless({
          ":0.3",
        })
      end,
      desc = "Wiremux headless unadopt rocky pane",
    },
    -- ##################################################################################
    { -- tT
      "<leader>tT",
      function()
        require("wiremux").send("{this}", { behavior = "pick", compose = true, focus = false, submit = true })
      end,
      mode = { "n", "x" },
      desc = "Wiremux send this",
    },
    { -- tt
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
    { -- tel
      "<leader>tel",
      function()
        require("wiremux").send("{line}", { target = "iex", focus = false, submit = true })
      end,
      mode = { "n", "x" },
      desc = "Wiremux send 'line' to iex",
    },
    { -- tes
      "<leader>tes",
      function()
        require("wiremux").send("{selection}", { target = "iex", focus = false, submit = true })
      end,
      mode = { "n", "x" },
      desc = "Wiremux send 'selection' to iex",
    },
    { -- tea
      "<leader>tea",
      function()
        require("wiremux").send("{selection}", { target = "iex", compose = true, focus = false, submit = true })
      end,
      mode = { "n", "x" },
      desc = "Wiremux send 'arbitrary' to iex",
    },
    { -- tr
      "<leader>tr",
      function()
        require("wiremux").send("{this}", { target = "rocky", compose = true, focus = false, submit = true })
      end,
      mode = { "n", "x" },
      desc = "Wiremux send to rocky",
    },
  },
}
