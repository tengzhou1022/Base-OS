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
  local command=$1
  echo $command
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
}
