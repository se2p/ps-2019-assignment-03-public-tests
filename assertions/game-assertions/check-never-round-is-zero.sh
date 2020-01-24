#!/bin/bash

# Use default names instead of parameters
EXPECTED_OUTPUT_FILE=expected.output
OUTPUT_FILE=output

FAIL_MESSAGE="Round is zero"

# Check output by diff
if [ $(cat ${OUTPUT_FILE} | grep ">> Guess the" | grep -c "(0)") -gt 0 ]; then
   >&2 echo "${FAIL_MESSAGE}"
fi

