. ./Echo.sh
function RunCmd()
{
  GETOPT=$(getopt -q -o t -- "$@")
  eval set -- "$GETOPT"

  local DO_TAG=false
  local TAG_OUT=''
  local TAG_ERR=''
  local LOG_FILE=''

  while true ; do
        case "$1" in
            -t)
                DO_TAG=true;
                TAG_OUT='STDOUT: '
                TAG_ERR='STDERR: '
                shift;;
            --)
                shift;
                break;;
            *)
                shift;;
        esac
    done
  echo "111 $1"
  local command=$1

  if [[ -z "$3" ]];then
    comment="Running '$command'"
  else
    comment="$3"
  fi

  # here we can do various sanity checks of the $command
  if [[ "$command" =~ ^[[:space:]]*$ ]] ; then
      EchoInfo "RunCmd: got empty or blank command '$command'!"
      return 1
  fi

  if $DO_TAG ;then
    LOG_FILE=$(mktemp)
    eval "$command"  2> >(sed -u -e "s/^/$TAG_ERR/g" |tee -a $LOG_FILE) 1> >(sed -u -e "s/^/$TAG_OUT/g" | tee -a $LOG_FILE)
    cat $LOG_FILE

    EchoInfo "test $1"
  else
    echo $LOG_FILE
  #eval $command >/dev/ 2>&1
    if [[ -z $2 ]];then
      eval $command >/dev/null 2>&1
      if [ $? -eq 0 ];then
        EchoResult "$comment success"
      else
        EchoResult "$comment failed, pls check"
      fi
    else
        eval $command >/dev/null 2>&1
        local RESULT="$?"
        if [ $RESULT -eq $2 ];then
          EchoResult  "$comment success"
        else
          EchoResult  "$comment failed,pls check"
        fi
    fi
fi
}

RunCmd  -t "make --version"
