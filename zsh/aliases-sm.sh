#!/bin/zsh
alias qq="qstat -f -u '*' | less "
alias q="qstat -f -u '*' -q 'gpu.q*' | head -n40 | grep -v '\-\-\-\-' | grep -v queuename | grep -v '######' | grep -v '\- PENDING'"
alias wq="watch 'qstat -f -u '\''*'\'' -q '\''gpu.q*'\'' | head -n40 | grep -v '\''\-\-\-\-'\'' | grep -v queuename | grep -v '\''######'\'' | grep -v '\''\- PENDING'\'"
alias nsp="ps -up $(nvidia-smi -q -x | grep pid | sed -e 's/<pid>//g' -e 's/<\/pid>//g' -e 's/^[[:space:]]*//')"
alias ba="ssh bastion.aml.speechmatics.io"
alias b1="ssh $b1"
alias b2="ssh $b2"
alias b3="ssh $b3"