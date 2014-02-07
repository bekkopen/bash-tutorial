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

echo "* * * Testing _check_health * * *"
debug="true"

val=$( _check_health ${server} )
_assertTrue $? "Test: _check_health when hostname is not a qa- or prod-server ( ${HOSTNAME} )"
#_assertEquals 0 $? "Test: _check_health when hostname is not a qa- or prod-server ( ${HOSTNAME} )"

HOSTNAME="node1"
expected="curl http://${HOSTNAME}${server_suffix}:80/status.html 2>/dev/null | grep online"
val=$( _check_health ${server} 2> /dev/null )
_assertEquals 0 $?
_assertEquals "${expected}" "${val}" "Test: _check_health when hostname is ${HOSTNAME} )"

HOSTNAME="test"
expected="curl http://${HOSTNAME}${server_suffix}:81/status.html 2>/dev/null | grep online"
val=$( _check_health ${server} 2> /dev/null )
_assertEquals 0 $?
_assertEquals "${expected}" "${val}" "Test: _check_health when hostname is ${HOSTNAME} )"

HOSTNAME="unknown"
expected="curl http://${HOSTNAME}${server_suffix}:UNDEFINED/status.html 2>/dev/null | grep online"
val=$( _check_health ${server} 2> /dev/null )
_assertEquals 0 $?
_assertEquals "${expected}" "${val}" "Test: _check_health when hostname is ${HOSTNAME} )"

. ../include/includes.sh
. ../bashUnit/asserts.sh

exit 0
