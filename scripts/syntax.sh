#!/bin/bash

message="you are using a non-privileged account"

# if
if [ "$(whoami)" != 'root' ]; then 
  echo "${message}"
fi

# one-liner if
[[ "$(whoami)" != 'root' ]] && echo "${message}"

# test keyword
test "$(whoami)" != 'root'  && echo "${message}"

exit 0

# What's the difference? http://mywiki.wooledge.org/BashFAQ/031
# Does it matter?
