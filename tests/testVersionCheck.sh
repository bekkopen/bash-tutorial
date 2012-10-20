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

echo "* * * Testing versionCheck * * *"
$( _is_snapshot 1,3 )
_assertEquals 1 $? "Test: _is_snapshot 1,3"
$( _is_snapshot 1.3 )
_assertEquals 1 $? "Test: _is_snapshot 1.3"
$( _is_snapshot 3.25-SNAPSHOT )
_assertEquals 0 $? "Test: _is_snapshot 3.25-SNAPSHOT"
$( _is_snapshot 3.25.99-SNAPSHOT )
_assertEquals 0 $? "Test: _is_snapshot 3.25.99-SNAPSHOT"
$( _is_snapshot 99.99-SNAPSHOT )
_assertEquals 0 $? "Test: _is_snapshot 99.99-SNAPSHOT"
$( _is_snapshot 100.100-SNAPSHOT )
_assertEquals 0 $? "Test: _is_snapshot 100.100-SNAPSHOT"
$( _is_snapshot rollback )
_assertEquals 1 $? "Test: _is_snapshot rollback"

$( _is_release 1,3 )
_assertEquals 1 $? "Test: _is_release 1,3"
$( _is_release version=1.3 )
_assertEquals 1 $? "Test: _is_release 1.3"
$( _is_release version=3.25-SNAPSHOT )
_assertEquals 1 $? "Test: _is_release 3.25-SNAPSHOT"
$( _is_release version=99.99 )
_assertEquals 1 $? "Test: _is_release 99.99"
$( _is_release version=99.99.1 )
_assertEquals 1 $? "Test: _is_release 99.99.1"
$( _is_release version=100.100 )
_assertEquals 1 $? "Test: _is_release 100.100"
$( _is_release version=rollback )
_assertEquals 1 $? "Test: _is_release rollback"

$( _is_valid_version 1,3 )
_assertEquals 1 $? "Test: _is_valid_version 1,3"
$( _is_valid_version 1.3 )
_assertEquals 0 $? "Test: _is_valid_version 1.3"
$( _is_valid_version 3.25-SNAPSHOT )
_assertEquals 0 $? "Test: _is_valid_version 3.25-SNAPSHOT"
$( _is_valid_version 99.99 )
_assertEquals 0 $? "Test: _is_valid_version 99.99"
$( _is_valid_version 100.100-SNAPSHOT )
_assertEquals 0 $? "Test: _is_valid_version 100.100-SNAPSHOT"
$( _is_valid_version 100.100.100.100-SNAPSHOT )
_assertEquals 0 $? "Test: _is_valid_version 100.100.100.100-SNAPSHOT"
$( _is_valid_version rollback )
_assertEquals 1 $? "Test: _is_valid_version rollback"

exit 0
