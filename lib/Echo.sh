#!/bin/bash

# ----------------------------------------------------------------------
# Filename:   Echo.sh
# Version:    1.0
# Date:       2016/03/28
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:    Format the output of steps in each testcase
# Notes:      Include EchoInfo and EchoResult
# History：
#             Version 1.0, 2016/03/28
#             - The first one
# ----------------------------------------------------------------------

##! @TODO: Echo Time "**:**:**"
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @OUT: Time
function EchoTime()
{
    date +%T
}

##! @TODO: Format Output
##!        Output following this format "${Time} INFO | ${output information}"
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @OUT: The formatted output
function EchoInfo()
{
    local TIME=$(EchoTime)
    echo "${TIME} INFO | $1"
    return 0
}

##! @TODO: Automatically judge and Format the result of each step
##!        1. Judge according to the Return_Value. 0 => PASS; else => FAIL
##!        2. Output following this format "${Time} PASS | ${Step's Name}"
##! @AUTHOR: tengzhou1022
##! @CHANGELOG: 01 Print the result with colour by tengzhou1022@gmail.com 2013-11-25
##! @VERSION: 1.0
##! @OUT:  The formatted result of each step
function EchoResult()
{
    local RESULT="$?"
    local TIME=$(EchoTime)

    if [ ${RESULT} -eq 0 ]
    then
        echo -e "${TIME}\033[32m PASS\033[0m | $1"
        return 0
    else
        echo -e "${TIME}\033[31m FAIL\033[0m | $1"
        exit 1
    fi
    return 0
}
