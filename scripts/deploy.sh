#!/bin/bash
# Usage: deploy.sh <artifact> <version> 

if [ $# -lt 2 ]; then
  echo "Usage: $0 <artifact> <version>"
  exit 1
fi

artifact=${1}
version=${2}

#wget https://nexus.bekk.no/${artifact}/${version}/${artifact}-${version}.zip
cp scripts/startup.sh /etc/init.d/${artifact}
cp target/${artifact}-${version}.zip ~/  

cd ~/

unzip -o ${artifact}-${version}.zip

/etc/init.d/${artifact} stop

rm ${artifact} # softlink

ln -s ${artifact}-${version} ${artifact}

/etc/init.d/${artifact} start

while ( ! curl http://localhost:8000/status.html 2>/dev/null | grep online )
do
  echo "Waiting for web-app to come online."
  sleep 2
done
