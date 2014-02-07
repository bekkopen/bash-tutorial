#!/bin/bash
# Usage: rollback.sh <artifact> <version> 

if [ $# -lt 2 ]; then
  echo "Usage: $0 <artifact> <version>"
  exit 1
fi

artifact=$1
version=$2

cd ~/

/etc/init.d/${artifact} stop

ln -nsf ${artifact}-${version} ${artifact}

/etc/init.d/${artifact} start

