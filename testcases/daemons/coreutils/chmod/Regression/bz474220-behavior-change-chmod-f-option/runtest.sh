#!/bin/bash
# ----------------------------------------------------------------------
# Filename:   runtest.sh
# Version:    1.0
# Date:       2016/03/30
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:    daemons/coreutils/chmod/Regression/bz474220-behavior-change-chmod-f-option
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
. ${SFROOT}/lib/UserOps.sh

function CleanData()
{
  DelUser $TESTUSER
  RunCmd "popd"
  RunCmd "sudo rm -r $TmpDir" 0 "Removing tmp directory"
  EchoInfo "test daemons/coreutils/chmod/Regression/bz474220-behavior-change-chmod-f-option finish"
}
trap "CleanData" EXIT INT

function do_setup()
{
  AddUser $TESTUSER
  RunCmd "TmpDir=\`mktemp -d\`" 0 "Creating tmp directory"
  RunCmd "pushd $TmpDir"
}

function do_test()
{
  EchoInfo "===chown/chgrp test -f, --silent, --quiet  suppress most error messages==="
  #test chown -f
  sudo chown -f  $TESTUSER nonexistent-file-$RANDOM &> output-x
  RunCmd "cat $TmpDir/output-x | wc -l | grep 0" 0 "is output really empty?"
  #test chgrp -f
  sudo chown -f  $TESTUSER nonexistent-file-$RANDOM &> output-y
  RunCmd "cat $TmpDir/output-y | wc -l | grep 0" 0 "is output really empty?"
}
TESTUSER="test"

do_setup
do_test
