#!/bin/bash
# ----------------------------------------------------------------------
# Filename:   runtest.sh
# Version:    1.0
# Date:       2016/03/30
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:    daemons/coreutils/chgrp/bz436624_preserve_root
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
  EchoInfo "test daemons/coreutils/chgrp/bz436624_preserve_root finish"
}
trap "CleanData" EXIT INT

function do_setup()
{
  RunCmd "TmpDir=\`mktemp -d\`" 0 "Creating tmp directory"
  RunCmd "pushd $TmpDir"
}

function do_test()
{
  EchoInfo "===Bug 474232 - smoke test==="
  RunCmd "touch bug474232"
  RunCmd "sudo chgrp --preserve-root bin bug474232"
  RunCmd "ls -la /tmp/bug474232 | grep bin"
}

do_setup
do_test
