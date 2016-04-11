#!/bin/bash
# ----------------------------------------------------------------------
# Filename:   runtest.sh
# Version:    1.0
# Date:       2016/03/30
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:    daemons/setup/Sanity/Basic-sanity-test
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
  EchoInfo "test daemons/setup/Sanity/Basic-sanity-test finish"
}
trap "CleanData" EXIT INT

function do_setup()
{
  #sudo apt-get -y install
  RunCmd "TmpDir=\`mktemp -d\`" 0 "Creating tmp directory"
  RunCmd "pushd $TmpDir"
}

function do_test()
{
  CheckExists "/etc/aliases"
  CheckExists "/etc/bashrc"
  CheckExists "/etc/csh.cshrc"
  CheckExists "/etc/csh.login"
  CheckExists "/etc/environment"
  CheckExists "/etc/exports"
  CheckExists "/etc/filesystems"
  CheckExists "/etc/fstab"
  CheckExists "/etc/group"
  CheckExists "/etc/gshadow"
  CheckExists "/etc/host.conf"
  CheckExists "/etc/hosts"
  CheckExists "/etc/hosts.allow"
  CheckExists "/etc/hosts.deny"
  CheckExists "/etc/inputrc"
  CheckExists "/etc/motd"
  CheckExists "/etc/mtab"
  CheckExists "/etc/passwd"
  CheckExists "/etc/printcap"
  CheckExists "/etc/profile"
  CheckExists "/etc/profile.d"
  CheckExists "/etc/protocols"
  CheckExists "/etc/securetty"
  CheckExists "/etc/services"
  CheckExists "/etc/shadow"
  CheckExists "/etc/shells"
  CheckExists "/var/log/lastlog"

}
do_setup
do_test
