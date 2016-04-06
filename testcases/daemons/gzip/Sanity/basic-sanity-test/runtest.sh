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

function CleanData()
{
  RunCmd "popd"
  RunCmd "rm -r $TmpDir" 0 "Removing tmp directory"
  EchoInfo "gzip basic-sanity-test finish"
}
trap "CleanData" EXIT INT

function do_setup()
{
  ##安装gzip
  apt-get -y install gzip
  RunCmd "TmpDir=\`mktemp -d\`" 0 "Creating tmp directory"
  RunCmd "pushd $TmpDir"
}
function do_test()
{
  EchoInfo "---start test---"
  echo $TmpDir
  RunCmd "df -h $TmpDir"
  RunCmd "dd if=/dev/urandom of=somedata bs=501M count=1"

  RunCmd "cat somedata somedata > tmpfile"
  ls $TmpDir
  RunCmd "/bin/mv -f tmpfile somedata"
  RunCmd "SIZE=$(stat -c %s somedata)"
  EchoInfo "Testing with SIZE=$SIZE ($(( $SIZE / 1000000 )) MB)"
  RunCmd "MD5_1=$(md5sum somedata | awk '{print $1}')"
  RunCmd "gzip somedata"
  RunCmd "gunzip somedata.gz"
  RunCmd "MD5_2=$(md5sum somedata | awk '{print $1}')"
  RunCmd "[ "$MD5_1"=="$MD5_2" ]"
}
do_setup
do_test
