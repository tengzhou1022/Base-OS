. ./Echo.sh
. ./Check.sh
. ./RunCmd.sh

fileCreate() {
    local filename
    filename=${1:-$FILENAME}
    filename=${filename:-$fileFILENAME}
    echo "1create name $filename"
    RunCmd "touch '$filename'" 0 "Creating file '$filename'"
    echo "2create name $filename"
    CheckExists "$filename"
    EchoResult "$filename found"
}

fileFILENAME="foo"
PHASE=${PHASE:-Test}
echo "PHASE=${PHASE}"
if [[ "$PHASE" =~ "Create" ]]; then
  EchoInfo "Create"
  fileCreate
fi



if [[ "$PHASE" =~ "Test" ]]; then
  EchoInfo "===Test default name==="
  fileCreate
  CheckExists "$fileFILENAME"

  EchoInfo "===Test filename in parameter==="
  fileCreate "parameter-file"
  CheckExists "parameter-file"

  EchoInfo "===Test filename in variable==="
  FILENAME="variable-file" fileCreate
  CheckExists "variable-file"
else
  echo fwfewfwe
fi
#fileCreate
