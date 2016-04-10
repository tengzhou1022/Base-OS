#!/bin/bash
# ----------------------------------------------------------------------
# Filename:   runtest.sh
# Version:    1.0
# Date:       2016/03/30
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:    daemons/coreutils/Sanity/bz454072-RHEL-5-1-cp-and-chmod-don-t-respect-NFSv4-ACLs
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
. ${SFROOT}/lib/NetOps.sh

function CleanData()
{
  RunCmd "popd"
  RunCmd "umount $NFSP"
  RunCmd "sudo rm -r $TmpDir" 0 "Removing tmp directory"
  EchoInfo "test daemons/coreutils/Sanity/bz454072-RHEL-5-1-cp-and-chmod-don-t-respect-NFSv4-ACLs finish"
}
trap "CleanData" EXIT INT

function do_setup()
{
  RunCmd "TmpDir=\`mktemp -d\`" 0 "Creating tmp directory"
  RunCmd "pushd $TmpDir"
  DISKIMG=$TmpDir/disk.img
  DISKM=$TmpDir/disk
  NFSP=$TmpDir/mountpoint

  RunCmd "truncate -s 80M $DISKIMG"
  RunCmd "mkfs.ext4 -F $DISKIMG"
  RunCmd "mkdir $NFSP $DISKM"
  RunCmd "mount -o loop,acl $DISKIMG $DISKM"
  StartDaemon nfs
  #nfs-kernel-server: /usr/sbin/exportfs
  RunCmd "exportfs -o rw,fsid=0,no_root_squash localhost:$DISKM/"
}

function do_test()
{
  EchoInfo "umask mask:`umask`"
  RunCmd "cd $DISKM"
  RunCmd "touch a" 0 "touching a"
  RunCmd "setfacl -m u:root:rw a" 0 "set acl for a"
  RunCmd "mount -t nfs4 localhost:/ $NFSP"

  RunCmd "cd $NFSP" 0 "changed dir to nfs mount point"
  RunCmd "cp a b" 0 "normal copy"
  RunCmd "cp -a a c" 0 "archive copy"
  RunCmd "cp --preserve=xattr a d " 0 " cp with preserve xattr "
  RunCmd "cp --preserve=all a e  " 0 " cp with preserve all "

  RunCmd "cd $DISKM" 0 "changed dir to disk"
  RunCmd "getfacl a | tee | grep '^[^#]' > test.a" 0 "get ACL for a"
  RunCmd "getfacl b | tee | grep '^[^#]' > test.b" 0 "get ACL for b"
  RunCmd "getfacl c | tee | grep '^[^#]' > test.c" 0 "get ACL for c"
  RunCmd "getfacl d | tee | grep '^[^#]' > test.d" 0 "get ACL for d"
  RunCmd "getfacl e | tee | grep '^[^#]' > test.e" 0 "get ACL for e"

  EchoInfo "Important part, filelist: `ls`"
  RunCmd " diff test.a test.b " 1 "a b should be different"
  RunCmd " diff test.a test.c " 0 "a c should be same (--archive/-a) "
  RunCmd " diff test.a test.e " 0 "a e should be same (preserve all) "

}
do_setup
do_test
