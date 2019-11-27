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
  
tb () {

  session=tb
  # create tb tmux session if not existing
  tmux has-session -t $session 2>/dev/null
  if [ $? != 0 ]; then
    tmux new -d -s $session
  else
    tmux split-window -v -p 90 -t $session
  fi

  # run tensorboard
  tmux send -t $session "tblink $@" ENTER
  sleep 3 && tmux capture-pane; tmux show-buffer | grep -v -e '^$'
}
