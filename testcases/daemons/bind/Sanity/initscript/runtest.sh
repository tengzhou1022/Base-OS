#!/bin/bash
# ----------------------------------------------------------------------
# Filename:   runtest.sh
# Version:    1.0
# Date:       2016/03/30
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:    daemons-at-Sanity-initscript
# Notes:       ***
# History：
#             Version 1.0, 2016/03/30
# ----------------------------------------------------------------------

# include lib files
if [ -z "$SFROOT" ]
then
    echo "SFROOT is null, pls check"
    exit 1
fi

. ${SFROOT}/lib/Echo.sh
. ${SFROOT}/lib/NetOps.sh
. ${SFROOT}/lib/RunCmd.sh

SERVICE=atd

function CleanData()
{
  #测试完成后恢复测试环境 此处待确认
  EchoInfo "test atd initscript finish."
}
trap "CleanData" EXIT INT

function do_setup()
{

  apt-get install -f at
  EchoResult "install at"
##stop atd service
  SetService $SERVICE stop
  EchoResult "service $SERVICE stop"
}


function do_start_test()
{
## test start
  EchoInfo "---test $SERVICE service start---"
##check atd service exists
  CheckServiceExists $SERVICE
  EchoResult "check atd service exists"
##start
  RunCmd "systemctl start $SERVICE" 0
  RunCmd "systemctl status $SERVICE" 0
##start
  RunCmd "systemctl start $SERVICE" 0
  RunCmd "systemctl status $SERVICE" 0
##restart
  RunCmd "systemctl restart $SERVICE" 0
  RunCmd "systemctl status $SERVICE" 0
##force-reload
  RunCmd "systemctl force-reload $SERVICE" 0
  RunCmd "systemctl status $SERVICE" 0
##try-restart 此处存在问题
#  RunCmd "systemctl try-restart $SERVICE" 0
#  RunCmd "systemctl status $SERVICE" 0
}

function do_stop_test()
{
##test stop
  EchoInfo "---test atd service stop---"
##stop
  RunCmd "systemctl stop $SERVICE" 0
  RunCmd "systemctl status $SERVICE" 3
##stop
  RunCmd "systemctl stop $SERVICE" 0
  RunCmd "systemctl status $SERVICE" 3
##try-restart
  RunCmd "systemctl try-restart $SERVICE" 0
  RunCmd "systemctl status $SERVICE" 3
}
function do_dead_test()
{
  EchoInfo "此项测试待确定与systemctl哪项功能类似"
}
function do_Invalid_arguments()
{
  EchoInfo "---test Invalid arguments---"
  RunCmd "systemctl $SERVICE" 1
  RunCmd "systemctl fubr $SERVICE" 1
}

do_setup
do_start_test
do_stop_test
do_dead_test
do_Invalid_arguments
