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
                "google-chrome"
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
                # OS Tools
                xdg-utils # provides xdg-open; GCM requires it on PATH to offer browser sign-in

                # CLI tools
                nono
                fd
                fzf
                ripgrep
                jujutsu
                gh
                glab

                # Compilers, Runtimes
                nodejs_26
                gcc
                tree-sitter # nvim-treesitter grammar builds; must shadow the Windows npm shim on WSL PATH

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
                # pi-coding-agent
                codex
                claude-code
                antigravity-cli

                # Agentic Tools
                agent-browser

                # dotfiles
                stow
              ];

              # Initial Home Manager state version.
              # Do not change casually.
              home.stateVersion = "26.05";

              programs.git = {
                enable = true;

                settings = {
                  credential."https://github.com".helper = "!gh auth git-credential";
                  credential."https://gitlab.com".helper = "!glab auth git-credential";
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

                  git = {
                    # Give every fetched remote bookmark a local counterpart.
                    # Without this jj leaves them as `name@remote` only, so a branch
                    # like `f/main` looks "not pulled" even though the commits are here.
                    auto-local-bookmark = true;
                  };

                };
              };

              programs.chromium = {
                enable = true;
                package = pkgs.google-chrome;
              };

              xdg.mimeApps = {
                enable = true;
                defaultApplications = {
                  "text/html" = "google-chrome.desktop";
                  "x-scheme-handler/http" = "google-chrome.desktop";
                  "x-scheme-handler/https" = "google-chrome.desktop";
                  "x-scheme-handler/about" = "google-chrome.desktop";
                  "x-scheme-handler/unknown" = "google-chrome.desktop";
                };
              };

              programs.home-manager.enable = true;
            }
          ];
        };
    in
    {

      homeConfigurations = {
        "blinux" = mkHome {
          system = "x86_64-linux";
          username = "sage";
          homeDirectory = "/home/sage";
        };

        "klinux74" = mkHome {
          system = "x86_64-linux";
          username = "administrator";
          homeDirectory = "/home/administrator";
        };

        "bwsl" = mkHome {
          system = "x86_64-linux";
          username = "lolya";
          homeDirectory = "/home/lolya";
        };

        # Example of a machine with different 'system' i.e. ARM.
        "alice@arm-machine" = mkHome {
          system = "aarch64-linux";
          username = "alice";
          homeDirectory = "/home/alice";
        };
      };
    };
}
