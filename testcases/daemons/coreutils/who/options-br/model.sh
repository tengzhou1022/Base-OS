#!/bin/bash
# ----------------------------------------------------------------------
# Filename:   runtest.sh
# Version:    1.0
# Date:       2016/03/30
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:    daemons/coreutils/who/options-br
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

. ${SFROOT}/lib/Echo.#!/bin/sh
. ${SFROOT}/lib/RunCmd.sh
. ${SFROOT}/lib/Check.sh

function CleanData()
{
  RunCmd "popd"
  RunCmd "sudo rm -r $TmpDir" 0 "Removing tmp directory"
  EchoInfo "test daemons/coreutils/who/options-br finish"
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
  RunCmd "who -b > `mktemp $TmpDir/tmp.XXXXXXXX`" 0 ""
  RunCmd
}
do_setup
do_test
