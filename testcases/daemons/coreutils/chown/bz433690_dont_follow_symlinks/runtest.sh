#!/bin/bash
# ----------------------------------------------------------------------
# Filename:   runtest.sh
# Version:    1.0
# Date:       2016/03/30
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:    daemons/coreutils/chown/bz433690_dont_follow_symlinks
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
  EchoInfo "test daemons/coreutils/chown/bz433690_dont_follow_symlinks finish"
}
trap "CleanData" EXIT INT

function do_setup()
{
  #sudo apt-get -y install
  RunCmd "TmpDir=\`mktemp -d\`" 0 "Creating tmp directory"
  RunCmd "pushd $TmpDir"
  RunCmd "mkdir -p pig swine"
  RunCmd "touch pig/file1 swine/file2"
  RunCmd "ln -s $TmpDir/swine/file2 pig/"
  RunCmd "sudo chown -R daemon:daemon swine"
  RunCmd "sudo chown -R bin:bin pig"
}

function do_test()
{
  RunCmd 'ls -la $TmpDir/swine/file2  |grep "daemon"'
}
do_setup
do_test
