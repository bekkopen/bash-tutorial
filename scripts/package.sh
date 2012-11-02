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

[[ "clean" == "${1}" ]] && eval "cd .. ; rm -rf target/* ; exit 0"

if [ $# -lt 2 ]; then
  _fatal "Usage: $0 <artifact> <version>"
fi

cd ..

artifact=${1}
version=${2}

target="target/${artifact}-${version}"

[[ -d target ]] && rm -rf target
[[ -d ${target} ]] && rm -rf ${target}
mkdir -p ${target}

cp -R ${artifact}/* ${target} || _fatal "Unknown artifact ${artifact}"

cd target

zip -rqq ${artifact}-${version}.zip * 

_happyQuit "Created ${artifact}-${version}.zip"
