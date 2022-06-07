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

# ---------------------------------------------
# zsh setup
# -----------------------------------------------

setopt RM_STAR_WAIT               # Wait when typing `rm *` before being able to confirm
setopt NO_BEEP                    # Don't beep on errors in ZLE
setopt HIST_REDUCE_BLANKS         # Remove superfluous blanks before recording entry.
setopt HIST_IGNORE_SPACE          # Don't record an entry starting with a space.
setopt HIST_NO_STORE              # Remove the history (fc -l) command from the history.
setopt EXTENDED_HISTORY           # Write the history file in the ":start:elapsed;command" format.
setopt HIST_SAVE_NO_DUPS          # Don't write duplicate entries in the history file.
setopt HIST_EXPIRE_DUPS_FIRST     # Expire duplicate entries first when trimming history.
setopt HIST_FIND_NO_DUPS          # Do not display a line previously found.
setopt completealiases
setopt always_to_end
setopt list_ambiguous
export HISTSIZE=100000 # big big history
export HISTFILESIZE=100000 # big big history


# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}
pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

export LS_COLORS='rs=0:di=01;34:ln=01;35:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=32:st=37;44:ex=00;31:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:';

# ------------------------------------------
# key bindings
# -------------------------------------------

bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# Accept zsh autosggestions with ctrl + space
# Make sure you don't have mac input source switch
bindkey '^ ' autosuggest-accept

# -----------------------------------------
# aliases
# -----------------------------------------
alias ls='ls -hF --color' # add colors for filetype recognition
alias rm="rm -i"
alias rl='readlink -f'
alias hn='hostname'
alias pc='python -c'
alias jl="jupyter lab --no-browser --ip $(hostname)"
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
alias q='qstat'
alias wq="watch qstat"
function qrecycle() { [ ! -z $SINGULARITY_CONTAINER ] && ssh localhost "qrecycle $@" || command qrecycle "$@" ;}
function qupdate() { [ ! -z $SINGULARITY_CONTAINER ] && ssh localhost "qupdate" || command qupdate ;}
alias dev="ssh davidma@davidma.dev-vms.speechmatics.io"

alias b1="ssh gpu001.grid.speechmatics.io"
alias b2="ssh gpu002.grid.speechmatics.io"
alias b3="ssh gpu003.grid.speechmatics.io"
alias b4="ssh gpu004.grid.speechmatics.io"
alias b5="ssh gpu005.grid.speechmatics.io"
alias b6="ssh gpu006.grid.speechmatics.io"
alias b6="ssh gpu007.grid.speechmatics.io"

alias ms="make shell"
alias ms1="~/git/aladdin/env/singularity.sh -c $SHELL"
alias ms2="~/git/aladdin2/env/singularity.sh -c $SHELL"
alias ms3="~/git/aladdin3/env/singularity.sh -c $SHELL"

alias a1="cd ~/git/aladdin && ms"
alias a2="cd ~/git/aladdin2 && ms"
alias a3="cd ~/git/aladdin3 && ms"

export gb1="gpu.q@b1"
export gb2="gpu.q@b2"
export gb3="gpu.q@b3"
export gb4="gpu.q@b4"
export gb5="gpu.q@b5"
export gb6="gpu.q@b6"
export gb6="gpu.q@b6"

export CI_TOKEN="13324fd2f1d060e58734653dd4e443"
export ARTIFACTS_TOKEN="AKCp5aTGrR9pu52bWUTBN95D7snbyxoEb4bXwhuCcjTkvXH1xcNNHdnddcj967tq4umZ9oHLv"
export GITLAB_TOKEN="SQ4jmznyginLBFns5xqv"

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
    log_path=$(qlog $1)
    base_dir=$(echo $log_path | rev | cut -d "/" -f3- | rev)
    filename=$(basename $log_path)
    echo ${base_dir}/log/${filename%.log}.${2}.log
  else
    echo "Usage: q<command> <jobid>" >&2
    echo "Usage: q<command> <array_jobid> <sub_jobid>" >&2
  fi
}

qtail () {
  tail -f $(qlog $@)
}

qlast () {
  # Tail the last running job
  job_id=$(qstat | awk '$5=="r" {print $1}' | grep -E '[0-9]' | sort -r | head -n 1)
  echo "qtail of most recent job ${job_id}"
  qtail ${job_id}
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
    if [[ ! $(qstat -j $job | grep "job-array tasks") ]]; then
      echo $job $(qlog $job)
    else
      qq_dir=$(qlog $job)
      job_status=$(echo $line | awk '{print $5}')
      if [ $job_status = 'r' ]; then
        sub_job=$(echo $line | awk '{print $10}')
        echo $job $sub_job $(qlog $job $sub_job)
      else
        echo $job $qq_dir $job_status
      fi
    fi
  done
}

qlogin () {
  if [ "$#" -eq 1 ]; then
    /usr/bin/qlogin -now n -pe smp $1 -q aml-gpu.q -l gpu=$1 -N D_$(whoami)
  elif [ "$#" -eq 2 ]; then
    if [ "$1" = "cpu" ]; then
      /usr/bin/qlogin -now n -pe smp $2 -q aml-cpu.q -N D_$(whoami)
    else
    /usr/bin/qlogin -now n -pe smp $1 -q $2 -l gpu=$1 -N D_$(whoami)
    fi
  elif [ "$#" -eq 3 ]; then
    /usr/bin/qlogin -now n -pe smp $2 -q $3 -N D_$(whoami)
  else
    echo "Usage: qlogin <num_gpus>" >&2
    echo "Usage: qlogin <num_gpus> <queue>" >&2
    echo "Usage: qlogin cpu <num_slots>" >&2
    echo "Usage: qlogin cpu <num_slots> <queue>" >&2
  fi
}

qrecycle () {
    [ ! -z $SINGULARITY_CONTAINER ] && ssh localhost "qrecycle $@" || command qrecycle "$@";
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
  singularity exec -B $PWD oras://singularity-master.artifacts.speechmatics.io/tensorboard:2.6.0a20210704 tensorboard --host=$(hostname -f) --logdir=$logdir --reload_multifile true
}


ediff () {
  diff -rq $1 $2 |& grep "^Files.*differ$" | fgrep -v ".git" | grep -v pyc | grep -v "No such" | grep -v htmlcov | grep -v cover | grep -v README | grep -v test | grep -v qu | while read line; do f1=$(echo $line | cut -d " " -f2); f2=$(echo $line | cut -d " " -f4); echo $f1 $f2; diff $f1 $f2; done | less

}