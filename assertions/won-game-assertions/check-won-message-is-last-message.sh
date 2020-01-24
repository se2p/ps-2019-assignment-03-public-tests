#!/bin/bash

# Use default names instead of parameters
OUTPUT_FILE=output

FAIL_MESSAGE="Wrong Won Message"

if [ ! "$(tail -1 ${OUTPUT_FILE})" == ">> Correct - You won!" ]; then
    >&2 echo "${FAIL_MESSAGE}"
fi

