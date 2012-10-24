#!/bin/bash
# Usage: deploy.sh <artifact> <version> 

if [ $# -lt 2 ]; then
  echo "Usage: $0 <artifact> <version>"
  exit 1
fi

artifact=${1}
version=${2}

#wget https://nexus.bekk.no/${artifact}/${version}/${artifact}-${version}.zip
cp ~/utvikling/bash-tutorial/scripts/startup.sh /etc/init.d/${artifact}
cp ~/utvikling/bash-tutorial/target/${artifact}-${version}.zip ~/  

cd ~/

unzip -o ${artifact}-${version}.zip

/etc/init.d/${artifact} stop

rm ${artifact} # softlink

ln -s ${artifact}-${version} ${artifact}

/etc/init.d/${artifact} start
