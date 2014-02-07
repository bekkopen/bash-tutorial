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

echo "* * * Testing contains * * *"

$( _contains ${prod_servers[@]} "node1" )
_assertEquals 0 $? "Test: _contains \${prod_servers[@]} \"welfare\""

$( _contains ${prod_servers[@]} "jibberish" )
_assertEquals 1 $? "Test: _contains \${prod_servers[@]} \"jibberish\""

exit 0
