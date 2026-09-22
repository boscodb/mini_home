# nix home-manager

## first usage

nix --extra-experimental-features 'nix-command flakes' run github:nix-community/home-manager -- switch --flake .#klinux20

## subsequent usage

home-manager switch --flake .#klinux20
