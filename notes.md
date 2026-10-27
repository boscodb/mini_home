# Nix

## home-manager
export NIX_CONFIG="..."
nix run github:nix-community/home-manager -- switch --flake .#<homeConfiguration>

## Numtide LLM-Agent update
nix flake update llm-agents
home-manager switch --flake .#<homeConfiguration>


# Direnv

Manually add `eval "$(direnv hook bash)"` to .bashrc
TODO: move bash management to home-manager


# jj-diffconflicts (https://github.com/rafikdraoui/jj-diffconflicts)
TODO: Add needed jj config (to home-manager).
TODO: Also study, https://github.com/dont-be-evil-company/diffconflicts.nvim

# INFO for gh and glab

## Symptom: 
The browser shows "you're all set", but `gh auth login` hangs forever and
`gh auth status` reports no token. (The `ERROR:gpu/...` / `DEPRECATED_ENDPOINT` lines in
the terminal are just Chrome's stderr on the shared tty -- unrelated.)
Similar symptom for `glab` as well.

## Cause: 
`helpers/.local/bin/xdg-open` (the WSL shim created in this project and managed by gnu stow) used to force XDG_CURRENT_DESKTOP=X-Generic for http(s) unconditionally. 
On native Ubuntu/GNOME that makes xdg-utils' detectDE pick DE=generic, so it takes open_generic instead of open_gnome3. 

open_gnome3 runs `gio open` and returns at once; 
open_generic ends in `env "$command" "$@"` -- foreground, no `&`. 
gh/glab launch the browser with cmd.Run(), so they block there and never poll the OAuth device-code endpoint. 
With no Chrome already running, xdg-open *is* Chrome, so the CLI waits until you quit the browser.


## Fix (applied): 
The shim now rewrites the DE only under WSL, so native GNOME keeps the fast-returning `gio open` path.


# jj

## update-stale for all workspaces
Add `jju` script to ~/.local/bin via gnu stow.

