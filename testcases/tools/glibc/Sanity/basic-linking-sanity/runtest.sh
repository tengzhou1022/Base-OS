#!/bin/bash
# ----------------------------------------------------------------------
# Filename:   runtest.sh
# Version:    1.0
# Date:       2016/03/30
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:
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
  EchoInfo "test  finish"
}
trap "CleanData" EXIT INT

function do_setup()
{
  RunCmd "TmpDir=\`mktemp -d\`" 0 "Creating tmp directory"
  RunCmd "cp lc.c  lc.golden  lm.c  lm.golden  lpthread.c  lpthread.golden  lrt.c  lrt.golden $TmpDir"
  RunCmd "pushd $TmpDir"
}

function do_Compiling_test()
{
  EchoInfo "Compiling"
  RunCmd "gcc lc.c -lc -o lc -fno-builtin" 0 "Testing for -lc linkage"
  RunCmd "gcc lm.c -lm -o lm -fno-builtin" 0 "Testing for -lm linkage"
  RunCmd "gcc lrt.c -lrt -o lrt -fno-builtin" 0 "Testing for -lrt linkage"
  RunCmd "gcc lpthread.c -lpthread -o lpthread -fno-builtin" 0 "Testing for -lpthread linkage"
}
function do_test()
{
  RunCmd "./lc" 0 "Running lc testcase"
  RunCmd "./lm" 0 "Running lm testcase"
  RunCmd "./lrt" 0 "Running lrt testcase"
  RunCmd "./lpthread" 0 "Running lpthread testcase"

  CheckNotDiffer "lc.out" "lc.golden"
  CheckNotDiffer "lm.out" "lm.golden"
  CheckNotDiffer "lrt.out" "lrt.golden"
  CheckNotDiffer "lpthread.out" "lpthread.golden"
}
do_setup
do_Compiling_test
