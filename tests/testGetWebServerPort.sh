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

echo "* * * Testing _getWebServerPort * * *"

expected="UNDEFINED"
val=$( _getWebServerPort )
_assertEquals ${expected} ${val} "Test: _getWebServerPort when hostname is not a valid environment"

HOSTNAME="node1"
expected="80"
val=$( _getWebServerPort )
_assertEquals ${expected} ${val} "Test: _getWebServerPort when server is production server (${HOSTNAME})"

HOSTNAME="test"
expected="81"
val=$( _getWebServerPort )
_assertEquals ${expected} ${val} "Test: _getWebServerPort when server is testserver (${HOSTNAME})"

. ../include/includes.sh
. ../bashUnit/asserts.sh


exit 0
