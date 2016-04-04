#!/bin/bash

# ----------------------------------------------------------------------
# Filename:   Check.sh
# Version:    1.0
# Date:       2016/03/28
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:    Check the env or status of operations or scripts
# Notes:
# History：
#             Version 1.0, 2016/03/28
#             - add debCheck,
# ----------------------------------------------------------------------
. ./Echo.sh

function DebSearch()
##! @TODO: search the deb exists or not
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @OUT:  return value.
{
  local RC=0
  apt-get update >/dev/null 2>&1
  EchoResult  "update fail "

  for debPackage in $*; do
        if  ! apt-cache show $debPackage >/dev/null 2>&1; then
            echo -e "\033[31m FAIL   \033[0m | Package $debPackage not exists, pls "
            RC=$((RC+1))
          else
            echo -e "\033[32m SUCCESS\033[0m | Package $debPackage is exists"
        fi
    done
    return $RC

}


function DebInstall()
##! @TODO: Check the deb exists or not
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @OUT:  return value.
{
  local RC=0
##
#  apt-get update >/dev/null 2>&1
#  if [ $? -ne 0 ];then
#    echo -e  "\033[31m FAIL   \033[0m| update source faild , pls check."
#  else
#    echo -e  "\033[32m SUCCESS\033[0m| update source success."
#  fi
  for debPackage in $*; do
        if ! dpkg-query -l $debPackage >/dev/null 2>&1; then
              EchoResult  "$debPackage not exists, pls check whether the package is written or not."
            if ! apt-get -f install $debPackage >/dev/null 2>&1 ;then
              echo -e "\033[31m FAIL   \033[0m| $debPackage install fail"
            else
              echo -e "\033[32m SUCCESS\033[0m| $debPackage install success"
            fi
            RC=$((RC+1))
        fi
    done
    return $RC
}
DebInstall at
