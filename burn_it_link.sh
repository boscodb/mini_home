# ln -sfn /home/sage/data/zr/mini_home/config/i3 ~/.config/i3

rm -rf ~/.config/i3
ln -sfn "$(realpath ./.config/i3)" ~/.config/i3

rm -rf ~/.config/nvim
ln -sfn "$(realpath ./.config/nvim)" ~/.config/nvim

rm ~/.tmux.conf
ln -sfn "$(realpath ./.tmux.conf)" ~/.tmux.conf # On a fresh machine/install, TPM will need to be installed manually. There is no benefit in 'vendoring' it in this repo.

rm ~/.config/nono
ln -sfn "$(realpath ./.config/nono)" ~/.config/nono

rm -rf ~/.agents
ln -sfn "$(realpath ./.agents)" ~/.agents

rm -rf ~/.config/nix
ln -sfn "$(realpath ./.config/nix)" ~/.config/nix

rm -rf ~/.config/doom
ln -sfn "$(realpath ./.config/doom)" ~/.config/doom
