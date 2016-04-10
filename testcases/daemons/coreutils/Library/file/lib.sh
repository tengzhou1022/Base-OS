#!/bin/bash


fileFILENAME="foo"



##! @TODO:    Create a new file, name it accordingly and make sure (assert) that
##!           the file is successfully created.
##! @USAGE:   fileCreate [filename]
##! @AUTHOR:  tengzhou1022
##! @VERSION: 1.0
##! @OUT:
fileCreate() {
    local filename
    filename=${1:-$FILENAME}
    filename=${filename:-$fileFILENAME}
    RunCmd "touch '$filename'" 0 "Creating file '$filename'"
    CheckExists "$filename"
}
