{
  description = "mini_home: tools managed by Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      #   system = "x86_64-linux";
      #   username = "sage";
      #   pkgs = import nixpkgs {
      #     inherit system;
      #
      #     config.allowUnfreePredicate = pkg:
      #       builtins.elem (nixpkgs.lib.getName pkg) [
      #         "claude-code"
      #         "antigravity-cli"
      #       ];
      #   };
      mkHome =
        {
          system,
          username,
          homeDirectory,
        }:
        let
          pkgs = import nixpkgs {
            inherit system;

            config.allowUnfreePredicate =
              pkg:
              builtins.elem (nixpkgs.lib.getName pkg) [
                "claude-code"
                "antigravity-cli"
              ];
          };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            {
              home.username = username;
              home.homeDirectory = homeDirectory;

              home.packages = with pkgs; [
                # CLI tools
                fd
                fzf
                ripgrep
                jujutsu
                git-credential-manager

                # Compilers, Runtimes
                nodejs_26
                gcc

                # Git Tools
                difftastic

                # Nix Tools
                nil
                nixfmt
                statix

                # Editors
                neovim
                emacs

                # Fonts
                nerd-fonts._0xproto
                nerd-fonts._3270

                # Coding Agents
                pi-coding-agent
                codex
                claude-code
                antigravity-cli

                # dotfiles
                stow
              ];

              # Initial Home Manager state version.
              # Do not change casually.
              home.stateVersion = "26.05";

              programs.git = {
                enable = true;

                settings = {
                  credential = {
                    helper = "manager";
                    credentialStore = "cache";
                  };
                };
              };

              programs.jujutsu = {

                enable = true;

                settings = {

                  user = {
                    name = "bzrq";
                    email = "bosco.dsouza.82@gmail.com";
                  };

                  ui = {
                    editor = "nvim";
                    diff-editor = [
                      "nvim"
                      "-c"
                      "DiffEditor $left $right $output"
                    ];
                    diff-instructions = false; # To suppress the JJ-INSTRUCTIONS file that jujutsu injects into the diff editor
                  };

                };
              };

              programs.home-manager.enable = true;
            }
          ];
        };
    in
    {

      homeConfigurations = {
        "sage@thunderbird" = mkHome {
          system = "x86_64-linux";
          username = "sage";
          homeDirectory = "/home/sage";
        };

        "administrator@74" = mkHome {
          system = "x86_64-linux";
          username = "administrator";
          homeDirectory = "/home/administrator";
        };

        # Example of a machine with different 'system'
        "alice@arm-machine" = mkHome {
          system = "aarch64-linux";
          username = "alice";
          homeDirectory = "/home/alice";
        };
      };
    };
}
