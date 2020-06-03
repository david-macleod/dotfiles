#!/bin/zsh
alias cuda0="export CUDA_VISIBLE_DEVICES=0"
alias cuda1="export CUDA_VISIBLE_DEVICES=1"

alias rm="rm -i"
alias rl='readlink -f'
alias hn='hostname'
alias pc='python -c'

# git plugin overrides
alias gc="git commit -m"
alias gcm="git checkout master"
alias grm="git fetch origin master:master && git rebase master"


alias jl="jupyter lab --no-browser --port 8888 --ip $(hostname)"