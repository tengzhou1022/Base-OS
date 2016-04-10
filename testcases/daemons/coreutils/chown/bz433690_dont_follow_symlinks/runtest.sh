rpm -Uvh http://nest.test.redhat.com/mnt/qa/scratch/pmuller/rhtslib/rhtslib.rpm


. /usr/bin/rhts-environment.sh
. /usr/share/rhts-library/rhtslib.sh

PACKAGE=coreutils
rlJournalStart


        rlPhaseStartSetup "Packages version"
        rlShowPackageVersion coreutils
        rlPhaseEnd

	rlPhaseStartSetup "Bug 433690"
rm -rf /tmp/swine /tmp/pig
rlRun "cd /tmp"
rlRun "mkdir -p pig swine"
rlRun "touch pig/file1 swine/file2"
rlRun "ln -s /tmp/swine/file2 pig/"
rlRun "chown -R daemon:daemon swine"
rlRun "chown -R bin:bin pig"

	rlPhaseEnd

rlPhaseStartTest
rlRun 'ls -la /tmp/swine/file2  |grep "daemon"'
rlPhaseEnd


rlPhaseStartCleanup "LOG and clean"
	rlLog "

`ls -la /tmp/swine/file2`
"
	rlRun "rm -rf /tmp/swine /tmp/pig"
rlPhaseEnd



rlJournalPrintText
