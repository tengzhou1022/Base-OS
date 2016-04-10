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

  rlRun "truncate -s 80M $DISKIMG"
  rlRun "mkfs.ext4 -F $DISKIMG"
  rlRun "mkdir $NFSP $DISKM"
  rlRun "mount -o loop,acl $DISKIMG $DISKM"
  StartDaemon nfs
  #nfs-kernel-server: /usr/sbin/exportfs
  rlRun "exportfs -o rw,fsid=0,no_root_squash localhost:$DISKM/"
}

function do_test()
{
  EchoInfo "umask mask:`umask`"
  RunCmd "cd $DISKM"
  rlRun "touch a" 0 "touching a"
  rlRun "setfacl -m u:root:rw a" 0 "set acl for a"
  rlRun "mount -t nfs4 localhost:/ $NFSP"

  rlRun "cd $NFSP" 0 "changed dir to nfs mount point"
  rlRun "cp a b" 0 "normal copy"
  rlRun "cp -a a c" 0 "archive copy"
  rlRun "cp --preserve=xattr a d " 0 " cp with preserve xattr "
  rlRun "cp --preserve=all a e  " 0 " cp with preserve all "

  rlRun "cd $DISKM" 0 "changed dir to disk"
  rlRun "getfacl a | tee | grep '^[^#]' > test.a" 0 "get ACL for a"
  rlRun "getfacl b | tee | grep '^[^#]' > test.b" 0 "get ACL for b"
  rlRun "getfacl c | tee | grep '^[^#]' > test.c" 0 "get ACL for c"
  rlRun "getfacl d | tee | grep '^[^#]' > test.d" 0 "get ACL for d"
  rlRun "getfacl e | tee | grep '^[^#]' > test.e" 0 "get ACL for e"

  rlLog "Important part, filelist: `ls`"
  rlRun " diff test.a test.b " 1 "a b should be different"
  rlRun " diff test.a test.c " 0 "a c should be same (--archive/-a) "
  rlRun " diff test.a test.e " 0 "a e should be same (preserve all) "

}
do_setup
do_test
