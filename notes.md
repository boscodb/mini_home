# Nix

export NIX_CONFIG="..."
nix run github:nix-community/home-manager -- switch --flake .#<homeConfiguration>

# Git Credential Manager

git credential-cache exit
