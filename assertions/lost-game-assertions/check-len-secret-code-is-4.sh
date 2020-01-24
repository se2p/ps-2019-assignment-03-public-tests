#!/bin/bash

# Use default names instead of parameters
OUTPUT_FILE=output

FAIL_MESSAGE="Secret code has wrong number of digits"

SCODE=$(tail -1 ${OUTPUT_FILE} | sed 's/>> The secret code was: //');

if [ ! "${#SCODE}" -eq "4" ]; then
    >&2 echo "${FAIL_MESSAGE}"
fi

