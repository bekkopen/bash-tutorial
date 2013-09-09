#!/bin/bash

_ms()
{
 local S=${1}
 ((m=S%3600/60))
 ((s=S%60))
 printf "%dm:%ds" $m $s
}

_command_exists() {
    type "$1" &> /dev/null;
}

_contains() {
  local n=$#
  local value=${!n}
  for ((i=1;i < $#;i++)) ; do
    if [ "${!i}" == "${value}" ]; then
      return 0
    fi
  done
  return 1
}

_network_ip() {
  if ( _command_exists ipconfig ) ; then
    ipconfig getifaddr en1
  else
    ifconfig wlan0 | grep inet | head -1 | sed 's/\:/ /'| awk '{print $3}'
  fi
}

_port_is_taken() {
  lsof -i :$1 &> /dev/null;
}

_setUpSshTunnel() {
  local host=${1}
  local user=${2}
  local port=${3}
  local cmd="ssh -nNT -L ${port}:localhost:${port} ${user}@${host} &"
  [ ${debug} ] || eval ${cmd}
  [ ${debug} ] && echo 1 || echo $!
}

_getWebServerPort() {
  if ( _contains ${qa_and_prod_servers[@]} ${HOSTNAME} ); then
    echo 80
  elif ( _contains ${test_environments[@]} ${HOSTNAME} ); then
    echo 81
  else
    echo UNDEFINED
  fi
}

_check_health() {
  local cmd="curl http://${HOSTNAME}${server_suffix}:$( _getWebServerPort )/status.html 2>/dev/null | grep online"
  test "${debug}" == "true" && echo ${cmd} || eval ${cmd}
  return $?
}

_run() {
  local cmd=${1}
  _info "Running: ${cmd}"
  test "${debug}" == "true" && echo ${cmd} || eval ${cmd}
  if [ $? -ne 0 ]; then
    _fatal "${cmd} failed! Please retry the command manually."
  fi
}

_run_ssh() {
  local -a targets=( "${!1}" )
  local cmd=${2}
  
  test "${debug}" == "true" && declare -a debug_cmds
  for target in ${targets[@]}
  do
    local server=${target}${server_suffix}
    local remote_cmd="ssh -tt ${server} \"${cmd}\""
    _info "Running: ${remote_cmd}"
    test "${debug}" == "true" && debug_cmds+=( "${remote_cmd}" ) || eval ${remote_cmd}
    if [ $? -ne 0 ]; then
      _fatal "${remote_cmd} failed! Please retry the command(s) on the remote server(s)."
    fi
  done
  test "${debug}" == "true" && echo "${debug_cmds[@]}"
}

_upload_files_to_hosts() {
  local -a targets=( "${!1}" )
  local -a files=( "${!2}" )
  _info "Uploading ${files[@]} to ${targets[@]}"
  local host=${targets[0]}
  _run "scp ${files[@]} ${host}:"
  if [ ${#targets[@]} -gt 1 ]; then
    for f in ${files[@]}
      do 
        local filesNoPath+="$(basename ${f}) "
      done
      local proxyHost=( "${targets[0]}" )
      total=${#targets[*]}
      for (( i=1; i<=$(( $total -1 )); i++ ))
      do
        _run_ssh proxyHost[@] "scp ${filesNoPath} ${targets[$i]}: "
      done
    fi
}

_controlServers() {
  local -a targets=( "${!1}" )
  local -a artifacts=( "${!2}" )
  local control=${3}
 
  case ${control} in
    restart ) _info "Restarting ${artifacts[@]} on ${targets[@]}";;
    start ) _info "Starting ${artifacts[@]} on ${targets[@]}";;
    stop ) _info "Stopping ${artifacts[@]} on ${targets[@]}";;
    status ) _info "Checking status of ${artifacts[@]} on ${targets[@]}";;
    * ) _fatal "Illegal argument ${control}";;
  esac
 
  local cmds
  for artifact in ${artifacts[@]}
  do
    cmds+="/etc/init.d/${artifact} ${control} ; "
  done
  local cmd=$( echo ${cmds} | sed 's/ ;$//g' )
  local -a remote_targets
  for target in ${targets[@]}
  do
    if ( ! _contains ${valid_environments_and_servers[@]} ${target} ); then
      _fatal "Illegal target ${target}"
    fi
    if [ "${target}" == "${HOSTNAME}" ]; then
      _info "Running: ${cmd}"
      test "${debug}" == "true" && echo ${cmd} || eval ${cmd}
      if [ $? -ne 0 ] ; then
        _fatal "$cmd failed! Please retry the command manually."
      fi
    else
      remote_targets+=( "${target}" )
    fi
  done

  if [ ${#remote_targets[@]} -gt 0 ]; then
      _run_ssh remote_targets[@] "${cmd}"
  fi
}

_stopServers() {
  local -a targets=( "${!1}" )
  local -a artifacts=( "${!2}" )
  _controlServers targets[@] artifacts[@] "stop"
}

_startServers() {
  local -a targets=( "${!1}" )
  local -a artifacts=( "${!2}" )
  _controlServers targets[@] artifacts[@] "start"
}

_restartServers() {
  local -a targets=( "${!1}" )
  local -a artifacts=( "${!2}" )
  _controlServers targets[@] artifacts[@] "restart"
}

_stopServer() {
  local -a targets=( "${1}" )
  local -a artifacts=( "${2}" )
  _controlServers targets[@] artifacts[@] "stop"
}

_startServer() {
  local -a targets=( "${1}" )
  local -a artifacts=( "${2}" )
  _controlServers targets[@] artifacts[@] "start"
}

_restartServer() {
  local -a targets=( "${1}" )
  local -a artifacts=( "${2}" )
  _controlServers targets[@] artifacts[@] "restart"
}

_upload_file() {
  local server=${1}
  local file="${2}"
  local target="${3}"
  if [ -f ${file} ]; then
    _info "Uploading ${file} to ${server}:${target}"
    local cmd="scp ${file} ${server}:${target}"
    eval $cmd
    if [ $? -ne 0 ]; then
      _error "${cmd} failed! Please retry the command manually."
      exit 2
    fi
  else
    _error "File ${file} not found!"
    exit 2
  fi
}

_is_snapshot() {
 [[ "${1}" =~ ^[0-9]+(\.[0-9]+)+-SNAPSHOT$ ]] && return 0 || return 1
}

_is_release() {
    [[ "${1}" =~ ^[0-9]+(\.[0-9]+)+$ ]] && return 0 || return 1
}

_is_valid_version() {
  if ( _is_snapshot "${1}" ); then
    return 0
  elif ( _is_release "${1}" ); then
    return 0
  fi
  return 1
}

_find_version_from_pom() {
  echo $( grep -E "<version>[0-9]+(\.[0-9]+)+(-SNAPSHOT)?</version>" ${1} -m1 | sed 's/.*<version>\(.*\)<\/version>/\1/' )
}

_delete() {
   if [ -d "${1}" ]; then
      rm -Rf "${1}"
   elif [ -f "${1}" ]; then
      rm -f "${1}"
   else
      _error "The directory or file does not exist. Nothing to delete: ${1}"
   fi
   return 0
}

_backup() {
   if [ -z "${backup_dir}" ]; then
     _error "The variable backup_dir must be set before you can back up files and/or directories"
     exit 2
   fi
   
   if [ ! -d "${backup_dir}" ]; then
     mkdir "${backup_dir}"
   fi
   
   _info "Backing up "${1}" to ${backup_dir}"
   if [ -d "${1}" ]; then
      cp -Rf "${1}" "${backup_dir}"
   elif [ -f "${1}" ]; then
      cp -f "${1}" "${backup_dir}"
   else
      _error "The directory or file does not exist. Nothing to back up: ${1}"
   fi
   return 0
}

_wget_check_existence() {
  local wget ="wget -q --spider ${2}/${1}"
  _info "Running: ${wget}"
  eval $wget
  return $?
}

_set_no_proxy() {
  if [ ${no_proxy} ]; then
    export no_proxy=${no_proxy},${1}
  else
    export no_proxy=${1}
  fi
}

_get_nexus_repo(){
  if ( _is_snapshot "${1}" ); then
    echo "snapshots"
  elif ( _is_release "${1}" ); then
    echo "releases"
  else
    echo "UNDEFINED"
    return 1
  fi
}

