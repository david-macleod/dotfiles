# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

# Setup plugins
plugins=(git gitfast zsh-autosuggestions zsh-syntax-highlighting history-substring-search)

source $ZSH/oh-my-zsh.sh
ZLE_RPROMPT_INDENT=0

# p10k theme settings
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ipdb default debugger
export PYTHONBREAKPOINT=ipdb.set_trace
export VSDEBUG="-m debugpy --listen 5678 --wait-for-client"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# -----------------------------------------
# aliases
# -----------------------------------------
alias rm="rm -i"
alias rl='readlink -f'
alias hn='hostname'
alias pc='python -c'
alias jl="jupyter lab --no-browser --port 8888 --ip $(hostname)"
alias ns='nvidia-smi'

# docker
function jonah() { docker exec -it $@ /bin/bash ;}
function run-jonah() { docker run -it --entrypoint /bin/bash $@ ;}
alias harpoon='(docker stop $(docker ps -a -q); docker rm -f $(docker ps -a -q))'

# git plugin overrides
alias gc="git commit -m"
alias gcm="git checkout master"
alias grm="git fetch origin master:master && git rebase master"

# avoid accidental GPU usage
if [ -z $CUDA_VISIBLE_DEVICES ]; then
    export CUDA_VISIBLE_DEVICES=
fi


# ------------------------------------------
# speechmatics
# ------------------------------------------
alias qq="qstat -f -u '*' | less "
alias gq="qstat -f -u '*' -q aml-gpu.q | less "
alias q="qstat -f -u '*' -q 'aml-gpu.q*' | head -n40 | grep -v '\-\-\-\-' | grep -v queuename | grep -v '######' | grep -v '\- PENDING'"
#alias wq="watch 'qstat -f -u '\''*'\'' -q '\''gpu.q*'\'' | head -n40 | grep -v '\''\-\-\-\-'\'' | grep -v queuename | grep -v '\''######'\'' | grep -v '\''\- PENDING'\'"
alias nsp="ps -up $(nvidia-smi -q -x | grep pid | sed -e 's/<pid>//g' -e 's/<\/pid>//g' -e 's/^[[:space:]]*//')"
alias dev="ssh davidma@davidma.dev-vms.speechmatics.io"
alias b1="ssh beast1.aml.speechmatics.io"
alias b2="ssh beast2.aml.speechmatics.io"
alias b3="ssh beast3.aml.speechmatics.io"
alias b4="ssh beast4.aml.speechmatics.io"
alias b5="ssh beast5.aml.speechmatics.io"
alias ms="~/git/aladdin/env/singularity.sh -c $SHELL"

export b1="beast1.aml.speechmatics.io"
export b2="beast2.aml.speechmatics.io"
export b3="beast3.aml.speechmatics.io"
export b4="beast4.aml.speechmatics.io"
export gb1="gpu.q@${b1}"
export gb2="gpu.q@${b2}"
export gb3="gpu.q@${b3}"
export gb4="gpu.q@${b4}"
export gb5="gpu.q@${b5}"

export CI_TOKEN="2914293c68a5626ad2a7040ad95b3d"


# -------------------------------------------
# functions
# -------------------------------------------
explain () {
  if [ "$#" -eq 0 ]; then
    while read  -p "Command: " cmd; do
      curl -Gs "https://www.mankier.com/api/explain/?cols="$(tput cols) --data-urlencode "q=$cmd"
    done
    echo "Bye!"
  elif [ "$#" -eq 1 ]; then
    curl -Gs "https://www.mankier.com/api/explain/?cols="$(tput cols) --data-urlencode "q=$1"
  else
    echo "Usage"
    echo "explain                  interactive mode."
    echo "explain 'cmd -o | ...'   one quoted command to explain it."
  fi
}

extract () {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       unrar x $1       ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *)           echo "don't know how to extract '$1'..." ;;
      esac
  else
      echo "'$1' is not a valid file!"
  fi
}

