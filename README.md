# nix home-manager

## first usage

step1:

Refer: https://github.com/numtide/llm-agents.nix
Needed by the llm-agents.nix input. 
home-manager cannot manage /etc -- its `nix.settings` writes ~/.config/nix/nix.conf, which the daemon ignores for substituters -- so this is per-machine and imperative.

Add to /etc/nix/nix.conf, one setting per line:

    experimental-features = nix-command flakes
    max-jobs = auto
    fallback = false

    # nix-daemon related, hence compulsorily in /etc/nix/nix.conf
    extra-substituters = https://cache.numtide.com
    extra-trusted-public-keys = niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=

step2:

    sudo systemctl restart nix-daemon
    nix build --dry-run github:numtide/llm-agents.nix#nono   # must say "fetched", not "built"

step3:

    home-manager switch --flake .#dblinux


## subsequent usage

home-manager switch --flake .#dblinux
