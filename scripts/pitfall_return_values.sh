#!/bin/bash

_combine_strings() {
  local string1=${1}
  local string2=${2}

  #echo "debug: string1 is ${string1} and string2 is ${string2}"
  debug_combine_strings="debug: string1 is ${string1} and string2 is ${string2}"
  #echo "${debug_combine_strings}"

  echo ${string1}${string2}
}

combined_strings=$( eval _combine_strings "Hello " "World" )

echo "${debug_combine_strings}"
echo "The combined string is: ${combined_strings}"

