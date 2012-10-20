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

echo "* * * Testing runSsh * * *"

debug="true"

cmd="echo Hello ; echo World"
expected="ssh -tt node1.open.bekk.no \"echo Hello ; echo World\" ssh -tt node2.open.bekk.no \"echo Hello ; echo World\" ssh -tt node3.open.bekk.no \"echo Hello ; echo World\" ssh -tt node4.open.bekk.no \"echo Hello ; echo World\""
val=$( _run_ssh prod_servers[@] "${cmd}" 2> /dev/null ) && retval=$? || retval=$? && [[ "${val}" == "${expected}" ]] && _info "test passed! (retval=${retval})" || _fatal "test failed! Expected \"$expected\" but was \"$val\" (retval=${retval})"

exit 0
