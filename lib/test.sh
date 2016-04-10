. ./Echo.sh
. ./Check.sh

fileCreate() {
    local filename
    filename=${1:-$FILENAME}
    filename=${filename:-$fileFILENAME}
    RunCmd "touch '$filename'" 0 "Creating file '$filename'"
    CheckExists "$filename"
    EchoResult "$filename found"
}
PHASE=${PHASE:-Test}
echo "PHASE=${PHASE}"
if [[ "$PHASE" =~ "Test" ]]; then
fileCreate
CheckExists "$fileFILENAME"
else
  echo fwfewfwe
fi
#fileCreate
