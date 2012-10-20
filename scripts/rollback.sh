#!/bin/bash
# Usage: rollback.sh <artifact> <version> 

artifact=$1
version=$2

/etc/init.d/${artifact} stop

rm ${artifact} # softlink

ln -s ${artifact}-${version} ${artifact}

/etc/init.d/${artifact} start
