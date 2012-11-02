#!/bin/bash

BASEDIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

# resolve symlinks
while [ -h "$BASEDIR/$0" ]; do
    DIR=$(dirname -- "$BASEDIR/$0")
    SYM=$(readlink $BASEDIR/$0)
    BASEDIR=$(cd $DIR && cd $(dirname -- "$SYM") && pwd)
done
cd ${BASEDIR}

_combine_strings() {
  local string1=${1}
  local string2=${2}

  #echo "debug: string1 is ${string1} and string2 is ${string2}"

  echo ${string1}${string2}
}

combined_strings=$( _combine_strings "Hello " "World" )

echo "The combined string is: ${combined_strings}"

