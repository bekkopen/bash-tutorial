#!/bin/bash

_info() {
  echo -e 1>&2 "\033[32m-->" $@ "\033[0m"
}

_debug() {
  echo -e 1>&2 "\033[34m-->" $@ "\033[0m"
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
  logs="${1}"
  log_filename="${2}"
  if [ ! -d ${logs} ]; then
    mkdir $logs
  fi
}

_log(){
  local timestamp=`date +%Y%m%d`
  local date_stamp=`date`
  local text="${1} ${2}"
  echo ${date_stamp}: ${text} >> $logs/$log_filename;
  find $logs -name ${log_filename}*.log -type f -size +512k | while read logfile
  do
    local newlogfile=$logs/$log_filename.$timestamp
    count=1
    while [ -e $newlogfile.$count.gz ] || [ -e $newlogfile.gz ]; do
      count=$count+1
      newlogfile=$newlogfile.$count
    done
    cp $logfile $newlogfile
    cat /dev/null > $logfile
    gzip -f -9 $newlogfile
  done
  find $logs -name "${log_filename}*.gz" -type f -mtime 30 |xargs rm -f
}
