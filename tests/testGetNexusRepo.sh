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

echo "* * * Testing _get_nexus_repo * * *"

expected="UNDEFINED"
val=$( _get_nexus_repo "" )
_assertEquals 1 $? "Test: _get_nexus_repo when empty version string is empty"
_assertEquals "${expected}" "${val}" "Test: _get_nexus_repo when version string is empty"

val=$( _get_nexus_repo "jibberish" )
_assertEquals 1 $? "Test: _get_nexus_repo when version string is \"jibberish\""
_assertEquals "${expected}" "${val}" "Test: _get_nexus_repo when version string is \"jibberish\""

expected="releases"
val=$( _get_nexus_repo "3.10" )
_assertEquals 0 $? "Test: _get_nexus_repo when version string is \"3.10\""
_assertEquals "${expected}" "${val}" "Test: _get_nexus_repo when version string is \"3.10\""

expected="snapshots"
val=$( _get_nexus_repo "3.10-SNAPSHOT" )
_assertEquals 0 $? "Test: _get_nexus_repo when version string is \"3.10-SNAPSHOT\""
_assertEquals "${expected}" "${val}" "Test: _get_nexus_repo when version string is \"3.10-SNAPSHOT\""


. ../include/includes.sh
. ../bashUnit/asserts.sh

exit 0
