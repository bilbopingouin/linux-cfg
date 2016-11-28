#!/bin/bash

if [ $# -lt 1 ]
then
  PAR="oct"
else
  PAR="$*"
fi

ALL="oct"

for P in $PAR
do
  echo $P
  case $P in
    oct)  tmux has-session -t $P > /dev/null 2>&1
	  if [ $? -eq 1 ]
	  then
	    echo "Creating $P session."
	    tmux new-session -d -n calc -s $P maxima
	    tmux split-window -h octave
	    tmux new-window -n pwd
	  else
	    echo "Session $P already exists."
	  fi
	  ;;
    proj) tmux has-session -t $P > /dev/null 2>&1
	  if [ $? -eq 1 ]
	  then
	    echo "Creating $P session"
	    tmux new-session -d -s $P
	    tmux split-window -h vim
	  else
	    echo "Session $P already exists."
	  fi
	  ;;
    all) $0 $ALL
	  ;;
    *)	  echo "Session $P is not defined, sorry."
	  tmux has-session -t $P > /dev/null 2>&1
	  if [ $? -eq 1 ]
	  then
	    echo "Creating $P session."
	    tmux new-session -d -s $P
	  else
	    echo "Session $P already exists."
	  fi
	  ;;
  esac
done
