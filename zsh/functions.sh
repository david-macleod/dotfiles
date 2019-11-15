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
