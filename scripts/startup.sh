#!/bin/bash
#
# The script starts/stops/restarts/statuses apps at boot/shutdown.
# Copy the script to /etc/init.d/<app>
#
############## FUNCTIONS ################################################

_start()
{
  _log "Starting ${app}"
  cd ${appdir}
  ${startscript} 1>>${logfile} 2>&1 & retval=$?
  if [ "$?" = "0" ]
  then
    _log "Startup of ${app} ran"
    _debug "Startup of ${app} ran. Check the log: ${logfile}"
    retval=0
  else
    _log "Could not start ${app}"
    _error "Could not start ${app}"
    retval=1
  fi
}

_stop()
{
  _log "Stopping ${app}"
  _debug "Stopping ${app}"
  kill ${pid} && sleep 5 && $0 status && \
  kill ${pid} && sleep 5 && $0 status && \
  kill -HUP ${pid} && sleep 5 && $0 status && \
  kill -HUP ${pid} && sleep 5 && $0 status && \
  kill -TERM ${pid} && sleep 5 && $0 status && \
  kill -TERM ${pid} && sleep 5 && $0 status
  while ps -p $pid > /dev/null
  do
    _log "Waiting for ${app} (pid=${pid}) to finish."
    _debug "Waiting for ${app} (pid=${pid}) to finish."
    sleep 10
  done
  _log "Stopped ${app}"
  retval=0
}

_init_log() {
  local logs=${home}/logs
  local log_filename=${app}.log
  logfile=${logs}/${log_filename}
  local timestamp=$( date +%Y%m%d )
  [[ ! -d ${logs} ]] && mkdir $logs
  find $logs -name ${log_filename} -type f -size +512k | while read logfile
  do
    echo $logfile
    local newlogfile=$logfile.$timestamp
    cp $logfile $newlogfile
    cat /dev/null > $logfile
    gzip -f -9 $newlogfile
  done
  find $logs -name "${log_filename}*.gz" -type f -mtime 30 |xargs rm -f
}

_log(){
  echo "$(date): $@" >> ${logfile};
}

_debug() {
  echo -e 1>&2 "\033[32m-->" $@ "\033[0m"
}

_error() {
  echo -e 1>&2 "\033[31m-->" $@ "\033[0m"
}

_fatal() {
  echo -e 1>&2 "\033[31m-->" $@ "\033[0m"
  exit 1
}

################################################################################

host=$( hostname )
user=$( whoami )
app=$( basename $0 )
eval home=~${user}
home=$( echo $home | sed 's/\/*$//g' ) # trim trailing slash if it exists

_init_log

app_home=${home}/${app}
appdir=${app_home}
startscript=${appdir}/bin/${app}
app_and_version=$( readlink $app_home ) # trim trailing slash if it exists

pid=$( ps -ea -o "pid ppid args" | grep -v grep | grep "8080" | sed -e 's/^  *//' -e 's/ .*//' | head -1 )

case $1 in
  start)
    if [ "${pid}" != "" ]
    then
      _error "${app_and_version} is allready running (pid=${pid})"
      retval=0
    else
      _start
    fi
    ;;
  stop)
    if [ "${pid}" != "" ]
    then
      _stop
    else
      _error "${app_and_version} is not running"
      retval=0
    fi
    ;;
  restart)
    if [ "${pid}" != "" ]
    then
      _stop
    else
      _error "${app_and_version} is not running"
    fi
    _start
    retval=0
    ;;
  status)
    kill -0 ${pid} >/dev/null 2>&1
    if [ "$?" = "0" ]
    then
      _debug "${app_and_version} (pid ${pid}) is running"
      retval=0
    else
      _error "${app_and_version} is not running"
      retval=3
    fi
    ;;
  *)
    _debug "Usage: $0 { start | stop | restart | status }"
    exit 2
    ;;

esac
exit ${retval}
