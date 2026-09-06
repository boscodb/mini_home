{
  description = "mini_home: tools managed by nix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:

  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = pkgs.buildEnv {
      name = "mini-home-tools";

      # Add tools here, one per line. Then:
      #   nix profile upgrade mini_home
      paths = with pkgs; [
        emacs
        fd
        fzf
      ];
    };
  };
}

 
