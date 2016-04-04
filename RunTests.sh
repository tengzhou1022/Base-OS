#!/bin/bash

# ----------------------------------------------------------------------
# Filename:   RunTests.sh
# Version:    1.2
# Date:       2016/03/28
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:    Test Driver
# Notes:      ***
# History：
#             Version 1.0, 2016/03/28
#             - The first one, can parse the TestCases XML, find the script for each testcase, and excute them by order
#             - Add log
#             - Pick up the function "RunCase"
#             - Add SFROOT;
#             - Change Runcase $arguments
#             - Add 'debug.log' file color control character handle
#             - Change CURRENT_DIR with SFROOT
# ----------------------------------------------------------------------

function Usage()
{
    echo -e "--USAGE--\n\"Normal Run\":sh `basename $0`"
}

##! @TODO: Run a case and log its result
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @IN: $1 => the order number of the case
##! @OUT: Put results into the results-stored file
function RunCase()
{
    LogSummary ${CASE_SUMMARY["$1"]} $2
    cd ${TESTCASE_DIR}/${CASE_DIR["$1"]}
    bash ${TESTCASE_DIR}/${CASE_DIR["$1"]}/${CASE_SCRIPT["$1"]} >> ${LOGDIR}/debug.log 2>&1
    LogResult ${CASE_SUMMARY["$1"]}
}

##! @TODO: Run Tests by order
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @IN: $1 => XmlParse.sh Log.sh
##! @IN: $2 => TestGroup.xml
##! @OUT: 0 => success; else => failure
function RunTest()
{
    local TESTCASE_DIR="${SFROOT}/testcases"
    local CONFIG_DIR="${SFROOT}/config"
    local LIB_DIR="${SFROOT}/lib"
    local TESTGROUP_XML="${CONFIG_DIR}/TestGroup.xml"
    local i=0
    local j=0
    local k=0

    #Load APIs in lib/XmlPrase.sh lib/Log.sh
    source ${LIB_DIR}/XmlParse.sh
    source ${LIB_DIR}/Log.sh

    #Parse the TestGroup XML, put all the labels into arrays
    XmlParse ${TESTGROUP_XML}

    #Get the count of components
    GetNumber GROUP_NUM GroupName

    #Get the necessary informations of each component
    GetValue GROUP_NAME GroupName
    GetValue COMPONENT Component
    GetValue GROUP_RUN GroupRun
    GetValue GROUP_ALL GroupAll

    #Start Log
    LogStart

    #According to the Run_Flag, Run the tests
    for((i=0;i<${GROUP_NUM};i++))
    do
        if [ ${GROUP_RUN[i]} == "True" ]
        then
            local p=0
            #Log the information of the component
            LogComponent ${COMPONENT[i]}

            SINGLE_GROUP_XML="${CONFIG_DIR}/${GROUP_NAME[i]}.xml"

            #Parse the specific group XML，put all the labels into arrays
            XmlParse ${SINGLE_GROUP_XML}

            #Get the count of cases
            GetNumber CASE_NUM Summary

            #Get the necessary informations of each case
            GetValue CASE_SUMMARY Summary
            GetValue CASE_DIR Dir
            GetValue CASE_SCRIPT Script
            GetValue CASE_RUN CaseRun

            #According to the Run_Flag, execute each case by order
            if [ ${GROUP_ALL[i]} == "True" ]
            then
                for((j=0;j<${CASE_NUM};j++))
                do
                    #Run cases and log results
                        p=`expr $p + 1`
                        RunCase $j $p
                done
            else
                for((k=0;k<${CASE_NUM};k++))
                do
                    if [ ${CASE_RUN[k]} == "True" ]
                    then
                        p=`expr $p + 1`
                        RunCase $k $p
                    fi
                done
            fi
        fi
    done

    sed -i 's/[[:cntrl:]]\[[[:digit:]]*m//g' ${LOGDIR}/debug.log
    #Analyz the Log
    LogAnalyse

    return 0
}


# shellframe root path
PROFILE="/root/.bashrc"
export SFROOT=`echo $(cd $(dirname $0); pwd)`
sed -i '/SFROOT/d' ${PROFILE}
echo "export SFROOT=${SFROOT}" >> ${PROFILE}
source ${PROFILE}

unset PROFILE
###
RunTest
