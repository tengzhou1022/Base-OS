#!/bin/bash
# ----------------------------------------------------------------------
# Filename:   runtest.sh
# Version:    1.0
# Date:       2016/03/30
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:    daemons/zip/Functionality/stress-tests/big-file-in-archive
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
  RunCmd "rm -f $file2gb $file3gb $file4gb $archive2gb $archive3gb $archive4gb" 0 "Removing test files"
  EchoInfo "test ddaemons/zip/Functionality/stress-tests/big-file-in-archive finish"
}
trap "CleanData" EXIT INT

function do_setup()
{
  sudo apt-get -y install zip
  EchoInfo "===Creating test files==="
  RunCmd "dd if=/dev/zero of=$file2gb bs=1M count=2048" 0 "Creating 2GB file"
  RunCmd "dd if=/dev/zero of=$file3gb bs=1M count=3056" 0 "Creating 3GB file"
  RunCmd "dd if=/dev/zero of=$file4gb bs=1M count=4096" 0 "Creating 4GB file"


}

function do_test()
{
  EchoInfo "===Starting test==="
  rm $archive2gb $archive3gb $archive4gb >/dev/null 2>&1 #remove archive temp files, we just need unused temp names
  RunCmd "zip $archive2gb $file2gb" 0 "Archiving 2GB file"
  RunCmd "zip $archive3gb $file3gb" 0 "Archiving 3GB file"
  RunCmd "zip $archive4gb $file4gb" 0 "Archiving 4GB file"
  RunCmd "rm -f $file2gb $file3gb $file4gb" 0 "Removing original files"
  RunCmd "unzip $archive2gb -d /" 0 "Unpacking 2GB file"
  RunCmd "unzip $archive3gb -d /" 0 "Unpacking 3GB file"
  RunCmd "unzip $archive4gb -d /" 0 "Unpacking 4GB file"
  CheckEquals "Checking new 2GB file size" `stat -c %s $file2gb` 2147483648
}

file2gb=`mktemp /var/tmp/tmp.XXXXXXXX`
file3gb=`mktemp /var/tmp/tmp.XXXXXXXX`
file4gb=`mktemp /var/tmp/tmp.XXXXXXXX`
archive2gb=`mktemp /var/tmp/tmp.XXXXXXXX`
archive3gb=`mktemp /var/tmp/tmp.XXXXXXXX`
archive4gb=`mktemp /var/tmp/tmp.XXXXXXXX`
do_setup
do_test
