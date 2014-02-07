#!/bin/bash

BASEDIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

# resolve symlinks
while [ -h "$BASEDIR/$0" ]; do
    DIR=$(dirname -- "$BASEDIR/$0")
    SYM=$(readlink $BASEDIR/$0)
    BASEDIR=$(cd $DIR && cd $(dirname -- "$SYM") && pwd)
done
cd ${BASEDIR}

. ../include/log.sh

_debug "Logging with _debug"

_info "Logging with _info"

_error "Logging with _error"

_happy "Logging with _happy"

#_fatal "Logging with _fatal end exiting with return status larger than 0"

_happyQuit "Logging with _happyQuit end exiting with return status 0"

