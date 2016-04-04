#!/bin/bash

# ----------------------------------------------------------------------
# Filename:   FileOps.sh
# Version:    1.0
# Date:       2016/03/28
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:    File or Dir operations
# Notes:      Include create,delete,unmount dir; get the absolute path
# History：
#             Version 1.0, 2016/03/28
#             - add file functions, CreateDir, DeleteDir, UnmountDir, RealPwd
# ----------------------------------------------------------------------

source "${SFROOT}/lib/Echo.sh"
##! @TODO: Create directory more compatiblely.
##!        1. Judge according to the Return_Value. 0 => PASS; else => FAIL
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @OUT:  return value.
function CreateDir()
{
    local RET=0
    if [ $# -eq 1 ]
    then
        if [ -d $1 ]
        then
            EchoInfo "Directory already exists."
            RET=0
        elif [ -e $1 ]
        then
            mv $1 $1"."$(date +%Y.%m.%d-%H:%M:%S)".bak"
            mkdir $1
            EchoInfo "The raw file backuped as $1"."$(date +%Y.%m.%d-%H:%M:%S)".bak". Directory create successfully."
            RET=0
        else
            mkdir $1
            EchoInfo "Directory create successfully."
            RET=0
        fi
    else
        EchoInfo "You Must input only one parameter. Usage: CreateDir [DIR]"
        RET=1
    fi
    return $RET
}

##! @TODO: Delete directories and files more compatiblely.
##!        1. Judge according to the Return_Value. 0 => PASS; else => FAIL
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @OUT:  return value.
function DeleteDir()
{
    local RET=0
    if [ $# -eq 1 ]
    then
        if [ -e $1 ]
        then
            rm -rf $1
            EchoInfo "The directory deleted successfully."
            RET=0
        else
            EchoInfo "The directory doesn't exist."
            RET=0
        fi
    else
        EchoInfo "You Must input only one parameter. Usage: DeleteDir [DIR]"
        RET=1
    fi
    return $RET
}


##! @TODO: Unmount filesystem more compatiblely.
##!        1. Judge according to the Return_Value. 0 => PASS; else => FAIL
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @OUT:  return value.
function UnmountDir()
{
    local RET=0
    if [ $# -eq 1 ]
    then
        local INPUT_DIR=$(echo $1 | sed  's#/\{1,\}#/#g')"/"
        local INPUT_DIR=$(echo $INPUT_DIR | sed 's#/$##g')
        if [ -d $INPUT_DIR ]
        then
            MOUNT_COUNT=$(mount | awk -v mount="$INPUT_DIR" '{if($3==mount){print "found mounted!"}}' | wc -l)
            if [ $MOUNT_COUNT -gt 0 ]
            then
                umount $INPUT_DIR
                if [ $? -eq 0 ]
                then
                    EchoInfo "The filesystem  unmounted successfully."
                    RET=0
                else
                    EchoInfo "The filesystem umounting faild."
                    RET=1
                fi
            else
                EchoInfo "There isn't any filesystem mounted to $INPUT_DIR."
            RET=1
            fi
        else
            EchoInfo "$INPUT_DIR directory that gonna umount does'nt exist."
            RET=1
        fi
    else
        EchoInfo "You Must input only one parameter. Usage: UnmountDir [DIR]"
        RET=1
    fi
    return $RET
}

##! @TODO: Get the real path of the runtime function.
##!        1. Judge according to the Return_Value. 0 => PASS; else => FAIL
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @OUT:  return value.
function RealPwd()
{
    local RET=0
    if [ $# -eq 0 ]
    then
        echo $(cd $(dirname $0); pwd)
        if [ $? -eq 0 ]
        then
            RET=0
        else
            EchoInfo "Get the path fail."
            RET=1
        fi
    else
        EchoInfo "There're some mistake about the input parameters. The 'RealPwd' function doesn't need any input parameter."
        RET=1
    fi
    return $RET
}
