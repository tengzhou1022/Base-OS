#!/bin/bash
# ----------------------------------------------------------------------
# Filename:   runtest.sh
# Version:    1.0
# Date:       2016/03/30
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:    daemons/gzip/Sanity/basic-sanity-test
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
  EchoInfo "gzip test-of-4G-file-comp-decomp finish"
}
trap "CleanData" EXIT INT
function do_setup()
{
##安装gzip 此处待处理成为库hanshu
  apt-get install -f gzip
  RunCmd "TmpDir=\`mktemp -d\`" 0 "Creating tmp directory"
  RunCmd "pushd $TmpDir"
}
function do_test()
{
  RunCmd "dd if=/dev/zero  bs=1M count=4100 | gzip >  out.gz"
  CheckExists "out.gz"
  RunCmd "gunzip <out.gz >out; ls -sh out"
  CheckExists "out"
}
do_setup
do_test
