#!/bin/bash

# Use default names instead of parameters
EXPECTED_OUTPUT_FILE=expected.output
OUTPUT_FILE=output
DIFF_FILE=output.diff
INPUT_FILE=input
SECRET_CODE_FILE=secret.code 

FAIL_MESSAGE="Output is different"

# Check output by diff
diff --strip-trailing-cr ${EXPECTED_OUTPUT_FILE} ${OUTPUT_FILE} > ${DIFF_FILE} 2>&1

error=$?
if [ ! $error -eq 0 ]; then
   >&2 echo "${FAIL_MESSAGE}"
fi

