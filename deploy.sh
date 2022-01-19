#!/bin/bash
set -euo pipefail

echo "source $HOME/dotfiles/zsh/.zshrc.sh" > $HOME/.zshrc
echo "source $HOME/dotfiles/tmux/.tmux.conf" > $HOME/.tmux.conf
# cp -f $HOME/dotfiles/.pdbrc $HOME/.pdbrc

ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

if [[ ! -d ${ZSH_CUSTOM}/themes/powerlevel10k ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
fi
(
    cd $ZSH_CUSTOM/themes/powerlevel10k && git pull
)

if [[ ! -d ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
fi

if [[ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

find . -maxdepth 1 -name '.*' -type f | xargs -I{} cp -f {} ~/
zsh
