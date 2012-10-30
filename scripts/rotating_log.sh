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

logdir="../logs"
logfile="mylog.log"
_init_log "${logdir}" "${logfile}"

_log "Logging to ${logdir}/${logfile}"
_log "Logging to the ${logdir}/${logfile} again"

while [ 9 -gt $(du -k ${logdir}/${logfile} | cut -c1) ]; do
  _log "Lorem ipsum dolor sit amet, consectetur adipisicing elit, \
        sed do eiusmod tempor incididunt ut labore et dolore magna \
        aliqua. Ut enim ad minim veniam, quis nostrud exercitation \
        ullamco laboris nisi ut aliquip ex ea commodo consequat. \
        Duis aute irure dolor in reprehenderit in voluptate velit \
        esse cillum dolore eu fugiat nulla pariatur. Excepteur sint \
        occaecat cupidatat non proident, sunt in culpa qui officia \
        deserunt mollit anim id est laborum."
done

# To change the timestamp of the file type touch -t 201205101024 logs/mylog*.gz

_happyQuit "Done :)"
