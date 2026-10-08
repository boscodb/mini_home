# nix home-manager

## first usage

NIX_CONFIG="experimental-features = nix-command flakes" nix run github:nix-community/home-manager -- switch --flake .#dblinux


## subsequent usage

home-manager switch --flake .#dblinux
