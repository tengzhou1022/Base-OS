#!/bin/bash
# ----------------------------------------------------------------------
# Filename:   runtest.sh
# Version:    1.0
# Date:       2016/03/30
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:    daemons/coreutils/chmod/bz474232_be_silent
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
  EchoInfo "test daemons/coreutils/chmod/bz474232_be_silent finish"
}
trap "CleanData" EXIT INT

function do_setup()
{
  RunCmd "TmpDir=\`mktemp -d\`" 0 "Creating tmp directory"
  RunCmd "pushd $TmpDir"
}

function do_test()
{
  EchoInfo "====Bug 474232===="
  sudo chmod -f 755 nonexistent-file-$RANDOM &> outputXY
  RunCmd "cat $TmpDir/outputXY | wc -l | grep 0" 0 "is output really empty?"
}
do_setup
do_test
