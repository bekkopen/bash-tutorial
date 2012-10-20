#!/bin/bash
# Usage: deploy.sh <artifact> <version> 

artifact=$1
version=$2

wget https://nexus.bekk.no/${artifact}/${version}/${artifact}-${version}.zip

unzip ${artifact}.zip

/etc/init.d/${artifact} stop

rm ${artifact} # softlink

ln -s ${artifact}-${version} ${artifact}

/etc/init.d/${artifact} start

/etc/init.d/${artifact} start
