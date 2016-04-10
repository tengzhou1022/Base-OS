#!/bin/bash
# ----------------------------------------------------------------------
# Filename:   runtest.sh
# Version:    1.0
# Date:       2016/03/30
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:    daemons/coreutils/Library/file
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
. ./lib.sh

function CleanData()
{
  RunCmd "popd"
  RunCmd "rm -r $TmpDir" 0 "Removing tmp directory"
  EchoInfo "test daemons/coreutils/Library/file finish"
}
trap "CleanData" EXIT INT

function do_setup()
{
  ##安装coreutils包，此处待确认方法
  RunCmd "TmpDir=\`mktemp -d\`" 0 "Creating tmp directory"
  RunCmd "pushd $TmpDir"
}

PACKAGE="coreutils"
PHASE=${PHASE:-Test}

function do_test()
{
  if [[ "$PHASE" =~ "Create" ]]; then
    EchoInfo "Create"
    fileCreate
  fi


  if [[ "$PHASE" =~ "Test" ]]; then
    EchoInfo "===Test default name==="
    fileCreate
    CheckExists "$fileFILENAME"

    EchoInfo "===Test filename in parameter==="
    fileCreate "parameter-file"
    CheckExists "parameter-file"

    EchoInfo "===Test filename in variable==="
    FILENAME="variable-file" fileCreate
    CheckExists "variable-file"
  fi
}
do_setup
do_test
