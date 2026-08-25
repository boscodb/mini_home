# ln -sfn /home/sage/data/zr/mini_home/config/i3 ~/.config/i3

ln -sfn "$(realpath ./config/i3)" ~/.config/i3
ln -sfn "$(realpath ./config/nvim)" ~/.config/nvim

ln -sfn "$(realpath ./.tmux.conf)" ~/.tmux.conf # On a fresh machine/install, TPM will need to be installed manually. There is no benefit in 'vendoring' it in this repo.
