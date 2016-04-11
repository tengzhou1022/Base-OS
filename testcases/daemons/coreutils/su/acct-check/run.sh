#!/bin/bash

#
# This test checks whether su does proper account checks when (and only when) it is appropriate.
#
# Tomas Mraz <tmraz@redhat.com>
#

set -x

runsu() {
RUSERNAME=$1
USERNAME=$2
# runs su with entering a password
sudo su - $RUSERNAME -c "su - $USERNAME -c true"
}

export LANG=C

USERNAME1="testuser1"
USERNAME2="testuser2"

sudo userdel -r $USERNAME1 &> /dev/null
sudo adduser $USERNAME1

sudo userdel -r $USERNAME2 &> /dev/null
sudo adduser $USERNAME2
# no password so we do not have to enter it
sudo passwd -d $USERNAME2

# mark account 2 expired
sudo chage -E 0 $USERNAME2

# this should succeed
runsu root $USERNAME2

if [ "$?" -eq "0" ]; then
	echo "...PASS"
else
	echo "...FAIL"
fi

# this should fail
runsu $USERNAME1 $USERNAME2

if [ "$?" -ne "0" ]; then
	echo "...PASS"
else
	echo "...FAIL"
fi

sudo userdel -r $USERNAME1

sudo userdel -r $USERNAME2
