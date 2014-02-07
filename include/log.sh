#!/bin/bash

_debug() {
  echo -e 1>&2 "\033[34m-->" $@ "\033[0m"
}

_info() {
  echo -e 1>&2 "\033[32m-->" $@ "\033[0m"
}

_error() {
  echo -e 1>&2 "\033[31m-->" $@ "\033[0m"
}

_happy() {
  echo -e 1>&2 "\033[36m-->" $@ "\033[0m"
}

_fatal() {
  echo -e 1>&2 "\033[31m-->" $@ "\033[0m"
  exit 2
}

_happyQuit() {
  echo -e 1>&2 "\033[36m-->" $@ "\033[0m"
  exit 0
}

_log_date() {
  year=$(date +"%Y")
  month=$(date +"%m")
  day=$(date +"%d")
  echo ${year}-${month}-${day}
}

_init_log() {
  local timestamp=`date +%Y%m%d`
  logs="${1}"
  log_filename="${2}"
  if [ ! -d ${logs} ]; then
    mkdir $logs
  fi
  find $logs -name ${log_filename} -type f -size +8k | while read logfile
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
  local date_stamp=`date`
  local text="${1} ${2}"
  echo ${date_stamp}: ${text} >> $logs/$log_filename;
}
