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

##! @TODO: checking for the existence of a file or a directory
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
  if [ -d $1 ];then
    FILE='Directory'
  fi
  if [ -e "$1" ];then
    EchoResult "$FILE $1 should exist"
  else
    EchoResult "$FILE $1 not exist"
  fi
}

##! @TODO: checking for the non-existence of a file or a directory
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @OUT:  return value.
function CheckNotExists()
{
  if [ -z $1 ];then
    EchoResult "CheckExists called without parpameter"
    return 1
  fi
  local FILE="File"
  if [ -d $1 ];then
    FILE='Directory'
  fi
  if [ ! -e "$1" ];then
    EchoResult "$FILE $1 should not exist"
  else
    EchoResult "$FILE $1 is exist"
  fi
}
##! @TODO: checking that the file contains a pattern
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @OUT:  return value.
function CheckGrep()
{
  if [ ! -e $2 ];then
    EchoResult "CheckNotGrep: failed find file $2"
    return 1
  fi
  local options=${3:--q}
  grep $options -- "$1" "$2"
  EchoResult "File '$2' should contain '$1'"
}

##! @TODO: checking that the file does not contain a pattern
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @OUT:
function CheckNotGrep()
{
  if [ ! -e $2 ];then
    EchoResult "CheckNotGrep: failed find file $2"
    return 1
  fi
  local options=${3:--q}
  ! grep $options -- "$1" "$2"
  EchoResult "File '$2' should not contain '$1'"
}

##! @TODO: checking that two files do not differ (are identical)
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @OUT:  return value.
function CheckDiffer()
{
  local file
  for file in "$1" "$2";
  do
    if [ ! -e "$file" ];then
      EchoResult "File $file was no found"
    fi
  done
  ! cmp -s "$1" "$2"
  EchoResult "Files $1 and $2 should not differ"
}

##! @TODO: checking that two files do not differ (are identical)
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @OUT:  return value.
function CheckNotDiffer()
{
  local file
  for file in "$1" "$2";
  do
    if [ ! -e "$file" ];then
      EchoResult "File $file was no found"
    fi
  done
  cmp -s "$1" "$2"
  EchoResult "Files $1 and $2 should not differ"
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
