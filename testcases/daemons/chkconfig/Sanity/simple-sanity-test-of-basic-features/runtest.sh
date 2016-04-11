#!/bin/bash
# ----------------------------------------------------------------------
# Filename:   runtest.sh
# Version:    1.0
# Date:       2016/03/30
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:     daemons/sudo chkconfig/Sanity/simple-sanity-test-of-basic-features
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
. ${SFROOT}/lib/RunCmd.sh
. ${SFROOT}/lib/Check.sh

function CleanData()
{
  RunCmd "popd"
  RunCmd "sudo rm -r $TmpDir" 0 "Removing tmp directory"
  EchoInfo "test daemons/sudo chkconfig/Sanity/simple-sanity-test-of-basic-features finish"
}
trap "CleanData" EXIT INT

function do_setup()
{
  #sudo apt-get -y install
  RunCmd "TmpDir=\`mktemp -d\`" 0 "Creating tmp directory"
  RunCmd "pushd $TmpDir"


}

function do_test()
{
  RunCmd "sudo chkconfig --list ssh | egrep '^ssh'" 0 'ssh must be in services, if not, then bellow tests are without sense'
  RunCmd "sudo chkconfig --level 0123456 ssh off" 0 "disable ssh from all runlevels"
  RunCmd "sudo chkconfig --list ssh | grep on" 1 "there shouldn't be any ssh in on state"
  RunCmd "sudo chkconfig --level 12345 ssh on" 0 "enable ssh as default in 2345 runlevels"
  RunCmd "sudo chkconfig --list ssh|grep '0:off'"
  #RunCmd "ls /etc/rc0.d/*ssh* |egrep 'K[0-9]+ssh'"
  RunCmd "sudo chkconfig --list ssh|grep '1:on'"
  RunCmd "ls /etc/rc1.d/*ssh* |egrep 'S[0-9]+ssh'"
  RunCmd "sudo chkconfig --list ssh|grep '2:on'"
  RunCmd "ls /etc/rc2.d/*ssh* |egrep 'S[0-9]+ssh'"
  RunCmd "sudo chkconfig --list ssh|grep '3:on'"
  RunCmd "ls /etc/rc3.d/*ssh* |egrep 'S[0-9]+ssh'"
  RunCmd "sudo chkconfig --list ssh|grep '4:on'"
  RunCmd "ls /etc/rc4.d/*ssh* |egrep 'S[0-9]+ssh'"
  RunCmd "sudo chkconfig --list ssh|grep '5:on'"
  RunCmd "ls /etc/rc5.d/*ssh* |egrep 'S[0-9]+ssh'"
  RunCmd "sudo chkconfig --list ssh|grep '6:off'"
  RunCmd "ls /etc/rc6.d/*ssh* |egrep 'K[0-9]+ssh'"

}
do_setup
do_test
