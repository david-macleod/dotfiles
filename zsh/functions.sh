#!/bin/zsh

# quickly search command history
hi () {
   if [ "$#" -eq 1 ]; then
	   history | grep "$1"
   else
	   echo "Usage: hi <substring>" >&2
   fi
}

qcat () {
  if [ "$#" -eq 1 ]; then
    cat $(qstat -j $1 | grep log | grep std | cut -d ":" -f4)
  else
    echo "Usage: qcat <jobid>" >&2
  fi
}

qtail () {
  if [ "$#" -eq 1 ]; then
    tail -f $(qstat -j $1 | grep log | grep std | cut -d ":" -f4)
  else
    echo "Usage: qless <jobid>" >&2
  fi
}

qless () {
  if [ "$#" -eq 1 ]; then
    less $(qstat -j $1 | grep log | grep std | cut -d ":" -f4)
  else
    echo "Usage: qless <jobid>" >&2
  fi
}

qdesc () {
  for job in $(qstat | awk '{print $1}' | tail -n +3); do
    echo "$job $(qstat -j $job | grep log | grep std | rev | cut -d "/" -f2 | rev)"
  done
}

ns () {
  if [ "$#" -eq 1 ]; then
    ssh $1 'nvidia-smi'
  else
    nvidia-smi
  fi
}

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

  $HOME/venvs/tensorboard/bin/tensorboard --host=$(hostname) --logdir=$logdir
}

ffprobe-time () {
  for f in $(cat $1 | awk '{print $1}'); do
    echo $f $(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $f)
  done
} 

ediff () {
  diff -rq $1 $2 |& grep "^Files.*differ$" | fgrep -v ".git" | grep -v pyc | grep -v "No such" | grep -v htmlcov | grep -v cover | grep -v README | grep -v test | grep -v qu | while read line; do f1=$(echo $line | cut -d " " -f2); f2=$(echo $line | cut -d " " -f4); echo $f1 $f2; diff $f1 $f2; done | less

}
