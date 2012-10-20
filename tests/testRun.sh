#!/bin/bash
BASEDIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

# resolve symlinks
while [ -h "$BASEDIR/$0" ]; do
    DIR=$(dirname -- "$BASEDIR/$0")
    SYM=$(readlink $BASEDIR/$0)
    BASEDIR=$(cd $DIR && cd $(dirname -- "$SYM") && pwd)
done
cd ${BASEDIR}

. ../include/includes.sh
. ../bashUnit/asserts.sh

echo "* * * Testing run * * *"

expected="Hello World"
args="echo Hello World"
val=$( _run "${args}" 2> /dev/null ) && retval=$? || retval=$? && [[ ${val} == ${expected} ]] && _info "test passed! (retval=${retval})" || _fatal "test failed! Expected \"$expected\" but was \"$val\" (retval=${retval})"
expected=$( _fatal "jibberish ;  failed!" )
args="jibberish"
val=$( _run "${args}" 2> /dev/null ) || retval=$? && [[ $val == $expected ]] && _info "test passed! (retval=${retval})" || _fatal "test failed! Expected \"$expected\" but was \"$val\" (retval=${retval})"
exit 0
