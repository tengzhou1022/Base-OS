#!/bin/bash

# ----------------------------------------------------------------------
# Filename:   NetOps.sh
# Version:    1.0
# Date:       2016/03/28
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:    Network operations with systemctl or service
# Notes:      Include start_daemon stop_daemon restart_daemon status_daemon
# History：
#             Version 1.0, 2016/03/28
#             - add service functions, start_daemon, stop_daemon, restart_daemon, status_daemon
#             Version 1.1, 2016/03/28
#             - add CheckServiceExists
#             Version 1.2, 2016/03/28
#             - add SetService: set service status(start,restart,stop)
# ----------------------------------------------------------------------

##! @TODO: redirect rsh to /usr/bin/rsh
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
export RSH="/usr/bin/rsh"

##! @TODO: redirect rcp to /usr/bin/rcp
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
export RCP="/usr/bin/rcp"

#################################
#
# start, stop, restart service
#
#################################
if command -v systemctl >/dev/null 2>&1
then
    HAVE_SYSTEMCTL=1
else
    HAVE_SYSTEMCTL=0
fi

##! @TODO: Start the service
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
function StartDaemon()
{
        if [ $HAVE_SYSTEMCTL -eq 1 ]; then
                systemctl start $1.service > /dev/null 2>&1
        else
                service $1 start > /dev/null 2>&1
        fi

}

##! @TODO: Stop the service
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
function StopDaemon()
{
        if [ $HAVE_SYSTEMCTL -eq 1 ]; then
                systemctl stop $1.service > /dev/null 2>&1
        else
                service $1 stop > /dev/null 2>&1
        fi


}

##! @TODO: Get the status of the service
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
function StatusDaemon()
{
        if [ $HAVE_SYSTEMCTL -eq 1 ]; then
                systemctl status $1.service > /dev/null 2>&1
        else
                service $1 status > /dev/null 2>&1
        fi
}

##! @TODO: Restart the service
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
function RestartDaemon()
{
        if [ $HAVE_SYSTEMCTL -eq 1 ]; then
                systemctl restart $1.service > /dev/null 2>&1
        else
                service $1 restart > /dev/null 2>&1
        fi
}
##! @TODO:  force-reload the service
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
function Force-ReloadDaemon()
{
        if [ $HAVE_SYSTEMCTL -eq 1 ]; then
                systemctl  force-reload $1.service > /dev/null 2>&1
        else
                service $1 force-reload > /dev/null 2>&1
        fi
}

##! @TODO:  try-restart the service
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
function Try-RestartDaemon()
{
        if [ $HAVE_SYSTEMCTL -eq 1 ]; then
                systemctl  try-restart $1.service > /dev/null 2>&1
        else
                service $1 try-restart > /dev/null 2>&1
        fi
}

##! @TODO: Check Service file exists
##!
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @OUT: 0 => PASS; 1 => FAIL
function CheckServiceExists()
{
    local SERVFILE=""

    if [ $HAVE_SYSTEMCTL -eq 1 ]; then
        SERVFILE="/lib/systemd/system/$1.service"
    else
        SERVFILE="/etc/init.d/$1"
    fi

    if [ ! -f ${SERVFILE} ]; then
        echo "${SERVFILE} not exists, pls check"
        return 1
    fi

    unset SERVFILE

    return 0

}


##! @TODO: set service to expected status
##!        --Usage: SetService httpd start
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
function SetService()
{
    local SERVICE=$1
    local EXP_STATUS=$2

    StatusDaemon ${SERVICE}
    RE=$?
    case $RE in
        0)
          if [ ${EXP_STATUS} = "stop" ] || [ ${EXP_STATUS} = "3" ]; then
              StopDaemon ${SERVICE}
              sleep 3
              return $?
          elif [ ${EXP_STATUS} = "restart" ] || [ ${EXP_STATUS} = "0" ];then
              RestartDaemon ${SERVICE}
              return $?
          elif [ ${EXP_STATUS} = "start" ] || [ ${EXP_STATUS} = "0" ];then
              echo "${SERVICE} is started now"
              return 0
          else
              echo "${EXP_STATUS} is wrong, pls check"
              return 1
          fi
          ;;

        3)
          if [ ${EXP_STATUS} = "stop" ] || [ ${EXP_STATUS} = "3" ];then
              echo "${SERVICE} is stopped now"
              return 0
          elif [ ${EXP_STATUS} = "restart" ] || [ ${EXP_STATUS} = "0" ];then
              RestartDaemon ${SERVICE}
              return $?
          elif [ ${EXP_STATUS} = "start" ] || [ ${EXP_STATUS} = "0" ];then
              StartDaemon ${SERVICE}
              return $?
          else
              echo "${EXP_STATUS} is wrong, pls check"
              return 1
          fi
          ;;

        *)
          echo "check ${SERVICE} status"
          return $RE
          ;;

    esac
}
