#!/bin/bash

declare -a debug_stmts

_combine_strings() {

  local string1=${1}
  local string2=${2}

  #echo "debug: string1 is ${string1} and string2 is ${string2}"
  debug_stmts=( "debug: string1 is ${string1} and string2 is ${string2}" )

  echo ${string1}${string2}
}

combined_string=$( _combine_strings "Hello " "World" )

echo ${debug_stmts[@]}
echo "The combined string is: ${combined_string}"

