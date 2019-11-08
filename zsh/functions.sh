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
