HOSTNAME=$( hostname )
USER=$( whoami )

prod_servers=( "node1" "node2" "node3" "node4" )
qa_servers=( "qa1" "qa2" "qa3" )
qa_and_prod_servers=( ${prod_servers[@]} ${qa_servers[@]} )
test_environments=( "dev" "test" "acceptance" )
valid_environments_and_servers=( ${qa_and_prod_servers[@]} ${test_environments[@]} "prod" "qa" "bogus" ) # bogus is just for testing purposes
 
candidate_artifacts=( "webapp" "batchapp" )

server_suffix=".open.bekk.no"

# Group Id for Maven artifacts
GROUP_ID=no.bekk.open

# Nexus
NEXUS_SERVER=localhost${server_suffix}
NEXUS_API="http://${NEXUS_SERVER}/nexus/service/local/artifact/maven/redirect"
