#!/bin/bash

# ----------------------------------------------------------------------
# Filename:   XmlParse.sh
# Version:    1.0
# Date:       2016/03/28
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:    Parse a xml file, get the count and value of each label
# Notes:      Include XmlParse\GetValue\GetNumber
# History：
#             Version 1.0, 2016/03/28
#             - The first one
# ----------------------------------------------------------------------

##! @TODO: Parse a xml file, put the label value into arrays
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @IN: $1 => The name of the xml file
##! @OUT: 0 => success; else => failure
function XmlParse()
{
    local XML_LABEL=(`sed -n 's/.*<\/\(.*\)>/\1/p' $1 | sort | uniq `)
    local XML_LABEL_NUM=${#XML_LABEL[@]}
    local index=0

    for((index=0;index<${XML_LABEL_NUM};index++))
    do
        eval ${XML_LABEL[index]}="(`sed -n 's/.*>\(.*\)<\/'${XML_LABEL[index]}'>/\1/p' $1`)"
    done
    return 0
}

##! @TODO: Get the label value into a specific array
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @IN: $1 => A label name in the xml file
##! @OUT: 0 => success; else => failure
function GetValue()
{
    local VALUE_NAME="\${$2[*]}"
    local VALUE_STR=`eval echo "${VALUE_NAME}"`

    eval $1=`echo "($VALUE_STR)"`
    return 0
}

##! @TODO: Get the count of the labels which have the same name)
##! @AUTHOR: tengzhou1022
##! @VERSION: 1.0
##! @IN: $1 => A label name in the xml file
##! @OUT: 0 => success; else => failure
function GetNumber()
{
    local NUMBER_NAME="\${#$2[@]}"

    eval $1=`echo "${NUMBER_NAME}"`
    return 0
}
