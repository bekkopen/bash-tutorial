#!/bin/bash

# if

if [ "$(whoami)" != 'root' ]; then 
  echo you are using a non-privileged account
  #exit 1;
fi

# one-liner if


[[ "$(whoami)" != 'root' ]] && echo "you are using a non-privileged account" #; exit 1

# test keyword

test "$(whoami)" != 'root'  && echo "you are using a non-privileged account" #; exit 1


echo "end of script"

exit 0
