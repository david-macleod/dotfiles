# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Setup anaconda
export PATH=$HOME/anaconda3/bin:$HOME/miniconda3/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# Setup plugins
plugins=(git gitfast)

source $ZSH/oh-my-zsh.sh

# Additional plugins
source $HOME/dotfiles/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/dotfiles/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Custom aliases/keybindings/functions
source $HOME/dotfiles/zsh/aliases.sh
source $HOME/dotfiles/zsh/aliases-sm.sh
source $HOME/dotfiles/zsh/functions.sh
source $HOME/dotfiles/zsh/keybindings.sh
