#!/bin/bash

# ----------------------------------------------------------------------
# Filename:   Check.sh
# Version:    1.0
# Date:       2016/03/28
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:    Check the env or status of operations or scripts
# Notes:      Include CmdCheck, UserCheck, TimeoutCheck
# History：
#             Version 1.0, 2016/03/28
#             - add functions, CmdCheck, UserCheck, TimeoutCheck
# ----------------------------------------------------------------------


source "${SFROOT}/lib/Echo.sh"
#. ./Echo.sh
##! @TODO: Check the command exists or not
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @OUT:  return value.
function CmdCheck()
{
    local RC=0
    for cmd in $*; do
        if ! command -v $cmd >/dev/null 2>&1; then
            echo -e "\033[31m FAIL\033[0m | $cmd not exists, pls check"
            RC=$((RC+1))
        fi
    done
    return $RC
}

##! @TODO: Check the file or directory exists or not
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @OUT:  return value.
function CheckExists()
{
  if [ -z $1 ];then
    EchoResult "CheckExists called without parpameter"
    return 1
  fi
  local FILE="File"
  if [ -f $1 ] || [ -d $1 ];then
    EchoResult "$1 exists"
    return 0
  else
    EchoResult "$1 no exists"
    return 1
  fi
}

##! @TODO: Check the user exists or not
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @OUT:  return value.
function UserCheck()
{
    if id $1  >/dev/null 2>&1; then
        return 0
    else
        EchoInfo "user $1 not exists, pls check"
        return 1
    fi
}

##! @TODO: Launch the process and kill it when time is out.
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @OUT:  return value.
function TimeoutCheck()
{
    local PROCESS=$1
    local TIME_GAP=$2
    local COUNT=$3
    local RET=0
    if [ $# -eq 3 ]
    then
        $PROCESS &
        local PID=$!
        for ((i=0; i<$COUNT; i++))
        do
            if [ $i -eq 0 ]
            then
                sleep 2
            else
                sleep $TIME_GAP
            fi
            local FIND_PID=$(ps -p $PID | wc -l)
            if [ $FIND_PID -eq 1 ]
            then
                EchoInfo "The '${PROCESS}' exit normal."
                RET=0
                break
            elif [ $FIND_PID -eq 2 ]
            then
                if [ $i -eq $((COUNT - 1)) ]
                then
                    kill -9 $PID
                    RET=1
                    EchoInfo "The '${PROCESS}' run timeout."
                else
                    continue
                fi
            else
                RET=2
                break
            fi
        done
    else
        RET=1
    fi
    return $RET
}
