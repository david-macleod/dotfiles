#!/bin/zsh
alias getgpu="qlogin -q gpu.q"
alias get980="qlogin -q gpu.q@@980"
alias gettitanx="qlogin -q gpu.q@@titanx"
alias qq="qstat -f -u '*' | less "