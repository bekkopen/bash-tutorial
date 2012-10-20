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

echo "* * * Testing controlServers * * *"

debug="true"

expected_retval=255
illegal_servers=( "bogus" )
$( _controlServers illegal_servers[@] candidate_artifacts[@] "start" 2> /dev/null )
_assertEquals ${expected_retval} $? "Test: _controlServers illegal_servers[@] candidate_artifacts[@] \"start\" where illegal_servers is \"${illegal_servers[@]}\""


expected_retval=2
illegal_servers=( "dill" "dall" ) 
$( _controlServers illegal_servers[@] candidate_artifacts[@] "start" 2> /dev/null )
_assertEquals ${expected_retval} $? "Test: _controlServers illegal_servers[@] candidate_artifacts[@] \"start\" where illegal_servers is \"${illegal_servers[@]}\""

expected_retval=2
$( _controlServers prod_servers[@] candidate_artifacts[@] "jibberish" 2> /dev/null )
_assertEquals ${expected_retval} $? "Test: _controlServers prod_servers[@] candidate_artifacts[@] \"jibberish\" where prod_servers is \"${prod_servers[@]}\""

expected="ssh -tt node1.open.bekk.no \"/etc/init.d/webapp stop ; /etc/init.d/batchapp stop\" ssh -tt node2.open.bekk.no \"/etc/init.d/webapp stop ; /etc/init.d/batchapp stop\" ssh -tt node3.open.bekk.no \"/etc/init.d/webapp stop ; /etc/init.d/batchapp stop\" ssh -tt node4.open.bekk.no \"/etc/init.d/webapp stop ; /etc/init.d/batchapp stop\""
val=$( _controlServers prod_servers[@] candidate_artifacts[@] "stop" 2> /dev/null )
expected_retval=0
_assertEquals ${expected_retval} $?
_assertEquals "${expected}" "${val}" "Test: _controlServers ${prod_servers[@]} ${candidate_artifacts[@]} \"stop\""

expected="ssh -tt node1.open.bekk.no \"/etc/init.d/webapp start ; /etc/init.d/batchapp start\" ssh -tt node2.open.bekk.no \"/etc/init.d/webapp start ; /etc/init.d/batchapp start\" ssh -tt node3.open.bekk.no \"/etc/init.d/webapp start ; /etc/init.d/batchapp start\" ssh -tt node4.open.bekk.no \"/etc/init.d/webapp start ; /etc/init.d/batchapp start\""
val=$( _controlServers prod_servers[@] candidate_artifacts[@] "start" 2> /dev/null )
expected_retval=0
_assertEquals ${expected_retval} $?
_assertEquals "${expected}" "${val}" "Test: _controlServers ${prod_servers[@]} ${candidate_artifacts[@]} \"start\""

expected="ssh -tt node1.open.bekk.no \"/etc/init.d/webapp restart ; /etc/init.d/batchapp restart\" ssh -tt node2.open.bekk.no \"/etc/init.d/webapp restart ; /etc/init.d/batchapp restart\" ssh -tt node3.open.bekk.no \"/etc/init.d/webapp restart ; /etc/init.d/batchapp restart\" ssh -tt node4.open.bekk.no \"/etc/init.d/webapp restart ; /etc/init.d/batchapp restart\""
val=$( _controlServers prod_servers[@] candidate_artifacts[@] "restart" 2> /dev/null )
expected_retval=0
_assertEquals ${expected_retval} $?
_assertEquals "${expected}" "${val}" "Test: _controlServers ${prod_servers[@]} ${candidate_artifacts[@]} \"restart\""

. ../include/includes.sh
. ../bashUnit/asserts.sh

exit 0

