#!/bin/bash
# ----------------------------------------------------------------------
# Filename:   runtest.sh
# Version:    1.0
# Date:       2016/03/30
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:    tools/make/Sanity/smoke-check-make-runs
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
  RunCmd "rm -r $TmpDir" 0 "Removing tmp directory"
  EchoInfo "test tools-make-Sanity-smoke-check-make-runs finish"
}
trap "CleanData" EXIT INT

function do_setup()
{
  RunCmd "TmpDir=\`mktemp -d\`" 0 "Creating tmp directory"
  RunCmd "cp hello_world.c $TmpDir"
  RunCmd "cp smoke.mk $TmpDir/Makefile"
  RunCmd "pushd $TmpDir"
}

function do_test()
{
  RunCmd -t "make -v"
  CheckNotGrep '^STDERR:' $RunCmd_LOG_FILE
  CheckGrep '^STDOUT: GNU Make [0-9]' $RunCmd_LOG_FILE
  CheckNotExists 'hello_world'
  EchoInfo $RunCmd_LOG_FILE
  RunCmd 'make'
  CheckExists 'hello_world'
  RunCmd './hello_world'
  RunCmd 'make clean'
  CheckNotExists 'hello_world'
}
do_setup
do_test
