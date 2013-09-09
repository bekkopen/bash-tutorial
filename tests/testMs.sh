#!/bin/bash

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

echo "* * * Testing conversion from seconds to minutes and seconds _ms * * *"
expected=10m:15s
val=$(_ms 615) && retval=$? || retval=$? && [ "${val}" == "${expected}" ] && _info "test passed! (retval=${retval})" || _fatal "test failed! Expected \"${expected}\" but was \"$val\" (retval=${retval})"
exit 0
