#!/bin/bash

if [ "${version}" != "rollback" ] && [ ${#artifactsAndVersions[@]} -ne 0 ]; then
  if ( _contains ${targets[@]} ${host} ) || ( _is_snapshot ${deployVersion} ) ;     
  then
    deployFile="${M2_REPO}/no/bekkopen/myapp/deploy/${deployVersion}/deploy-${deployVersion}.zip"
    if [ ! -s "${deployFile}" ]; then
      echo "mkdir -p ${M2_REPO}/no/bekkopen/myapp/deploy/${deployVersion}/"
      if ( _is_snapshot ${deployVersion} ); then
        if [ -s ~/deploy-${deployVersion}.zip ]; then
          _debug "Found deploy-${deployVersion}.zip in homedir. Moving it to ${deployFile}."
        _run "echo ~/deploy-${deployVersion}.zip ${deployFile}"
        if [ ! -s ~/deploy-${deployVersion}.zip ]; then
          _fatal "You are trying to deploy a SNAPSHOT version, but it is not installed"
        fi
      else
        _fatal "Could not find deploy-${deployVersion}.zip at ${deployFile}."
      fi
      [[ -e ${deployFile} ]] || _fatal "${deployFile} not found locally or in Nexus! Exiting!"
    fi
    artifactFilesToUpload+=( "${deployFile}" )
  else
    installDeployCmds=( "wget -O deploy-${deployVersion}.zip ${NEXUS_URL}deploy-${deployVersion}.zip" )
  fi
fi

echo "end of script"

# Should produce:
# scripts/debugging_tougher_example.sh: line 31: syntax error: unexpected end of file
