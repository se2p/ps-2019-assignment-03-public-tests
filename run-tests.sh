#!/bin/bash

function clean_test_result(){
    if [ $# -lt 1 ]; then 
        ( >&2 echo "${FUNCNAME}: please specify the the location of the tests" )
        exit 1
    fi

    for file_to_delete in "test-report" "output.diff"; do
        find $1 -iname "${file_to_delete}" -type f -exec rm -v {} \;
    done
} 

function __find_tests_to_run(){
    find "$1" -iname "name" -exec dirname {} \;
}
function __find_tasks_to_test(){
    # Not robust but better than nothing
    find "$1" -iname "task-1" -type d -or \
             -iname "task-2" -type d -or \
             -iname "task-3" -type d -or \
             -iname "task-4" -type d
}

function __run_test_against_task(){

    TEST_HOME="$(realpath "$1")"
    TASK_HOME="$(realpath "$2")"
    # 
    ASSERTIONS_HOME="$(realpath "${TEST_HOME}/../../assertions")"

    # TODO Not sure if this is necessary or not...
    # SWAP the secret.code if there's one already (manual test)
    if [ -e ${TASK_HOME}/secret.code ]; then
        ( >&2 echo mv -v ${TASK_HOME}/secret.code ${TASK_HOME}/secret.code.orig)
    fi

    # Ensures that the secret.code defined inside the test is where it is supposed to be
    cp ${TEST_HOME}/secret.code ${TASK_HOME}

    # Move in test folder
    cd ${TEST_HOME}
        # Clean up stale report file.
        if [ -e test-report ]; then rm test-report; fi
    
        # Assert run.sh is there
        if [ ! -e ${TASK_HOME}/run.sh ]; then 
            ( >&2 echo "Cannot find run.sh " ) 2> >(sed 's/^/    /') | cat >> test-report
            return 1
        fi
    cd - > /dev/null

    # Move in task folder
    cd ${TASK_HOME}

        # Run Test

        cat ${TEST_HOME}/input | ./run.sh > ${TEST_HOME}/output 2> ${TEST_HOME}/error

    cd - > /dev/null

    # Clean up the project folder
    rm ${TASK_HOME}/secret.code

    # Restore the files that were there before execution
    # Not sure I will be able to recover from errors above and make sure the file is restored...
    if [ -e ${TASK_HOME}/secret.code.orig ]; then
        mv ${TASK_HOME}/secret.code.orig ${TASK_HOME}/secret.code
    fi
    
    # Move in test folder
    cd ${TEST_HOME}
        # Check common assertions game-assertions
        for A in $(find ${ASSERTIONS_HOME}/game-assertions/ -type f); do
            # Assumption is that assertion produces error messages in case they fail
            $A 2> >(sed 's/^/    /') | cat >> test-report
        done

        # If the test leads to a WON game, check won game assertions
        if [ "$(cat ${TEST_HOME}/game.result)" == "won" ]; then
            for A in $(find ${ASSERTIONS_HOME}/won-game-assertions/ -type f); do
                # Assumption is that assertion produces error messages in case they fail
                $A 2> >(sed 's/^/    /') | cat >> test-report
            done
        fi

        # If the test leads to a LOST game, check lost game assertions
        if [ "$(cat ${TEST_HOME}/game.result)" == "lost" ]; then
            for A in $(find ${ASSERTIONS_HOME}/lost-game-assertions/ -type f); do
                # Assumption is that assertion produces error messages in case they fail
                $A 2> >(sed 's/^/    /') | cat >> test-report
            done
        fi

        TEST_NAME=$(cat ${TEST_HOME}/name)
        TEST_TYPE="Public"
        if [ -e ${TEST_HOME}/private ]; then
            TEST_TYPE="Private"
        fi

        if [[ -s test-report ]]; then
            TEST_STATUS="FAILED"
        else
            TEST_STATUS="PASSED"
        fi

        echo "  ${TEST_NAME} ${TEST_STATUS} (${TEST_TYPE})" | cat - test-report > temp && mv temp test-report

    cd - > /dev/null

    # Clean up test execution files if the test passed
    if [ "${TEST_STATUS}" == "PASSED" ]; then
        rm ${TEST_HOME}/output      # Generated
        rm ${TEST_HOME}/output.diff # Generated
        rm ${TEST_HOME}/error       # Generated
    fi

    # Print to the console the result of running this test
    ( >&2 echo "" )
    ( >&2 cat ${TEST_HOME}/test-report )
}

function failed(){
     if [ $# -lt 2 ]; then 
        ( >&2 echo "${FUNCNAME}: please specify the location of the tests and the location of your project" )
        ( >&2 help )
        exit 1
    fi
    local tests_location=$1
    local project_location=$2
    for task in  $(__find_tasks_to_test $(realpath ${project_location}))
    do
        ( >&2 echo "" )
        ( >&2 echo "Testing ${task}" )
        
        for test in $(__find_tests_to_run $(realpath ${tests_location}))
        do
            if [ -e ${test}/test-report -a $(grep -c "FAILED" "${test}/test-report") == "1" ]; then
                $(__run_test_against_task ${test} ${task})
            else
                ( >&2 echo "Skip Test ${test}" )
            fi
        done
    done
}

function all(){ 
    if [ $# -lt 2 ]; then 
        ( >&2 echo "${FUNCNAME}: please specify the location of the tests and the location of your project" )
        ( >&2 help )
        exit 1
    fi
    local tests_location=$1
    local project_location=$2
    for task in  $(__find_tasks_to_test $(realpath ${project_location}))
    do
        ( >&2 echo "" )
        ( >&2 echo "Testing ${task}" )
        
        for test in $(__find_tests_to_run $(realpath ${tests_location}))
        do
            $(__run_test_against_task ${test} ${task})
        done
    done
}

function help(){
    echo ""
	echo "AVAILABLE COMMANDS:"
	cat `basename "$0"` | grep function | grep -v "__" | grep -v "\#" | sed -e '/^ /d' -e 's|function \(.*\)(){|\1|g'
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
