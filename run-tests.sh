#!/bin/bash

# function failed(){
# 
# }

function clean_test_result(){
    if [ $# -lt 1 ]; then 
        ( >&2 echo "${FUNCNAME}: please specify the the location of the tests" )
        exit 1
    fi

    find $1 -iname "test-report" -type f -or -iname "output.diff" -type f -exec rm -v {} \;
} 

# TODO
# function all(){ 
#     if [ $# -lt 3 ]; then 
#     ( >&2 echo "Please specify the command to execute, the location of the tests and the location of your project" )
#     ( >&2 help )
#     exit 1
#     fi

#     echo "Run ALL Tests"
# }

function help(){
    echo ""
	echo "AVAILABLE COMMANDS:"
	cat `basename "$0"` | grep function | grep -v "__private" | grep -v "\#" | sed -e '/^ /d' -e 's|function \(.*\)(){|\1|g'
}

if [ $# -lt 1 ]; then 
    ( >&2 echo "Please specify the command to execute" )
    ( >&2 help )
    exit 1
fi

# Invoke functions by name
if declare -f "$1" > /dev/null
then
  # call arguments verbatim
  "$@"
else
  # Show a helpful error
  ( >&2 echo "'$1' is not a valid command" )
  help
 exit 1
fi
