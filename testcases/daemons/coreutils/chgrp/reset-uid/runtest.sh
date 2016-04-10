#!/bin/bash
# ----------------------------------------------------------------------
# Filename:   runtest.sh
# Version:    1.0
# Date:       2016/03/30
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:    daemons/coreutils/chgrp/reset-uid
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
  RunCmd "sudo rm -rf $TmpDir" 0 "Removing tmp directory"
  EchoInfo "test daemons/coreutils/chgrp/reset-uid finish"
}
trap "CleanData" EXIT INT

function do_setup()
{
  RunCmd "TmpDir=\`mktemp -d\`" 0 "Creating tmp directory"
  RunCmd "pushd $TmpDir"
  AddUser $TESTUSER
}

function do_test()
{
  RunCmd "mkdir abc" 0 "mkdir testdir abc"
  RunCmd "touch abc/file" 0 "touch testfile file"
  RunCmd "ln -s ../abc/file abc/a.file" 0 "make symbolic links form file"
  RunCmd "sudo chown -v -R $TESTUSER abc" 0 "chown abc to $TESTUSER"
  RunCmd "sudo chgrp -v -R $TESTUSER abc" 0 "chown abc to $TESTUSER"
}

TESTUSER="test"

do_setup
do_test
