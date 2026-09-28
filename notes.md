# Nix

## home-manager
export NIX_CONFIG="..."
nix run github:nix-community/home-manager -- switch --flake .#<homeConfiguration>

## Nix binary caches (numtide llm-agents; https://github.com/numtide/llm-agents.nix)

Needed by the llm-agents.nix input. home-manager cannot manage /etc -- its `nix.settings` writes ~/.config/nix/nix.conf, 
which the daemon ignores for substituters -- so this is per-machine and imperative.

Add to /etc/nix/nix.conf, one setting per line:

    extra-substituters = https://cache.numtide.com
    extra-trusted-public-keys = niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=

Next do this,

    sudo systemctl restart nix-daemon
    nix build --dry-run github:numtide/llm-agents.nix#nono   # must say "fetched", not "built"

Leave `trusted-users = root`. The cache works without widening it, and widening it would let any flake add its own substituters. 
Consequence: nix asks twice per llm-agents nixConfig setting -- answer `n` (don't allow), then `y` (permanently untrusted). 
Recorded in ~/.local/share/nix/trusted-settings.json. 
The leftover "ignoring untrusted flake configuration setting" warnings are cosmetic.

A first fetch of a large NAR can crawl at a few KiB/s while the same host serves other paths at MB/s 
-- a cold object at numtide's CDN origin, not a local problem.
Ctrl-C and retry; the edge warms and it completes in minutes. 

# Direnv

Manually add `eval "$(direnv hook bash)"` to .bashrc
TODO: move bash management to home-manager
