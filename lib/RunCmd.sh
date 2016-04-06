#!/bin/bash

# ----------------------------------------------------------------------
# Filename:   RunCmd.sh
# Version:    1.0
# Date:       2016/03/28
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:
# Notes:
# History：
#             Version 1.0, 2016/03/28
# ----------------------------------------------------------------------

##! @TODO: Run  command [status[,status...]] [comment]
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @OUT: 0 => PASS; 1 => FAIL
. ${SFROOT}/lib/Echo.sh
#. ./Echo.sh
function RunCmd()
{
  GETOPT=$(getopt -q -o t -- "$@")
  eval set -- "$GETOPT"

  local DO_TAG=false
  local TAG_OUT=''
  local TAG_ERR=''
  RunCmd_LOG_FILE=''

  while true ; do
        case "$1" in
            -t)
                DO_TAG=true;
                TAG_OUT='STDOUT: '
                TAG_ERR='STDERR: '
                shift;;
            --)
                shift;
                break;;
            *)
                shift;;
        esac
    done

  local command=$1

  if [[ -z "$3" ]];then
    comment="Running '$command'"
  else
    comment="$3"
  fi

  # here we can do various sanity checks of the $command
  if [[ "$command" =~ ^[[:space:]]*$ ]] ; then
      EchoInfo "RunCmd: got empty or blank command '$command'!"
      return 1
  fi

  if $DO_TAG ;then
    RunCmd_LOG_FILE=$(mktemp)
    eval "$command"  2> >(sed -u -e "s/^/$TAG_ERR/g" |
        tee -a $RunCmd_LOG_FILE) 1> >(sed -u -e "s/^/$TAG_OUT/g" | tee -a $RunCmd_LOG_FILE)
    EchoInfo "test $1, and the logfile is $RunCmd_LOG_FILE"
  else
    #eval $command >/dev/ 2>&1
    if [[ -z $2 ]];then
      eval $command >/dev/null 2>&1
      if [ $? -eq 0 ];then
        EchoResult "$comment success"
      else
        EchoResult "$comment failed, pls check"
      fi
    else
        eval $command >/dev/null 2>&1
        local RESULT="$?"
        if [ $RESULT -eq $2 ];then
          EchoResult  "$comment success"
        else
          EchoResult  "$comment failed,pls check"
        fi
    fi
  fi
}
