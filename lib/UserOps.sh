#!/bin/bash

# ----------------------------------------------------------------------
# Filename:   UserOps.sh
# Version:    1.0
# Date:       2016/03/28
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:    User operations
# Notes:
# History：
#             Version 1.0, 2016/03/28
#             - The first one
#             - Add function AddUserPasswd
#
# ----------------------------------------------------------------------

##! @TODO: Add user, and passwd user
##!        Arg1: user name
##!        Arg2: password
##!        Arg3: -g
##!        Arg4: group
##!        Usage: AddUserPasswd username password -g group
##!        Usage: AddUserPasswd username password
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @OUT: 0 => PASS; 1 => FAIL
function AddUserPasswd()
{
    USER=$1
    PASSWORD=$2


    # check user exists, if exists then delete
    id -ru ${USER} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        userdel -r ${USER}
        if [ $? -ne 0 ];then
            echo "${USER} del failed."
            exit 1
        fi
    fi

    # check $3 is -g
    if [ "$3" = "-g" ];then
        GROUP=$4
        # group
        useradd -m ${USER} -g ${GROUP}
    else
        useradd -m ${USER}
    fi

    if [ $? -ne 0 ];then
        echo "${USER} add failed."
        exit 1
    fi

     expect <<-END
        spawn passwd ${USER}
            expect  {
                -re "(N|n)ew password:"  {
                    send "${PASSWORD}\r"
                    exp_continue
                }

                "Unknown user name" {
                    send_user "${USER} not exists\n"
                    exit 1
                }

                "Weak password: too short." {
                    send_user "Your password is too short\n"
                    exit 1
                }
            }


        catch wait result
        exit [lindex \$result 3]

END

}


##! @TODO: Check user is root
##!
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @OUT: 0 => PASS; 1 => FAIL
function IsRoot()
{
    [ "x$(id -ru $1)" = "x0" ]

}
