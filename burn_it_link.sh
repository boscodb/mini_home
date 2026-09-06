rm -rf ~/.config/i3
ln -sfn "$(realpath ./.config/i3)" ~/.config/i3

rm -rf ~/.config/nvim
ln -sfn "$(realpath ./.config/nvim)" ~/.config/nvim

rm -f ~/.tmux.conf
ln -sfn "$(realpath ./.tmux.conf)" ~/.tmux.conf # On a fresh machine/install, TPM will need to be installed manually. There is no benefit in 'vendoring' it in this repo.

rm ~/.config/nono
ln -sfn "$(realpath ./.config/nono)" ~/.config/nono

rm -rf ~/.agents
ln -sfn "$(realpath ./.agents)" ~/.agents

rm -rf ~/.config/nix
ln -sfn "$(realpath ./.config/nix)" ~/.config/nix

rm -rf ~/.config/doom
ln -sfn "$(realpath ./.config/doom)" ~/.config/doom
# ~/.config/emacs/bin/doom sync
# ~/.config/emacs/bin/doom doctor

rm -f ~/.local/bin/sbcl
ln -sfn "$(realpath ./helpers/cl/roswell/sbcl)" ~/.local/bin/sbcl