qlog () {
  if [ "$#" -eq 1 ]; then
    echo $(qstat -j $1 | grep stdout_path_list | cut -d ":" -f4)
  elif [ "$#" -eq 2 ]; then
    qq_dir=$(qlog $1)
    echo $(ls ${qq_dir}/*o${1}.${2})
  else
    echo "Usage: q<command> <jobid>" >&2
    echo "Usage: q<command> <array_jobid> <sub_jobid>" >&2
  fi
}

qtail () {
  tail -f $(qlog $@)
}

qless () {
  less $(qlog $@)
}

qcat () {
  cat $(qlog $@)
}

qdesc () {
  qstat | tail -n +3 | while read line; do
    job=$(echo $line | awk '{print $1}')
    if [ -z "$(qstat -j $job | grep "job-array tasks")" ]; then
      echo $job $(qlog $job)
    else
      qq_dir=$(qlog $job)
      if [ $(echo $line | awk '{print $5}') = 'r' ]; then
        sub_job=$(echo $line | awk '{print $10}')
        qq_dir=$(qlog $job)
        log_file=$(find ${qq_dir} -name "*o${job}.${sub_job}")
        echo $job $sub_job $(grep -o -m 1 -E "expdir=[^ ]* "  $log_file | cut -d "=" -f2)
      else
        echo $job $qq_dir "qw"
      fi
    fi
  done
}

pmodel () {
  python -c "import torch; m = torch.load('"$1"', map_location='cpu'); print(m, end='\n\n'); print(f'Train param count: {sum(x.numel() for x in m.parameters() if x.requires_grad):,}'); print(f'Total param count: {sum(x.numel() for x in m.parameters()):,}')"
}

ppath () { tr ':' '\n' <<< "$1" }

tblink () {
  if [ "$#" -eq 0 ]; then
    logdir=$(pwd)
  else
  # setup tensorboard directory
    tbdir="$HOME/tb"
    if [ -d "$tbdir" ]; then

      last=$(ls -v $tbdir | tail -1)
      new=$((last+1))
      logdir="$tbdir/$new"
    else
      logdir="$tbdir/0"
    fi
    mkdir -p $logdir

    # softlink into tensorboard directory
    for linkdir in "$@"; do
      linkdir=$(rl $linkdir)
      echo "linkdir: $linkdir"
      ln -s $linkdir $logdir
    done
  fi

  echo "logdir: $logdir"
  singularity exec /workspaces/sif/20210213_tensorboard.sif tensorboard --host=$(hostname -f) --logdir=$logdir --reload_multifile true
}

tb () {
  if [ "$#" -eq 0 ]; then
    logdir=$(pwd)
  else
   logdir=$1
  fi
  $HOME/venvs/tensorboard/bin/tensorboard --host=$(hostname) --logdir=$logdir --reload_multifile true
}

ffprobe-time () {
  ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $1
}

ediff () {
  diff -rq $1 $2 |& grep "^Files.*differ$" | fgrep -v ".git" | grep -v pyc | grep -v "No such" | grep -v htmlcov | grep -v cover | grep -v README | grep -v test | grep -v qu | while read line; do f1=$(echo $line | cut -d " " -f2); f2=$(echo $line | cut -d " " -f4); echo $f1 $f2; diff $f1 $f2; done | less

}

qp () {
  if [ "$#" -eq 1 ]; then
    job_id=$1
    job_name=$(qstat -j $job_id | grep job_name | awk '{print $2}')
    if [[ $(qstat -j $job_id | grep job_name | awk '{print $2}') =~ "^P_" ]]; then
      qalter -N ${job_name#"P_"} $job_id
    else
      qalter -N "P_${job_name}" $job_id
    fi
  else
	  echo "Usage: qp <jobid>" >&2
  fi
}

cmpgz () {
  if [ "$#" -eq 2 ]; then
    TMPFILE1=$(mktemp)
    TMPFILE2=$(mktemp)
    gunzip -c $1 > $TMPFILE1
    gunzip -c $2 > $TMPFILE2
    cmp $TMPFILE1 $TMPFILE2
    rm -f $TMPFILE1 $TMPFILE2
  else
    echo "Usage: cmpgz <file1.gz> <file2.gz>" >&2
  fi
}