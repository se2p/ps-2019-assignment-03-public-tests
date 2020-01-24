#!/bin/bash

# Use default names instead of parameters
EXPECTED_OUTPUT_FILE=expected.output
OUTPUT_FILE=output

FAIL_MESSAGE="HD is zero"

# Check output by diff
if [ $(cat ${OUTPUT_FILE} | grep -c "HD=0") -gt 0 ]; then
   >&2 echo "${FAIL_MESSAGE}"
fi

